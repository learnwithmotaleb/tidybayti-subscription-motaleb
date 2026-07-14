import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/utils/app_images/app_images.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

class FreeServiceScreen extends StatelessWidget {
  FreeServiceScreen({super.key});

  final List<String> listPackages = [
    AppStrings.inviteUnlimited,
    AppStrings.assignTasksTo,
    AppStrings.masterYourCleaningSchedule,
    AppStrings.manageMultiplePlaces
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AppImages.signInBackground,
                fit: BoxFit.cover,
              ),
            ),

            // Content
            Positioned(
              top: 113.h, // Adjust based on your design requirements
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.w),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: AppStrings.youHaveSevenDays,
                        fontWeight: FontWeight.w500,
                        fontSize: 20.sp,
                        color: AppColors.freeServiceColor,
                      ),
                      SizedBox(height: 24.h),
                      CustomText(
                        text: AppStrings.congratulations,
                        textAlign: TextAlign.start,
                        maxLines: 4,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        color: AppColors.dark300,
                      ),
                      SizedBox(height: 16.h),
                      Column(
                        children: List.generate(listPackages.length, (index) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  const CustomImage(imageSrc: AppIcons.premium),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  CustomText(
                                    text: listPackages[index],
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: AppColors.dark300,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              )
                            ],
                          );
                        }),
                      ),
                      CustomText(
                        top: 24,
                        bottom: 24,
                        text: AppStrings.ourSubscriptionPackages,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: AppColors.blue900,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              color: AppColors.light200,
                              child: const Column(
                                children: [
                                  CustomText(
                                    text: AppStrings.premium,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: AppColors.red,
                                  ),
                                  CustomText(
                                    top: 5,
                                    text: AppStrings.twelveMonthPackage,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: AppColors.freeServiceColor,
                                  ),
                                  CustomText(
                                    top: 17,
                                    text: AppStrings.bhd3,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: AppColors.bhdColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              color: AppColors.light200,
                              child: const Column(
                                children: [
                                  CustomText(
                                    text: AppStrings.premiumPro,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: AppColors.red,
                                  ),
                                  CustomText(
                                    top: 5,
                                    text: AppStrings.oneMonthsPackage,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: AppColors.freeServiceColor,
                                  ),
                                  CustomText(
                                    top: 17,
                                    text: AppStrings.bhd4,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: AppColors.bhdColor,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),

            ///======================================Continue Button===================
            Positioned(
              bottom: 20.h, // Add space from the bottom
              left: 20.w,
              right: 20.w,
              child: CustomButton(
                onTap: () {
                  Get.toNamed(AppRoutes.homeScreen);
                },
                fillColor: AppColors.employeeCardColor,
                title: AppStrings.continues,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
