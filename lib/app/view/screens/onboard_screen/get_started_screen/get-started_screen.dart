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

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // IMPORTANT: init responsive
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.imageBgBlue,
      body: Stack(
        children: [
          /// Background Image
          SizedBox(
            width: ResponsiveHelper.screenWidth,
            height: ResponsiveHelper.screenHeight * 0.85,
            child: Image.asset(
              AppImages.getStartedBg,
              fit: BoxFit.cover,
            ),
          ),

          /// Content Layer
          SafeArea(
            child: Padding(
              padding: ResponsiveHelper.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(height: ResponsiveHelper.spacing(50)),

                  /// TOP TEXT
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(22),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        fontFamily: 'sans-serif',
                      ),
                      children: [
                        TextSpan(
                          text: AppStrings.more.tr,
                          style: const TextStyle(
                            color: AppColors.buttonRed,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const TextSpan(
                          text: " CONTROL ",
                          style: TextStyle(color: Color(0xFF2D3436)),
                        ),
                        TextSpan(
                          text: AppStrings.less.tr,
                          style: const TextStyle(
                            color: AppColors.buttonRed,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const TextSpan(
                          text: " STRESS\n",
                          style: TextStyle(color: Color(0xFF2D3436)),
                        ),
                        TextSpan(
                          text: AppStrings.timeForWhatMatters.tr,
                          style: const TextStyle(color: Color(0xFF2D3436)),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  /// BOTTOM TEXT
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: ResponsiveHelper.spacing(20),
                    ),
                    child: Text(
                      "HOME MANAGEMENT. SIMPLIFIED.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(18),
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2D3436),
                      ),
                    ),
                  ),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: ResponsiveHelper.buttonHeight(52),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(16),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed(AppRoutes.choseOnBoardingScreen);
                      },
                      child: Text(
                        "GET STARTED",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: ResponsiveHelper.fontSize(16),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.spacing(48)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}