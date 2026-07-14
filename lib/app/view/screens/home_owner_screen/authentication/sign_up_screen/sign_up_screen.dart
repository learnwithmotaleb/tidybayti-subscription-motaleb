import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/controller/auth_controller.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_images/app_images.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_rech_text/custom_rich_text.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/components/custom_text_field/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final AuthController authController = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {


    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Obx(() {
          return Form(
            key: formKey,
            child: Stack(
              children: [
                /// ========== Background Image ==========
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Image.asset(
                    AppImages.signInBackground,
                    fit: BoxFit.cover,
                  ),
                ),

                /// ========== SignUp Form ==========
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.padding(20),
                    vertical: ResponsiveHelper.spacing(40),
                  ),
                  child: SingleChildScrollView(
                    clipBehavior: Clip.none,
                    child: Column(
                      children: [
                        /// ========== Header ==========
                        Row(
                          children: [
                            SizedBox(width: ResponsiveHelper.spacing(8)),
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: AppColors.black,
                                size: ResponsiveHelper.iconSize(20),
                              ),
                            ),
                            const Spacer(),
                            CustomText(
                              text: AppStrings.signUp.tr,
                              fontWeight: FontWeight.w500,
                              fontSize: ResponsiveHelper.fontSize(20),
                              color: AppColors.blue900,
                            ),
                            const Spacer(),
                          ],
                        ),

                        SizedBox(height: ResponsiveHelper.spacing(30)),

                        /// ========== First Name ==========
                        CustomTextField(
                          hintText: AppStrings.firstName.tr,
                          fillColor: AppColors.employeeCardColor,
                          textEditingController:
                          authController.firstNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStrings.fieldCantBeEmpty;
                            } else if (value.length < 3) {
                              return AppStrings.enterAValidName;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(10)),

                        /// ========== Last Name ==========
                        CustomTextField(
                          hintText: AppStrings.lastName.tr,
                          textEditingController:
                          authController.lastNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStrings.fieldCantBeEmpty;
                            } else if (value.length < 3) {
                              return AppStrings.enterAValidName;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(10)),

                        /// ========== Contact Number ==========
                        CustomTextField(
                          hintText: AppStrings.contactNumber.tr,
                          textEditingController:
                          authController.phoneNumberController,
                          keyboardType: TextInputType.phone,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return AppStrings.fieldCantBeEmpty;
                          //   } else if (!RegExp(r'^[0-9]{10,15}$')
                          //       .hasMatch(value)) {
                          //     return "Enter a valid phone number";
                          //   }
                          //   return null;
                          // },


                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStrings.fieldCantBeEmpty;
                            } else if (value.length < 6) {
                              return "Enter a valid phone number";
                            }
                            return null;
                          },

                        ),
                        SizedBox(height: ResponsiveHelper.spacing(10)),

                        /// ========== Email ==========
                        CustomTextField(
                          hintText: AppStrings.email.tr,
                          textEditingController: authController.emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStrings.enterValidEmail;
                            } else if (!AppStrings.emailRegexp
                                .hasMatch(value)) {
                              return AppStrings.enterValidEmail;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(10)),

                        /// ========== Password ==========
                        CustomTextField(
                          hintText: AppStrings.password.tr,
                          isPassword: true,
                          textEditingController:
                          authController.passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStrings.passwordMustHaveEightWith;
                            } else if (value.length < 8 ||
                                !AppStrings.passRegexp.hasMatch(value)) {
                              return AppStrings.passwordLengthAndContain;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(10)),

                        /// ========== Confirm Password ==========
                        CustomTextField(
                          hintText: AppStrings.confirmPassword.tr,
                          isPassword: true,
                          textEditingController:
                          authController.confirmPasswordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStrings.fieldCantBeEmpty;
                            } else if (value !=
                                authController.passwordController.text) {
                              return "Password should match";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(24)),

                        /// ========== Create Account Button ==========
                        authController.signUpLoading.value
                            ? const CustomLoader()
                            : CustomButton(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              authController.signup();
                            }
                          },
                          fillColor: AppColors.employeeCardColor,
                          title: AppStrings.createAccount.tr,
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(20)),

                        /// ========== Already Have Account ==========
                        CustomRichTextLink(
                          firstText: AppStrings.alreadyHaveAnYAccount.tr,
                          linkText: AppStrings.signIn.tr,
                          onTap: () => Get.toNamed(AppRoutes.signInScreen),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(30)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}