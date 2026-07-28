import 'dart:io';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tidybayte/app/data/subscription/ios_subscriptions.dart';
import 'package:tidybayte/app/data/subscription/subscription_service.dart';
import 'package:tidybayte/app/global/helper/shared_prefe/shared_prefe.dart';
import '../../core/app_routes/app_routes.dart';

/// Platform-aware subscription controller.
///
/// On iOS it delegates to [IosSubscriptionService] (App Store).
/// On Android it delegates to [SubscriptionService] (Google Play).
///
/// The product IDs differ between the two stores:
///   iOS   : premium_yearly / premium_monthly
///   Android: yearly_premium / monthly_premium
class SubscriptionController extends GetxController {
  // -------------------------------------------------------------------------
  // Services (one will be non-null after onInit)
  // -------------------------------------------------------------------------

  IosSubscriptionService? _iosService;
  SubscriptionService? _androidService;

  static const bool _useMock =
  bool.fromEnvironment('USE_MOCK', defaultValue: false);

  // -------------------------------------------------------------------------
  // Reactive state
  // -------------------------------------------------------------------------

  final RxBool isLoading = false.obs;
  final RxBool isAvailable = false.obs;
  final RxBool isPurchased = false.obs;
  final RxString activeProductId = ''.obs;
  final RxString errorMessage = ''.obs;

  // ✅ NEW — live formatted prices from the store
  final RxString yearlyPrice = ''.obs;
  final RxString monthlyPrice = ''.obs;

  bool _initialized = false;

  // -------------------------------------------------------------------------
  // Helpers — product IDs for the current platform
  // -------------------------------------------------------------------------

  String get _yearlyProductId => Platform.isIOS
      ? IosSubscriptionService.yearlyProductId
      : SubscriptionService.yearlyProductId;

  String get _monthlyProductId => Platform.isIOS
      ? IosSubscriptionService.monthlyProductId
      : SubscriptionService.monthlyProductId;

  // -------------------------------------------------------------------------
  // Lifecycle
  // -------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();

    if (Platform.isIOS) {
      _iosService = IosSubscriptionService(
        onPurchaseUpdated: _handlePurchaseUpdated,
        onError: _handleError,
        onProductsLoaded: _syncPrices, // ✅ NEW
      );
    } else {
      _androidService = SubscriptionService(
        onPurchaseUpdated: _handlePurchaseUpdated,
        onError: _handleError,
        onProductsLoaded: _syncPrices, // ✅ NEW
      );
    }

    _init();
  }

  @override
  void onClose() {
    _iosService?.dispose();
    _androidService?.dispose();
    super.onClose();
  }

  // -------------------------------------------------------------------------
  // Initialization
  // -------------------------------------------------------------------------

  Future<void> _init() async {
    if (_initialized) return;
    _initialized = true;

    // Instantly reflect any cached subscription state so the UI doesn't flash.
    final bool cachedSubscribed =
        await SharePrefsHelper.getBool(SharedPreferenceValue.isSubscribed) ??
            false;
    if (cachedSubscribed) {
      isPurchased.value = true;
      activeProductId.value = await SharePrefsHelper.getString(
          SharedPreferenceValue.activeProductId) ??
          '';
    }

    isLoading.value = true;
    try {
      if (_useMock) {
        isAvailable.value = true;
        isPurchased.value = false;
        return;
      }

      if (Platform.isIOS) {
        await _iosService!.initialize();
        isAvailable.value = _iosService!.isAvailable;
      } else {
        await _androidService!.initialize();
        isAvailable.value = _androidService!.isAvailable;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------------------------------------------------
  // Prices  ✅ NEW
  // -------------------------------------------------------------------------

  void _syncPrices() {
    if (Platform.isIOS) {
      yearlyPrice.value = _iosService?.yearlyPrice ?? '';
      monthlyPrice.value = _iosService?.monthlyPrice ?? '';
    } else {
      yearlyPrice.value = _androidService?.yearlyPrice ?? '';
      monthlyPrice.value = _androidService?.monthlyPrice ?? '';
    }
  }

  // -------------------------------------------------------------------------
  // Purchase
  // -------------------------------------------------------------------------

  Future<void> subscribe(bool isYearly) async {
    if (isLoading.value || isPurchased.value) return;

    final String productId = isYearly ? _yearlyProductId : _monthlyProductId;

    if (_useMock) {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 1));
      isPurchased.value = true;
      isLoading.value = false;
      Get.offAllNamed(AppRoutes.homeScreen);
      return;
    }

    try {
      isLoading.value = true;
      if (Platform.isIOS) {
        await _iosService!.buySubscription(productId);
      } else {
        await _androidService!.buySubscription(productId);
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', e.toString());
      isLoading.value = false;
    }
  }

  // -------------------------------------------------------------------------
  // Restore purchases (iOS requirement)
  // -------------------------------------------------------------------------

  /// Restores previously purchased subscriptions.
  ///
  /// On iOS: triggers the App Store restore flow. Results arrive via
  /// [_handlePurchaseUpdated] through the purchase stream.
  ///
  /// On Android: not needed (Google Play automatically restores).
  Future<void> restorePurchases() async {
    if (!Platform.isIOS) return;
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      await _iosService!.restorePurchases();
      // The result arrives asynchronously through the purchase stream.
      // isLoading will be cleared inside _handlePurchaseUpdated / _handleError.
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Restore Failed', e.toString());
      isLoading.value = false;
    }
  }

  // -------------------------------------------------------------------------
  // Cancel / Manage subscription
  // -------------------------------------------------------------------------

  /// Opens the appropriate subscription management screen for the current
  /// platform:
  ///   iOS    → Apple's subscription management page
  ///   Android → Google Play subscription management page
  Future<void> cancelSubscription() async {
    try {
      if (Platform.isIOS) {
        await _iosService!.cancelSubscription();
      } else {
        await _androidService!.cancelSubscription();
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // -------------------------------------------------------------------------
  // Callbacks from services
  // -------------------------------------------------------------------------

  void _handlePurchaseUpdated(bool purchased) {
    isPurchased.value = purchased;
    isLoading.value = false;

    if (purchased) {
      // Sync the active product ID from whichever service just completed.
      activeProductId.value = Platform.isIOS
          ? (_iosService!.activeProductId ?? '')
          : (_androidService!.activeProductId ?? '');

      Get.offAllNamed(AppRoutes.homeScreen);
    }
  }

  void _handleError(String error) {
    errorMessage.value = error;
    isLoading.value = false;
    Get.snackbar('Purchase Failed', error);
  }
}