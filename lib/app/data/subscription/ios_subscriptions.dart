import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:get/get_connect/connect.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
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

    // If a previous purchase was granted locally but never made it to the
    // server (network drop, backend down, timeout), retry it silently now.
    unawaited(_retryPendingSyncIfAny());

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

            // ✅ Apple has already charged the user at this point — unlock
            // the app immediately instead of waiting on our backend. This is
            // what App Review flagged: a slow/unreachable/failing server
            // call must never leave a paid purchase stuck on the paywall.
            await _grantLocalEntitlement(purchase);

            if (purchase.pendingCompletePurchase) {
              await _iap.completePurchase(purchase);
            }

            if (receiptData.isEmpty || purchase.productID.isEmpty) {
              debugPrint('⚠️ [iOS IAP] Empty receipt — skipping server sync');
            } else {
              // Record/verify with our backend in the background. Failures
              // are retried with backoff and, if still unresolved, retried
              // again on the next app launch — they no longer block the user.
              unawaited(_verifyWithBackend(
                productId: purchase.productID,
                receiptData: receiptData,
                transactionId: purchase.purchaseID ?? '',
                originalTransactionId: _originalTransactionId(purchase),
                transactionDate: purchase.transactionDate ?? '',
              ));
            }
            break;
          }

        case PurchaseStatus.restored:
          {
            _userInitiatedPurchase = false;

            final String receiptData =
                purchase.verificationData.serverVerificationData;

            await _grantLocalEntitlement(purchase);

            if (purchase.pendingCompletePurchase) {
              await _iap.completePurchase(purchase);
            }

            if (receiptData.isNotEmpty) {
              unawaited(_verifyWithBackend(
                productId: purchase.productID,
                receiptData: receiptData,
                transactionId: purchase.purchaseID ?? '',
                originalTransactionId: _originalTransactionId(purchase),
                transactionDate: purchase.transactionDate ?? '',
                isRestore: true,
              ));
            } else {
              debugPrint('🔄 [iOS IAP] Restored — no receipt data, skipping sync');
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

  /// Apple's "original transaction id" identifies the subscription across
  /// renewals/restores — for a brand-new purchase it's the same as the
  /// transaction id itself; StoreKit only sets [originalTransaction] once a
  /// transaction is a renewal or a restore.
  String _originalTransactionId(PurchaseDetails purchase) {
    if (purchase is AppStorePurchaseDetails) {
      return purchase.skPaymentTransaction.originalTransaction
              ?.transactionIdentifier ??
          purchase.skPaymentTransaction.transactionIdentifier ??
          purchase.purchaseID ??
          '';
    }
    return purchase.purchaseID ?? '';
  }

  /// Grants premium access on-device right away. Called as soon as StoreKit
  /// reports `purchased`/`restored` — the user has already paid Apple, so
  /// the app must never wait on our own server before unlocking.
  Future<void> _grantLocalEntitlement(PurchaseDetails purchase) async {
    await SharePrefsHelper.setBool(SharedPreferenceValue.isSubscribed, true);
    await SharePrefsHelper.setString(
        SharedPreferenceValue.activeProductId, purchase.productID);

    _isPurchased = true;
    _activeProductId = purchase.productID;
    onPurchaseUpdated?.call(true);
  }

  /// Records/verifies the purchase with our backend. This runs in the
  /// background (never gates the UI). On failure it retries with backoff,
  /// and if still unresolved, persists the receipt so [_retryPendingSyncIfAny]
  /// can try again on the next app launch — the local entitlement already
  /// granted in [_grantLocalEntitlement] is never revoked because of this.
  Future<void> _verifyWithBackend({
    required String productId,
    required String receiptData,
    required String transactionId,
    required String originalTransactionId,
    required String transactionDate,
    bool isRestore = false,
    int attempt = 1,
  }) async {
    const int maxAttempts = 3;

    try {
      final String token = await SharePrefsHelper.getString(AppConstants.token);
      final String packageType =
          productId == yearlyProductId ? 'yearly' : 'monthly';

      final connect = GetConnect();
      final response = await connect
          .post(
            ApiUrl.iosSubscription,
            {
              'productId': productId,
              'receiptData': receiptData,
              'packageType': packageType,
              'transactionId': transactionId,
              'originalTransactionId': originalTransactionId,
              'transactionDate': transactionDate,
              'platform': 'ios',
            },
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ [iOS IAP] ${isRestore ? "Restore" : "Purchase"} verified with server');
        await _clearPendingSync();
        return;
      }

      debugPrint(
          '❌ [iOS IAP] Verification failed: ${response.statusCode} ${response.body}');
    } catch (error, stackTrace) {
      debugPrintStack(
        label: '[iOS IAP] Verification error (attempt $attempt): $error',
        stackTrace: stackTrace,
      );
    }

    if (attempt < maxAttempts) {
      await Future.delayed(Duration(seconds: attempt * 3));
      return _verifyWithBackend(
        productId: productId,
        receiptData: receiptData,
        transactionId: transactionId,
        originalTransactionId: originalTransactionId,
        transactionDate: transactionDate,
        isRestore: isRestore,
        attempt: attempt + 1,
      );
    }

    await _savePendingSync(
      productId: productId,
      receiptData: receiptData,
      transactionId: transactionId,
      originalTransactionId: originalTransactionId,
      transactionDate: transactionDate,
      isRestore: isRestore,
    );
  }

  Future<void> _savePendingSync({
    required String productId,
    required String receiptData,
    required String transactionId,
    required String originalTransactionId,
    required String transactionDate,
    required bool isRestore,
  }) async {
    final String data = jsonEncode({
      'productId': productId,
      'receiptData': receiptData,
      'transactionId': transactionId,
      'originalTransactionId': originalTransactionId,
      'transactionDate': transactionDate,
      'isRestore': isRestore,
    });
    await SharePrefsHelper.setString(
        SharedPreferenceValue.pendingIosReceiptSync, data);
  }

  Future<void> _clearPendingSync() async {
    await SharePrefsHelper.remove(SharedPreferenceValue.pendingIosReceiptSync);
  }

  /// Best-effort retry of a purchase that got locally granted but never made
  /// it to the server (app killed mid-sync, backend was unreachable, etc).
  Future<void> _retryPendingSyncIfAny() async {
    final String raw =
        await SharePrefsHelper.getString(SharedPreferenceValue.pendingIosReceiptSync);
    if (raw.isEmpty) return;

    try {
      final Map<String, dynamic> data =
          jsonDecode(raw) as Map<String, dynamic>;
      await _verifyWithBackend(
        productId: data['productId'] as String? ?? '',
        receiptData: data['receiptData'] as String? ?? '',
        transactionId: data['transactionId'] as String? ?? '',
        originalTransactionId: data['originalTransactionId'] as String? ?? '',
        transactionDate: data['transactionDate'] as String? ?? '',
        isRestore: data['isRestore'] as bool? ?? false,
      );
    } catch (e) {
      debugPrint('⚠️ [iOS IAP] Failed to parse pending sync data: $e');
      await _clearPendingSync();
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