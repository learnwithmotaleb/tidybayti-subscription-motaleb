import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/setting_controller/setting_controller.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';

import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';

import 'package:tidybayte/app/view/components/custom_text_field/custom_text_field.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final SettingController settingController = Get.find<SettingController>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xCCE8F3FA), // First color (with opacity)
                Color(0xFFB5D8EE),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding:  ResponsiveHelper.symmetric(vertical: 40),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///=============================== Change Password  Appbar========================
                  CustomMenuAppbar(
                    title: AppStrings.changePassword.tr,
                    onBack: () {
                      Get.back();
                    },
                  ),

                  ///=============================== aboutUs ========================
                  Padding(
                    padding:  ResponsiveHelper.symmetric(horizontal: 20),
                    child: Obx(() {
                      return Form(
                        key: formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: ResponsiveHelper.spacing(120),
                            ),

                            ///========================Present Password===================
                            CustomTextField(
                              isPassword: true,
                              hintText: AppStrings.currentPassword.tr,
                              textEditingController:
                                  settingController.oldPasswordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppStrings
                                      .passwordMustHaveEightWith.tr;
                                } else if (value.length < 8 ||
                                    !AppStrings.passRegexp.hasMatch(value)) {
                                  return AppStrings.passwordLengthAndContain.tr;
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 40.h,
                            ),

                            ///=================================New Password===============
                            CustomTextField(
                              isPassword: true,
                              hintText: AppStrings.newPassword.tr,
                              textEditingController:
                                  settingController.newPasswordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppStrings
                                      .passwordMustHaveEightWith.tr;
                                } else if (value.length < 8 ||
                                    !AppStrings.passRegexp.hasMatch(value)) {
                                  return AppStrings.passwordLengthAndContain.tr;
                                } else if (value ==
                                    settingController
                                        .oldPasswordController.text) {
                                  return AppStrings
                                      .newPasswordCannotBeSameAsCurrentPassword
                                      .tr;
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: ResponsiveHelper.spacing(16),
                            ),

                            ///==========================Confirm Password==================
                            CustomTextField(
                              isPassword: true,
                              hintText: AppStrings.confirmPassword.tr,
                              fillColor:
                                  AppColors.employeeCardColor.withOpacity(0.5),
                              textEditingController:
                                  settingController.confirmPasswordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppStrings.fieldCantBeEmpty;
                                } else if (value !=
                                    settingController
                                        .newPasswordController.text) {
                                  return AppStrings.passwordShouldMatch;
                                } else if (value ==
                                    settingController
                                        .oldPasswordController.text) {
                                  return AppStrings
                                      .newPasswordCannotBeSameAsCurrentPassword
                                      .tr;
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: ResponsiveHelper.spacing(40),
                            ),

                            ///=====================================Button================

                            settingController.isChangeLoading.value
                                ? const CustomLoader()
                                : CustomButton(
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        settingController.changePassword();
                                      }
                                    },
                                    title: AppStrings.savePassword.tr,
                                    fillColor: AppColors.employeeCardColor,
                                  ),
                          ],
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
