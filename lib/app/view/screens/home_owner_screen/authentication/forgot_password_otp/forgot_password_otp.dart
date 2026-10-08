import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/global/controller/auth_controller.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_images/app_images.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/components/custom_text_field/custom_text_field.dart';

class ForgotPasswordOtp extends StatefulWidget {
  const ForgotPasswordOtp({super.key});

  @override
  State<ForgotPasswordOtp> createState() => _ForgotPasswordOtpState();
}

class _ForgotPasswordOtpState extends State<ForgotPasswordOtp> {
  final AuthController authController = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();

  final RxInt _secondsRemaining = 60.obs;
  Timer? _timer;

  void startTimer() {
    _timer?.cancel();
    _secondsRemaining.value = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining.value > 0) {
        _secondsRemaining.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resendOtp() {
    if (_secondsRemaining.value == 0) {
      startTimer();
      authController.resendForgetOtp().then((value) {
        if (!value) {
          _secondsRemaining.value = 0;
          _timer?.cancel();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              /// Background Image
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  AppImages.signInBackground,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.padding(20),
                    vertical: ResponsiveHelper.spacing(40),
                  ),
                  child: Obx(() {
                    return Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const CustomMenuAppbar(title: ''),

                          SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                          ),

                          /// ========== OTP Field ==========
                          CustomTextField(
                            hintText: AppStrings.enterSIxDegit.tr,
                            textEditingController: authController.otpController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return AppStrings.fieldCantBeEmpty.tr;
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: ResponsiveHelper.spacing(16)),

                          /// ========== Resend OTP ==========
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: _secondsRemaining.value == 0
                                  ? _resendOtp
                                  : null,
                              child: CustomText(
                                text: _secondsRemaining.value == 0
                                    ? "Resend OTP"
                                    : "Resend OTP in ${_secondsRemaining.value}s",
                                color: _secondsRemaining.value == 0
                                    ? AppColors.dark400
                                    : AppColors.dark300,
                                fontWeight: FontWeight.w600,
                                fontSize: ResponsiveHelper.fontSize(14),
                              ),
                            ),
                          ),

                          SizedBox(height: ResponsiveHelper.spacing(32)),

                          /// ========== Verify Button ==========
                          authController.isForgetOtp.value
                              ? const CustomLoader()
                              : CustomButton(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                authController.forgetOtpVerify();
                              }
                            },
                            fillColor: AppColors.employeeCardColor,
                            title: AppStrings.verifyCode.tr,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}