// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tidybayte/app/data/service/api_url.dart';
// import 'package:tidybayte/app/data/subscription/subscription_service.dart';
// import 'package:tidybayte/app/global/helper/shared_prefe/shared_prefe.dart';
// import 'package:tidybayte/app/utils/app_const/app_const.dart';
// import '../../core/app_routes/app_routes.dart';
//
// class SubscriptionController extends GetxController {
//   late final SubscriptionService _service;
//
//   static const bool _useMock =
//   bool.fromEnvironment('USE_MOCK', defaultValue: false);
//
//   final RxBool isLoading = false.obs;
//   final RxBool isAvailable = false.obs;
//   final RxBool isPurchased = false.obs;
//   final RxString activeProductId = ''.obs;
//   final RxString errorMessage = ''.obs;
//
//   bool _initialized = false;
//   bool _userInitiatedPurchase = false;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     _service = SubscriptionService(
//       onPurchaseUpdated: (purchased) {
//         isPurchased.value = purchased;
//         if (purchased) {
//           activeProductId.value = _service.activeProductId ?? '';
//         }
//         isLoading.value = false;
//
//         if (!_userInitiatedPurchase) return;
//
//         _userInitiatedPurchase = false;
//
//         if (purchased) {
//           Get.offAllNamed(AppRoutes.homeScreen);
//         }
//       },
//       onError: (error) {
//         _userInitiatedPurchase = false;
//         errorMessage.value = error;
//         isLoading.value = false;
//         Get.snackbar('Purchase Failed', error);
//       },
//     );
//
//     _init();
//   }
//
//   Future<void> _init() async {
//     if (_initialized) return;
//     _initialized = true;
//
//     // ✅ Step 1: cache থেকে instant UI
//     final cachedSubscribed =
//         await SharePrefsHelper.getBool(SharedPreferenceValue.isSubscribed) ??
//             false;
//     if (cachedSubscribed) {
//       isPurchased.value = true;
//       activeProductId.value = await SharePrefsHelper.getString(
//           SharedPreferenceValue.activeProductId);
//     }
//
//     isLoading.value = true;
//     try {
//       if (_useMock) {
//         isAvailable.value = true;
//         isPurchased.value = false;
//       } else {
//         // ✅ Step 2: background এ store init
//         // isPurchased override করব না — restorePurchases এর
//         // result purchaseStream এ আসবে → onPurchaseUpdated এ handle হবে
//         await _service.initialize();
//         isAvailable.value = _service.isAvailable;
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> subscribe(bool isYearly) async {
//     if (isLoading.value) return;
//
//     final productId = isYearly
//         ? SubscriptionService.yearlyProductId
//         : SubscriptionService.monthlyProductId;
//
//     if (_useMock) {
//       isLoading.value = true;
//       await Future.delayed(const Duration(seconds: 1));
//       isPurchased.value = true;
//       isLoading.value = false;
//       Get.offAllNamed(AppRoutes.homeScreen);
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//       _userInitiatedPurchase = true;
//       await _service.buySubscription(productId);
//       isLoading.value = false;
//     } catch (e) {
//       _userInitiatedPurchase = false;
//       errorMessage.value = e.toString();
//       Get.snackbar('Error', e.toString());
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> cancelSubscription() async {
//     try {
//       await _service.cancelSubscription();
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     }
//   }
//
//   @override
//   void onClose() {
//     _service.dispose();
//     super.onClose();
//   }
// }








import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/data/subscription/subscription_service.dart';
import 'package:tidybayte/app/global/helper/shared_prefe/shared_prefe.dart';
import '../../core/app_routes/app_routes.dart';

class SubscriptionController extends GetxController {
  late final SubscriptionService _service;

  static const bool _useMock =
  bool.fromEnvironment('USE_MOCK', defaultValue: false);

  final RxBool isLoading = false.obs;
  final RxBool isAvailable = false.obs;
  final RxBool isPurchased = false.obs;
  final RxString activeProductId = ''.obs;
  final RxString errorMessage = ''.obs;

  bool _initialized = false;

  @override
  void onInit() {
    super.onInit();

    _service = SubscriptionService(
      onPurchaseUpdated: (purchased) {
        isPurchased.value = purchased;
        if (purchased) {
          activeProductId.value = _service.activeProductId ?? '';
          Get.offAllNamed(AppRoutes.homeScreen); // ✅ purchase হলে home এ যাও
        }
        isLoading.value = false;
      },
      onError: (error) {
        errorMessage.value = error;
        isLoading.value = false;
        Get.snackbar('Purchase Failed', error);
      },
    );

    _init();
  }

  Future<void> _init() async {
    if (_initialized) return;
    _initialized = true;

    // ✅ cache থেকে instant UI
    final cachedSubscribed =
        await SharePrefsHelper.getBool(SharedPreferenceValue.isSubscribed) ??
            false;
    if (cachedSubscribed) {
      isPurchased.value = true;
      activeProductId.value = await SharePrefsHelper.getString(
          SharedPreferenceValue.activeProductId);
    }

    isLoading.value = true;
    try {
      if (_useMock) {
        isAvailable.value = true;
        isPurchased.value = false;
      } else {
        await _service.initialize();
        isAvailable.value = _service.isAvailable;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> subscribe(bool isYearly) async {
    if (isLoading.value || isPurchased.value) return; // ✅ already purchased হলে skip

    final productId = isYearly
        ? SubscriptionService.yearlyProductId
        : SubscriptionService.monthlyProductId;

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
      await _service.buySubscription(productId);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', e.toString());
      isLoading.value = false;
    }
  }

  Future<void> cancelSubscription() async {
    try {
      await _service.cancelSubscription();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  void onClose() {
    _service.dispose();
    super.onClose();
  }
}