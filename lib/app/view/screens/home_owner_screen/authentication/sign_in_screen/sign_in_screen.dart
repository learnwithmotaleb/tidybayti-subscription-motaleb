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

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthController authController = Get.find<AuthController>();
  final formKey = GlobalKey<FormState>();
  final String role = Get.arguments ?? "Owner";

  @override
  void initState() {
    super.initState();
    authController.setUserRole(role);
    print("Selected role for login: $role");
  }

  @override
  Widget build(BuildContext context) {


    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Obx(() {
          return Form(
            key: formKey,
            child: SingleChildScrollView(
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
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: ResponsiveHelper.height(267)),

                          /// ========== Email ==========
                          CustomTextField(
                            hintText: AppStrings.email.tr,
                            textEditingController:
                            authController.emailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppStrings.enterValidEmail;
                              } else if (!AppStrings.emailRegexp.hasMatch(
                                  authController.emailController.text)) {
                                return AppStrings.enterValidEmail;
                              } else {
                                return null;
                              }
                            },
                          ),

                          SizedBox(height: ResponsiveHelper.spacing(10)),

                          /// ========== Password ==========
                          CustomTextField(
                            hintText: AppStrings.enterPassword.tr,
                            isPassword: true,
                            textEditingController:
                            authController.passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppStrings.passwordMustHaveEightWith;
                              } else if (value.length < 8 ||
                                  !AppStrings.passRegexp.hasMatch(value)) {
                                return AppStrings.passwordLengthAndContain;
                              } else {
                                return null;
                              }
                            },
                          ),

                          /// ========== Remember & Forgot Password ==========
                          Row(
                            children: [
                              Checkbox(
                                value: authController.isRemember.value,
                                checkColor: AppColors.dark200,
                                activeColor: AppColors.profileCard,
                                onChanged: (value) {
                                  authController.isRemember.value =
                                      value ?? false;
                                  debugPrint(
                                      "Checkbox clicked, Remember value: ${authController.isRemember.value}");
                                },
                              ),
                              CustomRichTextLink(
                                firstText: AppStrings.remember.tr,
                                linkText: '',
                                onTap: () {},
                              ),
                              role == "Employee"
                                  ? const SizedBox()
                                  : const Spacer(),
                              role == "Employee"
                                  ? const SizedBox()
                                  : GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                      AppRoutes.forgotPasswordScreen);
                                },
                                child: CustomText(
                                  decorationColor: AppColors.black,
                                  decoration: TextDecoration.underline,
                                  textAlign: TextAlign.right,
                                  top: 24,
                                  text: AppStrings.forgetPassword.tr,
                                  fontSize:
                                  ResponsiveHelper.fontSize(14),
                                  color: AppColors.dark300,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: ResponsiveHelper.spacing(24)),

                          /// ========== Sign In Button ==========
                          authController.isSignInLoading.value
                              ? const CustomLoader()
                              : CustomButton(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                authController.signIn();
                              }
                            },
                            fillColor: AppColors.employeeCardColor,
                            title: AppStrings.signIn.tr,
                          ),

                          SizedBox(height: ResponsiveHelper.spacing(48)),

                          /// ========== Don't Have Account ==========
                          role == "Employee"
                              ? const SizedBox()
                              : CustomRichTextLink(
                            firstText:
                            AppStrings.dontHaveAnyAccount.tr,
                            linkText: AppStrings.signUp.tr,
                            onTap: () {
                              Get.toNamed(AppRoutes.signUpScreen);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}