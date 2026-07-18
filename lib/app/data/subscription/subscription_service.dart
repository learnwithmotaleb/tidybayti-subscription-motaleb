import 'dart:async';
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

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _isAvailable = false;
  bool _isPurchased = false;
  String? _activeProductId;
  bool _userInitiatedPurchase = false; // ✅ NEW

  bool get isAvailable => _isAvailable;
  bool get isPurchased => _isPurchased;
  String? get activeProductId => _activeProductId;

  final void Function(bool isPurchased)? onPurchaseUpdated;
  final void Function(String error)? onError;

  SubscriptionService({this.onPurchaseUpdated, this.onError});

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

    debugPrint('✅ SubscriptionService initialized');
  }

  Future<void> buySubscription(String productId) async {
    if (!_isAvailable) throw Exception('Store not available');

    _userInitiatedPurchase = true; // ✅ user click করেছে

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

    final ProductDetails product = response.productDetails.first;
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

            if (reqPurchaseToken.isEmpty || purchase.productID.isEmpty) {
              debugPrint('⚠️ Empty token — skipping');
              await _iap.completePurchase(purchase);
              break;
            }

            final token = await SharePrefsHelper.getString(AppConstants.token);
            final String packageType =
                purchase.productID.contains('yearly') ? 'yearly' : 'monthly';

            final connect = GetConnect();
            final response = await connect.post(
              ApiUrl.subscription,
              {
                "subscriptionId": purchase.productID,
                "purchaseToken": reqPurchaseToken,
                "packageType": packageType,
              },
              headers: {
                "Authorization": "Bearer $token",
                "Content-Type": "application/json",
                "Accept": "application/json",
              },
            );

            if (response.statusCode == 200 || response.statusCode == 201) {
              debugPrint('✅ Subscription verified');
              await SharePrefsHelper.setBool(
                  SharedPreferenceValue.isSubscribed, true);
              await SharePrefsHelper.setString(
                  SharedPreferenceValue.activeProductId, purchase.productID);
              _isPurchased = true;
              _activeProductId = purchase.productID;
              onPurchaseUpdated?.call(true);
              await _iap.completePurchase(purchase);
            } else {
              debugPrint('❌ Failed: ${response.statusCode}');
              onError?.call(response.body['message'] ?? "Verification failed");
            }
            break;
          }

        case PurchaseStatus.restored:
          _userInitiatedPurchase = false;
          debugPrint('🔄 Restored — skipping API');
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
