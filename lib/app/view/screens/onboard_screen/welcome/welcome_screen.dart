import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';

import 'package:tidybayte/app/utils/app_images/app_images.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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

              Positioned(
                child: Padding(
                  padding: ResponsiveHelper.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ResponsiveHelper.height(429)),

                      /// WELCOME TEXT
                      const CustomText(
                        text: AppStrings.welcome,
                        fontSize: 48,
                        fontWeight: FontWeight.w400,
                        color: AppColors.light50,
                      ),

                      /// DESCRIPTION
                      const CustomText(
                        textAlign: TextAlign.start,
                        text: AppStrings.createAnAccountAndAccess,
                        fontSize: 24,
                        maxLines: 3,
                        fontWeight: FontWeight.w300,
                        color: AppColors.dark300,
                        bottom: 20,
                      ),

                      /// BUTTON
                      CustomButton(
                        width: ResponsiveHelper.screenWidth / 1.7,
                        onTap: () {
                          Get.toNamed(AppRoutes.choseOnBoardingScreen);
                        },
                        fillColor: AppColors.employeeCardColor,
                        title: AppStrings.gettingStarted,
                        radius: ResponsiveHelper.borderRadius(16),
                      ),

                      SizedBox(height: ResponsiveHelper.spacing(36)),
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
