import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/language_controller/langauge_controller.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_images/app_images.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

class LanguageOnBoardingScreen extends StatelessWidget {
  LanguageOnBoardingScreen({super.key});

  final LanguageController languageController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.blue500,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.languageBg),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: ResponsiveHelper.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: ResponsiveHelper.spacing(18)),

                    /// TITLE
                    Align(
                      alignment: Alignment.center,
                      child: CustomText(
                        text: AppStrings.chooseYourLanguage.tr,
                        color: AppColors.black,
                        fontWeight: FontWeight.w400,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        fontSize: ResponsiveHelper.fontSize(26),
                      ),
                    ),

                    SizedBox(height: ResponsiveHelper.spacing(8)),
                    Divider(color: Colors.grey.shade300),

                    SizedBox(height: ResponsiveHelper.spacing(120)),

                    /// ENGLISH BUTTON
                    CustomButton(
                      width: double.infinity,
                      onTap: () {
                        languageController.changeLocale(const Locale("en", "US"));
                      },
                      fillColor: AppColors.white,
                      title: "English".tr,
                      radius: ResponsiveHelper.borderRadius(16),
                      textColor: AppColors.englishText,
                    ),

                    SizedBox(height: ResponsiveHelper.spacing(8)),

                    /// ARABIC BUTTON
                    CustomButton(
                      width: double.infinity,
                      onTap: () {
                        languageController.changeLocale(const Locale("ar", "SA"));
                      },
                      fillColor: AppColors.white,
                      title: "العربية".tr,
                      radius: ResponsiveHelper.borderRadius(16),
                      textColor: AppColors.englishText,
                    ),

                    SizedBox(height: ResponsiveHelper.spacing(58)),

                    /// SUBMIT BUTTON
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.padding(28),
                      ),
                      child: CustomButton(
                        width: double.infinity,
                        onTap: () {
                          Get.toNamed(AppRoutes.getStartedScreen);
                        },
                        fillColor: AppColors.buttonRed,
                        title: AppStrings.submit.tr,
                        radius: ResponsiveHelper.borderRadius(16),
                        textColor: AppColors.white,
                        fontSize: ResponsiveHelper.fontSize(30),
                      ),
                    ),

                    SizedBox(height: ResponsiveHelper.height(40)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}