import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/core/dependency/path.dart';
import 'package:tidybayte/app/data/service/api_check.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/local_db/local_db.dart';
import 'package:tidybayte/app/global/helper/shared_prefe/shared_prefe.dart';
import 'package:tidybayte/app/utils/ToastMsg/toast_message.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';

import '../../data/subscription/subscription_controller.dart';

class AuthController extends GetxController {
  ApiClient apiClient = serviceLocator();
  DBHelper dbHelper = serviceLocator();

  ///==================================✅✅Remember✅✅=======================

  RxBool isRemember = false.obs;

  toggleRemember() {
    isRemember.value = !isRemember.value;
    debugPrint("Remember me==============>>>>>>>>>$isRemember");
    refresh();
    SharePrefsHelper.setBool(AppConstants.isRememberMe, isRemember.value);
  }

  ///==================================✅✅Controller✅✅=======================

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController(text: kDebugMode ? "" : "");
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController(text: kDebugMode ? "" : "");
  final confirmPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final otpController = TextEditingController();

  ///==================================✅✅SignUp Method✅✅=======================

  RxBool signUpLoading = false.obs;

  signup() async {
    signUpLoading.value = true;
    var body = {
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "email": emailController.text,
      "phoneNumber": phoneNumberController.text,
      "password": passwordController.text,
      "confirmPassword": confirmPasswordController.text,
      "role": "USER"
    };

    var response = await apiClient.post(body: body, url: ApiUrl.register);
    if (response.statusCode == 200) {
      Get.toNamed(AppRoutes.signUpOtp);
      toastMessage(message: response.body["message"]);
    } else if (response.statusCode == 400) {
      String errorMessage = response.body["message"];

      if (errorMessage.contains("Account active. Please Login")) {
        toastMessage(message: errorMessage);
        Get.toNamed(AppRoutes.signInScreen);
      } else if (errorMessage
          .contains("Already have an account. Please activate")) {
        toastMessage(message: errorMessage);
        Get.toNamed(
          AppRoutes.signUpOtp,
        );
      } else {
        toastMessage(message: errorMessage);
      }
    } else {
      ApiChecker.checkApi(response);
    }
    signUpLoading.value = false;
    signUpLoading.refresh();
  }

  ///==================================✅✅SignUp OTp✅✅=======================

  RxBool isSignUpOtp = false.obs;
  signUpOtp() async {
    isSignUpOtp.value = true;
    var body = {
      "email": emailController.text,
      "activationCode": otpController.text
    };
    var response =
        await apiClient.post(body: body, url: ApiUrl.activateAccount);
    if (response.statusCode == 201) {
      SharePrefsHelper.setString(
          AppConstants.token, response.body['data']["accessToken"]);

      debugPrint(
          '🔑 Token saved after activation: ${response.body['data']["accessToken"]}');

      //  Get.offAllNamed(AppRoutes.freeServiceScreen);
      Get.offAllNamed(AppRoutes.freeServiceNewScreen);

      toastMessage(message: response.body["message"]);
    } else if (response.statusCode == 400) {
      toastMessage(message: response.body["message"]);
    } else {
      ApiChecker.checkApi(response);
    }
    isSignUpOtp.value = false;
    isSignUpOtp.refresh();
  }

  ///==================================✅✅Sign In Method✅✅=======================

  RxBool isSignInLoading = false.obs;
  String selectedRole = "USER"; // Store the selected role

  signIn() async {
    isSignInLoading.value = true;
    var body = {
      "email": emailController.text,
      "password": passwordController.text,
      "role": selectedRole // Send the role user selected (USER or EMPLOYEE)
    };

    var response = await apiClient.post(body: body, url: ApiUrl.login);
    if (response.statusCode == 200) {
      emailController.clear();
      passwordController.clear();
      Map<String, dynamic> decodedToken =
          JwtDecoder.decode(response.body["data"]['accessToken']);
      print("Decoded Token:========================== $decodedToken");
      String role = decodedToken['role'];

      print('Role:============================ $role');
      await SharePrefsHelper.setString(
          AppConstants.token, response.body['data']["accessToken"]);

      // if (isRemember.value) {
      //   SharePrefsHelper.setBool(AppConstants.rememberMe, true);
      //   if (role == 'USER') {
      //     SharePrefsHelper.setBool(AppConstants.isOwner, true);
      //   } else if (role == 'EMPLOYEE') {
      //     SharePrefsHelper.setBool(AppConstants.isOwner, false);
      //   }
      // } else {
      //   SharePrefsHelper.setBool(AppConstants.rememberMe, false);
      //   SharePrefsHelper.setBool(AppConstants.isOwner, false);
      // }

// সবসময় role save করো
      if (role == 'USER') {
        await SharePrefsHelper.setBool(AppConstants.isOwner, true);

        // ✅ Login response থেকে subscription check
        final isSubscribed = response.body['data']['isSubscribed'] ?? false;
        final activeProductId = response.body['data']['productId'] ?? '';

        debugPrint('📦 isSubscribed from API: $isSubscribed');
        debugPrint('📦 activeProductId from API: $activeProductId');

        await SharePrefsHelper.setBool(
            SharedPreferenceValue.isSubscribed, isSubscribed);
        await SharePrefsHelper.setString(
            SharedPreferenceValue.activeProductId, activeProductId);

        debugPrint(
            '✅ Subscription cache saved — isSubscribed: $isSubscribed | activeProductId: $activeProductId');
      } else if (role == 'EMPLOYEE') {
        await SharePrefsHelper.setBool(AppConstants.isOwner, false);
      }

// Remember Me আলাদাভাবে handle করো
      if (isRemember.value) {
        SharePrefsHelper.setBool(AppConstants.rememberMe, true);
      } else {
        SharePrefsHelper.setBool(AppConstants.rememberMe, false);
      }

// Remember Me আলাদাভাবে handle করো
      if (isRemember.value) {
        SharePrefsHelper.setBool(AppConstants.rememberMe, true);
      } else {
        SharePrefsHelper.setBool(AppConstants.rememberMe, false);
      }

      if (role == 'USER') {
        Get.offAllNamed(AppRoutes.homeScreen);
      } else if (role == 'EMPLOYEE') {
        Get.offAllNamed(AppRoutes.employeeHomeScreen);
      } else {
        return null;
      }
      toastMessage(message: response.body["message"]);
    }
    // ADD THIS: Handle 400 status code for unactivated accounts
    else if (response.statusCode == 400) {
      if (response.body["data"] != null &&
          response.body["data"]["message"] != null) {
        String errorMessage = response.body["data"]["message"];

        // Check if account needs activation
        if (errorMessage.contains("activate") || errorMessage.contains("otp")) {
          toastMessage(message: errorMessage);

          // Navigate to OTP verification screen
          // Don't clear email - user needs it for OTP verification
          Get.toNamed(AppRoutes.signUpOtp);
        } else {
          // Other 400 errors
          toastMessage(message: errorMessage);
        }
      } else {
        toastMessage(message: response.body["message"] ?? "Bad request");
      }
    }
    // else if (response.statusCode == 403 &&  response.statusText=="Forbidden")
    // {
    //
    //
    //   // ✅ আগে token save করুন
    //   await SharePrefsHelper.setString(
    //       AppConstants.token, response.body['data']["token"]
    //   );
    //
    //   // ✅ Confirm হলে তারপর navigate করুন
    //   final token = await SharePrefsHelper.getString(AppConstants.token);
    //   debugPrint('🔑 Token saved: $token');
    //
    //   // Check if this is a subscription/trial expiration error
    //   if (response.body["data"] != null &&
    //       response.body["data"]["message"] != null &&
    //       (response.body["data"]["message"].toString().contains("trial") ||
    //           response.body["data"]["message"].toString().contains("Subscription")))
    //   {
    //
    //     // Show the error message
    //     toastMessage(message: response.body["data"]["message"]);
    //     Get.toNamed(AppRoutes.subscriptionOnboardingScreen,
    //         arguments: {
    //           'isOnboarding': false,
    //           'isFreeEnd': false,
    //         }
    //     );
    //
    //
    //   //  Get.offAllNamed(AppRoutes.employeeHomeScreen);
    //   }
    //
    //   else {
    //     // Other 403 errors (like invalid credentials, wrong role)
    //     toastMessage(message: response.body["message"] ?? "Access denied");
    //   }
    // }

    else if (response.statusCode == 403 && response.statusText == "Forbidden") {
      // ✅ আগে token save করুন
      await SharePrefsHelper.setString(
          AppConstants.token, response.body['data']["token"]);

      // ✅ Confirm হলে তারপর navigate করুন
      final token = await SharePrefsHelper.getString(AppConstants.token);
      debugPrint('🔑 Token saved: $token');

      // ✅ NEW: cache ও controller clear করো
      await SharePrefsHelper.setBool(SharedPreferenceValue.isSubscribed, false);
      await SharePrefsHelper.setString(
          SharedPreferenceValue.activeProductId, '');
      final subController = Get.find<SubscriptionController>();
      subController.isPurchased.value = false;
      subController.activeProductId.value = '';

      // Check if this is a subscription/trial expiration error
      if (response.body["data"] != null &&
          response.body["data"]["message"] != null &&
          (response.body["data"]["message"].toString().contains("trial") ||
              response.body["data"]["message"]
                  .toString()
                  .contains("Subscription"))) {
        toastMessage(message: response.body["data"]["message"]);

        Get.toNamed(AppRoutes.subscriptionOnboardingScreen, arguments: {
          'isOnboarding': false,
          'isFreeEnd': false,
        });
      } else {
        toastMessage(message: response.body["message"] ?? "Access denied");
      }
    } else {
      SharePrefsHelper.setBool(AppConstants.rememberMe, false);
      SharePrefsHelper.setBool(AppConstants.isOwner, false);
      ApiChecker.checkApi(response);
    }
    isSignInLoading.value = false;
    isSignInLoading.refresh();
  }

// Method to set the role before login
  void setUserRole(String role) {
    // Convert "Owner" to "USER" and "Employee" to "EMPLOYEE"
    if (role == "Owner") {
      selectedRole = "USER";
    } else if (role == "Employee") {
      selectedRole = "EMPLOYEE";
    }
  }

  ///==================================✅✅Forget Method✅✅=======================

  RxBool isForgetLoading = false.obs;

  forgetEmail() async {
    isForgetLoading.value = true;
    var body = {"email": emailController.text};

    var response = await apiClient.post(body: body, url: ApiUrl.forgotPassword);
    if (response.statusCode == 200) {
      toastMessage(message: response.body["message"]);
      Get.toNamed(AppRoutes.forgotPasswordOtp);
    } else if (response.statusCode == 400) {
      toastMessage(message: response.body["message"]);
    } else {
      ApiChecker.checkApi(response);
    }
    isForgetLoading.value = false;
    isForgetLoading.refresh();
  }

  ///==================================✅✅Resend Otp✅✅=======================

  RxBool isResendOtp = false.obs;

  resendOtp() async {
    isResendOtp.value = true;
    var body = {"email": emailController.text};

    var response = await apiClient.post(body: body, url: ApiUrl.resendOtp);
    if (response.statusCode == 200) {
      toastMessage(message: response.body["message"]);
    } else if (response.statusCode == 400) {
      toastMessage(message: response.body["message"]);
    } else {
      ApiChecker.checkApi(response);
    }
    isResendOtp.value = false;
    isResendOtp.refresh();
  }

  ///==================================✅✅Forget Otp Method✅✅=======================

  RxBool isForgetOtp = false.obs;
  Future<void> forgetOtpVerify() async {
    isForgetOtp.value = true;
    var body = {"email": emailController.text, "code": otpController.text};
    var response =
        await apiClient.post(body: body, url: ApiUrl.forgetPasswordOtpVerify);
    if (response.statusCode == 200) {
      toastMessage(message: response.body["message"]);
      Get.toNamed(AppRoutes.resetPasswordScreen);
    } else if (response.statusCode == 400) {
      toastMessage(message: response.body["message"]);
    } else {
      ApiChecker.checkApi(response);
    }
    isForgetOtp.value = false;
    isForgetOtp.refresh();
  }

  ///==================================✅✅Reset password Method✅✅=======================

  RxBool isResetLoading = false.obs;

  Future<void> resetPassword() async {
    isResetLoading.value = true;
    var body = {
      "email": emailController.text,
      "confirmPassword": confirmPasswordController.text,
      "newPassword": newPasswordController.text
    };

    var response = await apiClient.post(body: body, url: ApiUrl.resetPassword);
    if (response.statusCode == 200) {
      clearResetField();
      toastMessage(message: response.body["message"]);
      Get.toNamed(AppRoutes.signInScreen);
    } else if (response.statusCode == 400) {
      toastMessage(message: response.body["message"]);
    } else {
      ApiChecker.checkApi(response);
    }
    isResetLoading.value = false;
    isResetLoading.refresh();
  }

  clearResetField() {
    emailController.clear();
    otpController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }
}
