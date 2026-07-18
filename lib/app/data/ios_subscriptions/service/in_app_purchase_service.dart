import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:get/get_connect/connect.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/shared_prefe/shared_prefe.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:url_launcher/url_launcher.dart';

/// iOS-specific in-app purchase service.
///
/// Mirrors the callback contract of [SubscriptionService] so the shared
/// [SubscriptionController] can swap between Android and iOS implementations
/// without changing any UI code.
class IosSubscriptionService {
  static const String yearlyProductId = 'premium_yearly';
  static const String monthlyProductId = 'premium_monthly';

  // All product IDs queried at purchase time.
  static const Set<String> _productIds = {yearlyProductId, monthlyProductId};

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  bool _isAvailable = false;
  bool _isPurchased = false;
  String? _activeProductId;

  // Tracks whether the current purchase stream event was triggered by the
  // user tapping the buy button (vs. an automatic restore on app launch).
  bool _userInitiatedPurchase = false;

  bool get isAvailable => _isAvailable;
  bool get isPurchased => _isPurchased;
  String? get activeProductId => _activeProductId;

  /// Called when a purchase is confirmed and verified.
  final void Function(bool isPurchased)? onPurchaseUpdated;

  /// Called when a non-recoverable error occurs.
  final void Function(String error)? onError;

  IosSubscriptionService({this.onPurchaseUpdated, this.onError});

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  Future<void> initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (!_isAvailable) {
      debugPrint('❌ [iOS IAP] App Store not available');
      return;
    }

    _purchaseSubscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (Object error) {
        debugPrint('❌ [iOS IAP] Purchase stream error: $error');
        onError?.call(error.toString());
      },
    );

    debugPrint('✅ [iOS IAP] IosSubscriptionService initialized');
  }

  // ---------------------------------------------------------------------------
  // Buy
  // ---------------------------------------------------------------------------

  Future<void> buySubscription(String productId) async {
    if (!_isAvailable) throw Exception('App Store not available');

    _userInitiatedPurchase = true;

    final ProductDetailsResponse response =
        await _iap.queryProductDetails({productId});

    if (response.error != null) {
      _userInitiatedPurchase = false;
      throw Exception(
          '[iOS IAP] Product query error: ${response.error!.message}');
    }

    if (response.productDetails.isEmpty) {
      _userInitiatedPurchase = false;
      throw Exception('[iOS IAP] Product not found: $productId');
    }

    final ProductDetails product = response.productDetails.first;

    // For iOS subscriptions, buyNonConsumable is correct — the App Store
    // product type handles the subscription semantics.
    final PurchaseParam param = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  // ---------------------------------------------------------------------------
  // Restore (iOS requirement)
  // ---------------------------------------------------------------------------

  /// Triggers a restore-purchases flow. Restored transactions arrive through
  /// the purchase stream with [PurchaseStatus.restored].
  Future<void> restorePurchases() async {
    if (!_isAvailable) throw Exception('App Store not available');
    await _iap.restorePurchases();
  }

  // ---------------------------------------------------------------------------
  // Purchase stream handler
  // ---------------------------------------------------------------------------

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final PurchaseDetails purchase in purchases) {
      debugPrint('🛒 [iOS IAP] ${purchase.productID} | ${purchase.status}');

      switch (purchase.status) {
        case PurchaseStatus.purchased:
          {
            if (!_userInitiatedPurchase) {
              // Automatic delivery on app start — acknowledge but don't
              // call backend again to avoid duplicate billing records.
              debugPrint('⚠️ [iOS IAP] Not user-initiated — skipping API call');
              if (purchase.pendingCompletePurchase) {
                await _iap.completePurchase(purchase);
              }
              break;
            }

            _userInitiatedPurchase = false;

            // The serverVerificationData for iOS is the Base64-encoded
            // App Store receipt (or a signed transaction JWS for StoreKit 2).
            final String receiptData =
                purchase.verificationData.serverVerificationData;

            if (receiptData.isEmpty || purchase.productID.isEmpty) {
              debugPrint('⚠️ [iOS IAP] Empty receipt — skipping verification');
              if (purchase.pendingCompletePurchase) {
                await _iap.completePurchase(purchase);
              }
              break;
            }

            await _verifyAndComplete(purchase, receiptData);
            break;
          }

        case PurchaseStatus.restored:
          {
            _userInitiatedPurchase = false;

            final String receiptData =
                purchase.verificationData.serverVerificationData;

            if (receiptData.isNotEmpty) {
              // Verify restored purchase with backend so entitlement is
              // refreshed even if the user reinstalls the app.
              await _verifyAndComplete(purchase, receiptData, isRestore: true);
            } else {
              if (purchase.pendingCompletePurchase) {
                await _iap.completePurchase(purchase);
              }
              debugPrint('🔄 [iOS IAP] Restored — no receipt data, skipping');
            }
            break;
          }

        case PurchaseStatus.error:
          _userInitiatedPurchase = false;
          debugPrint('❌ [iOS IAP] Error: ${purchase.error?.message}');
          onError?.call(purchase.error?.message ?? 'Purchase failed');
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          break;

        case PurchaseStatus.canceled:
          _userInitiatedPurchase = false;
          debugPrint('🚫 [iOS IAP] Canceled');
          onPurchaseUpdated?.call(false);
          break;

        case PurchaseStatus.pending:
          debugPrint('⏳ [iOS IAP] Pending...');
          break;
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Backend verification
  // ---------------------------------------------------------------------------

  Future<void> _verifyAndComplete(
    PurchaseDetails purchase,
    String receiptData, {
    bool isRestore = false,
  }) async {
    try {
      final String token = await SharePrefsHelper.getString(AppConstants.token);

      final String packageType =
          purchase.productID == yearlyProductId ? 'yearly' : 'monthly';

      final connect = GetConnect();
      final response = await connect.post(
        ApiUrl.iosSubscription,
        {
          'subscriptionId': purchase.productID,
          'receiptData': receiptData,
          'packageType': packageType,
          'transactionId': purchase.purchaseID ?? '',
          'transactionDate': purchase.transactionDate ?? '',
          'platform': 'ios',
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(
            '✅ [iOS IAP] ${isRestore ? "Restore" : "Purchase"} verified');

        await SharePrefsHelper.setBool(
            SharedPreferenceValue.isSubscribed, true);
        await SharePrefsHelper.setString(
            SharedPreferenceValue.activeProductId, purchase.productID);

        _isPurchased = true;
        _activeProductId = purchase.productID;
        onPurchaseUpdated?.call(true);
      } else {
        debugPrint(
            '❌ [iOS IAP] Verification failed: ${response.statusCode} ${response.body}');
        onError?.call(
            response.body?['message'] ?? 'Subscription verification failed');
      }
    } catch (error, stackTrace) {
      debugPrintStack(
        label: '[iOS IAP] Verification error: $error',
        stackTrace: stackTrace,
      );
      onError?.call('Subscription verification failed. Please try again.');
    } finally {
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Manage / Cancel subscription
  // ---------------------------------------------------------------------------

  /// Opens Apple's subscription management page.
  /// Required by App Store guidelines — you must not cancel subscriptions
  /// programmatically; users cancel through Apple's own interface.
  Future<void> cancelSubscription() async {
    const String appleManageUrl =
        'https://apps.apple.com/account/subscriptions';
    final Uri uri = Uri.parse(appleManageUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('[iOS IAP] Could not open Apple subscription settings');
    }
  }

  // ---------------------------------------------------------------------------
  // Dispose
  // ---------------------------------------------------------------------------

  void dispose() {
    _purchaseSubscription?.cancel();
  }
}
