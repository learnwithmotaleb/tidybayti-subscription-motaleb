import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:get/get_connect/connect.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/shared_prefe/shared_prefe.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:url_launcher/url_launcher.dart';

/// iOS-specific in-app purchase service (App Store).
/// Standalone — does NOT extend SubscriptionService, so it has its own
/// receipt-based verification and Apple-specific cancel URL.
class IosSubscriptionService {
  static const String yearlyProductId = 'premium_yearly';
  static const String monthlyProductId = 'premium_monthly';

  static const Set<String> productIds = {yearlyProductId, monthlyProductId};

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  bool _isAvailable = false;
  bool _isPurchased = false;
  String? _activeProductId;
  bool _userInitiatedPurchase = false;

  // ✅ NEW — live product/price data from App Store
  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  bool get isAvailable => _isAvailable;
  bool get isPurchased => _isPurchased;
  String? get activeProductId => _activeProductId;

  // ✅ NEW — formatted, localized price strings
  String? get yearlyPrice => _priceFor(yearlyProductId);
  String? get monthlyPrice => _priceFor(monthlyProductId);

  String? _priceFor(String id) {
    try {
      return _products.firstWhere((p) => p.id == id).price;
    } catch (_) {
      return null;
    }
  }

  final void Function(bool isPurchased)? onPurchaseUpdated;
  final void Function(String error)? onError;
  final void Function()? onProductsLoaded; // ✅ NEW

  IosSubscriptionService({
    this.onPurchaseUpdated,
    this.onError,
    this.onProductsLoaded,
  });

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

    await _fetchProducts(); // ✅ NEW

    debugPrint('✅ [iOS IAP] IosSubscriptionService initialized');
  }

  // ✅ NEW
  Future<void> _fetchProducts() async {
    final ProductDetailsResponse response =
    await _iap.queryProductDetails(productIds);

    debugPrint('🔍 [IAP DEBUG] Queried IDs: $productIds');
    debugPrint('🔍 [IAP DEBUG] Found: ${response.productDetails.map((p) => "${p.id}=${p.price}").toList()}');
    debugPrint('🔍 [IAP DEBUG] Not found: ${response.notFoundIDs}');
    debugPrint('🔍 [IAP DEBUG] Error: ${response.error?.message}');

    if (response.error != null) {
      debugPrint('❌ [iOS IAP] Product query error: ${response.error!.message}');
      onError?.call(response.error!.message);
      return;
    }

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('⚠️ [iOS IAP] Products not found: ${response.notFoundIDs}');
    }

    _products = response.productDetails;
    onProductsLoaded?.call();
  }

  Future<void> buySubscription(String productId) async {
    if (!_isAvailable) throw Exception('App Store not available');

    _userInitiatedPurchase = true;

    // ✅ Reuse already-fetched product if available, else query fresh
    ProductDetails? product;
    try {
      product = _products.firstWhere((p) => p.id == productId);
    } catch (_) {
      product = null;
    }

    if (product == null) {
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

      product = response.productDetails.first;
    }

    final PurchaseParam param = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> restorePurchases() async {
    if (!_isAvailable) throw Exception('App Store not available');
    await _iap.restorePurchases();
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final PurchaseDetails purchase in purchases) {
      debugPrint('🛒 [iOS IAP] ${purchase.productID} | ${purchase.status}');

      switch (purchase.status) {
        case PurchaseStatus.purchased:
          {
            if (!_userInitiatedPurchase) {
              debugPrint('⚠️ [iOS IAP] Not user-initiated — skipping API call');
              if (purchase.pendingCompletePurchase) {
                await _iap.completePurchase(purchase);
              }
              break;
            }

            _userInitiatedPurchase = false;

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
        debugPrint('✅ [iOS IAP] ${isRestore ? "Restore" : "Purchase"} verified');

        await SharePrefsHelper.setBool(SharedPreferenceValue.isSubscribed, true);
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

  Future<void> cancelSubscription() async {
    const String appleManageUrl = 'https://apps.apple.com/account/subscriptions';
    final Uri uri = Uri.parse(appleManageUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('[iOS IAP] Could not open Apple subscription settings');
    }
  }

  void dispose() {
    _purchaseSubscription?.cancel();
  }
}