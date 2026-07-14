import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';

import 'package:tidybayte/app/utils/app_images/app_images.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';

class HomeOwnerChoseAuth extends StatelessWidget {
  HomeOwnerChoseAuth({super.key});

  final String role = Get.arguments ?? "Unknown";

  @override
  Widget build(BuildContext context) {


    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              /// BACKGROUND
              SizedBox(
                width: ResponsiveHelper.screenWidth,
                height: ResponsiveHelper.screenHeight,
                child: Image.asset(
                  AppImages.onBoardBackground,
                  fit: BoxFit.cover,
                ),
              ),

              /// CONTENT
              Positioned(
                child: Padding(
                  padding: ResponsiveHelper.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: ResponsiveHelper.height(290)),

                      role == "Employee"
                          ? SizedBox(height: ResponsiveHelper.height(100))
                          : const SizedBox(),

                      /// BUTTONS SECTION
                      Center(
                        child: Column(
                          children: [
                            /// SIGN IN
                            CustomButton(
                              width: ResponsiveHelper.screenWidth / 1.7,
                              onTap: () {
                                Get.toNamed(
                                  AppRoutes.signInScreen,
                                  arguments: role,
                                );
                              },
                              fillColor: AppColors.employeeCardColor,
                              title: AppStrings.signIn.tr,
                            ),

                            /// SIGN UP (only for non-Employee)
                            role == "Employee"
                                ? const SizedBox()
                                : SizedBox(
                              height: ResponsiveHelper.spacing(16),
                            ),

                            role == "Employee"
                                ? const SizedBox()
                                : CustomButton(
                              width: ResponsiveHelper.screenWidth / 1.7,
                              onTap: () {
                                Get.toNamed(AppRoutes.signUpScreen);
                              },
                              fillColor: AppColors.employeeCardColor,
                              title: AppStrings.signUp.tr,
                            ),

                            role == "Employee"
                                ? const SizedBox()
                                : SizedBox(
                              height: ResponsiveHelper.height(200),
                            ),

                            /// TERMS TEXT
                            role == "Employee"
                                ? const SizedBox()
                                : RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: AppStrings.bySigningUp.tr,
                                    style: TextStyle(
                                      color: AppColors.dark300,
                                      fontWeight: FontWeight.w300,
                                      fontSize:
                                      ResponsiveHelper.fontSize(16),
                                    ),
                                  ),

                                  /// TERMS OF USE
                                  TextSpan(
                                    text:
                                    " ${AppStrings.termsOfUse.tr} ",
                                    style: TextStyle(
                                      color: AppColors.dark400,
                                      fontSize:
                                      ResponsiveHelper.fontSize(16),
                                      fontWeight: FontWeight.w500,
                                      decoration:
                                      TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.toNamed(AppRoutes
                                            .termsAndServiceScreen);
                                      },
                                  ),

                                  TextSpan(
                                    text: " ${AppStrings.and.tr} ",
                                    style: TextStyle(
                                      color: AppColors.dark300,
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                      ResponsiveHelper.fontSize(16),
                                    ),
                                  ),

                                  /// PRIVACY POLICY
                                  TextSpan(
                                    text: AppStrings.privacyPolicy.tr,
                                    style: TextStyle(
                                      color: AppColors.dark400,
                                      fontSize:
                                      ResponsiveHelper.fontSize(16),
                                      decoration:
                                      TextDecoration.underline,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.toNamed(AppRoutes
                                            .privacyPolicyScreen);
                                      },
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: ResponsiveHelper.spacing(40)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
