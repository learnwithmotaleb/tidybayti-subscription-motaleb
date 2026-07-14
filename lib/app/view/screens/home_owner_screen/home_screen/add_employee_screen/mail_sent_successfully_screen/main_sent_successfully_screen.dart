import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/schedule_screen/schedule_screen.dart';

class MainSentSuccessfullyScreen extends StatelessWidget {
  const MainSentSuccessfullyScreen({super.key});

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
                Color(0xCCE8F3FA),
                Color(0xFFB5D8EE),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                ///=============================== Menu Title ========================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomMenuAppbar(
                      title: '',
                      onBack: () {
                        Get.back();
                      },
                    ),
                  ],
                ),

                ///=============================== Menu Items ========================
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(ResponsiveHelper.padding(16.0)),
                    children: [
                      Container(
                        height: ResponsiveHelper.width(96),
                        width: ResponsiveHelper.width(96),
                        decoration: const BoxDecoration(
                          color: AppColors.blue900,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: CustomImage(
                            imageSrc: AppIcons.rightUp,
                          ),
                        ),
                      ),

                      CustomText(
                        top: ResponsiveHelper.spacing(24),
                        bottom: ResponsiveHelper.spacing(40),
                        maxLines: 2,
                        text: AppStrings.mailSendSuccessfully.tr,
                        fontWeight: FontWeight.w400,
                        fontSize: ResponsiveHelper.fontSize(24),
                        color: AppColors.dark400,
                      ),

                      SizedBox(height: ResponsiveHelper.spacing(10)),

                      CustomButton(
                        fillColor: Colors.white,
                        onTap: () {
                          Get.toNamed(AppRoutes.addEmployeeScreen);
                        },
                        title: AppStrings.addNewEmployee.tr,
                      ),

                      SizedBox(height: ResponsiveHelper.spacing(10)),

                      CustomButton(
                        fillColor: Colors.white,
                        onTap: () {
                          Get.to(const ScheduleScreen());
                        },
                        title: AppStrings.scheduleOverview.tr,
                      ),

                      ///=========================backToHome==============
                      SizedBox(height: ResponsiveHelper.spacing(10)),

                      CustomButton(
                        fillColor: Colors.white,
                        onTap: () {
                          Get.toNamed(AppRoutes.homeScreen);
                        },
                        title: AppStrings.backToHome.tr,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}