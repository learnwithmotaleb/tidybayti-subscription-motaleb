import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/connect.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/shared_prefe/shared_prefe.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionService {
  static const String yearlyProductId = 'yearly_premium';
  static const String monthlyProductId = 'monthly_premium';
  static const Set<String> productIds = {yearlyProductId, monthlyProductId};

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _isAvailable = false;
  bool _isPurchased = false;
  String? _activeProductId;
  bool _userInitiatedPurchase = false;

  // ✅ NEW — live product/price data from Play Store
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

  SubscriptionService({
    this.onPurchaseUpdated,
    this.onError,
    this.onProductsLoaded,
  });

  Future<void> initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (!_isAvailable) {
      debugPrint('❌ Store not available');
      return;
    }

    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (e) {
        debugPrint('❌ Purchase stream error: $e');
        onError?.call(e.toString());
      },
    );

    await _fetchProducts(); // ✅ NEW

    // If a previous purchase was granted locally but never made it to the
    // server (network drop, backend down, timeout), retry it silently now.
    unawaited(_retryPendingSyncIfAny());

    debugPrint('✅ SubscriptionService initialized');
  }

  // ✅ NEW
  Future<void> _fetchProducts() async {
    final ProductDetailsResponse response =
        await _iap.queryProductDetails(productIds);

    debugPrint('🔍 [IAP DEBUG] Queried IDs: $productIds');
    debugPrint(
        '🔍 [IAP DEBUG] Found: ${response.productDetails.map((p) => "${p.id}=${p.price}").toList()}');
    debugPrint('🔍 [IAP DEBUG] Not found: ${response.notFoundIDs}');
    debugPrint('🔍 [IAP DEBUG] Error: ${response.error?.message}');

    if (response.error != null) {
      debugPrint('❌ Product query error: ${response.error!.message}');
      onError?.call(response.error!.message);
      return;
    }

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('⚠️ Products not found: ${response.notFoundIDs}');
    }

    _products = response.productDetails;
    onProductsLoaded?.call();
  }

  Future<void> buySubscription(String productId) async {
    if (!_isAvailable) throw Exception('Store not available');

    _userInitiatedPurchase = true; // ✅ user click করেছে

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
        throw Exception('Product query error: ${response.error!.message}');
      }

      if (response.productDetails.isEmpty) {
        _userInitiatedPurchase = false;
        throw Exception('Product not found: $productId');
      }

      product = response.productDetails.first;
    }

    final PurchaseParam param = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      debugPrint('🛒 ${purchase.productID} | ${purchase.status}');

      switch (purchase.status) {
        case PurchaseStatus.purchased:
          {
            // ✅ শুধু user নিজে button click করলেই API call
            if (!_userInitiatedPurchase) {
              debugPrint('⚠️ Not user initiated — skipping API call');
              await _iap.completePurchase(purchase);
              break;
            }

            _userInitiatedPurchase = false; // ✅ reset

            final String reqPurchaseToken =
                purchase.verificationData.serverVerificationData;

            // ✅ Google Play has already charged the user at this point —
            // unlock the app immediately instead of waiting on our backend,
            // so a slow/unreachable/failing server call can never leave a
            // paid purchase stuck on the paywall.
            await _grantLocalEntitlement(purchase);
            await _iap.completePurchase(purchase);

            if (reqPurchaseToken.isEmpty || purchase.productID.isEmpty) {
              debugPrint('⚠️ Empty token — skipping server sync');
            } else {
              unawaited(_verifyWithBackend(
                productId: purchase.productID,
                purchaseToken: reqPurchaseToken,
              ));
            }
            break;
          }

        case PurchaseStatus.restored:
          _userInitiatedPurchase = false;
          debugPrint('🔄 Restored');
          await _grantLocalEntitlement(purchase);
          await _iap.completePurchase(purchase);
          break;

        case PurchaseStatus.error:
          _userInitiatedPurchase = false;
          debugPrint('❌ Error: ${purchase.error?.message}');
          onError?.call(purchase.error?.message ?? 'Unknown error');
          break;

        case PurchaseStatus.canceled:
          _userInitiatedPurchase = false;
          debugPrint('🚫 Canceled');
          onPurchaseUpdated?.call(false);
          break;

        case PurchaseStatus.pending:
          debugPrint('⏳ Pending...');
          break;
      }
    }
  }

  /// Grants premium access on-device right away. Called as soon as Play
  /// Billing reports `purchased`/`restored` — the user has already paid
  /// Google, so the app must never wait on our own server before unlocking.
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
  /// and if still unresolved, persists the token so [_retryPendingSyncIfAny]
  /// can try again on the next app launch — the local entitlement already
  /// granted in [_grantLocalEntitlement] is never revoked because of this.
  Future<void> _verifyWithBackend({
    required String productId,
    required String purchaseToken,
    int attempt = 1,
  }) async {
    const int maxAttempts = 3;

    try {
      final token = await SharePrefsHelper.getString(AppConstants.token);
      final String packageType =
          productId.contains('yearly') ? 'yearly' : 'monthly';

      final connect = GetConnect();
      final response = await connect
          .post(
            ApiUrl.subscription,
            {
              "subscriptionId": productId,
              "purchaseToken": purchaseToken,
              "packageType": packageType,
            },
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Subscription verified with server');
        await _clearPendingSync();
        return;
      }

      debugPrint('❌ Verification failed: ${response.statusCode}');
    } catch (error, stackTrace) {
      debugPrintStack(
        label: 'Verification error (attempt $attempt): $error',
        stackTrace: stackTrace,
      );
    }

    if (attempt < maxAttempts) {
      await Future.delayed(Duration(seconds: attempt * 3));
      return _verifyWithBackend(
        productId: productId,
        purchaseToken: purchaseToken,
        attempt: attempt + 1,
      );
    }

    await _savePendingSync(productId: productId, purchaseToken: purchaseToken);
  }

  Future<void> _savePendingSync({
    required String productId,
    required String purchaseToken,
  }) async {
    final String data = jsonEncode({
      'subscriptionId': productId,
      'purchaseToken': purchaseToken,
    });
    await SharePrefsHelper.setString(
        SharedPreferenceValue.pendingAndroidReceiptSync, data);
  }

  Future<void> _clearPendingSync() async {
    await SharePrefsHelper.remove(SharedPreferenceValue.pendingAndroidReceiptSync);
  }

  /// Best-effort retry of a purchase that got locally granted but never made
  /// it to the server (app killed mid-sync, backend was unreachable, etc).
  Future<void> _retryPendingSyncIfAny() async {
    final String raw = await SharePrefsHelper.getString(
        SharedPreferenceValue.pendingAndroidReceiptSync);
    if (raw.isEmpty) return;

    try {
      final Map<String, dynamic> data =
          jsonDecode(raw) as Map<String, dynamic>;
      await _verifyWithBackend(
        productId: data['subscriptionId'] as String? ?? '',
        purchaseToken: data['purchaseToken'] as String? ?? '',
      );
    } catch (e) {
      debugPrint('⚠️ Failed to parse pending sync data: $e');
      await _clearPendingSync();
    }
  }

  Future<void> cancelSubscription() async {
    const url = 'https://play.google.com/store/account/subscriptions';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not open Play Store');
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
