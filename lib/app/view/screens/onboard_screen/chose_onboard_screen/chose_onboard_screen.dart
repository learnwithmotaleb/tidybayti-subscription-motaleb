import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_images/app_images.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';

class ChoseOnboardScreen extends StatelessWidget {
  const ChoseOnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              // Background Image
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  AppImages.onBoardBackground,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                  child: Padding(
                padding:  ResponsiveHelper.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: ResponsiveHelper.spacing(350),
                    ),

                    ///============================Owner Button=============
                    Center(
                      child: Column(
                        children: [
                          CustomButton(
                            width: MediaQuery.of(context).size.width / 1.7,
                            onTap: () {
                              Get.toNamed(AppRoutes.homeOwnerChoseAuth,
                                  arguments: "Owner");
                            },
                            fillColor: AppColors.employeeCardColor,
                            title: AppStrings.owner.tr,
                          ),

                          ///============================Employee Button=============
                          SizedBox(
                            height: ResponsiveHelper.spacing(16),
                          ),
                          CustomButton(
                            width: MediaQuery.of(context).size.width / 1.7,
                            onTap: () {
                             Get.toNamed(AppRoutes.homeOwnerChoseAuth,
                                  arguments: "Employee");
                            },
                            fillColor: AppColors.employeeCardColor,
                            title: AppStrings.employee.tr,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}