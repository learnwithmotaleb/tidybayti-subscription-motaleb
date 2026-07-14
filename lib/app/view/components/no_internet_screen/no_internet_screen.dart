import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_images/app_images.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

import '../../../utils/app_strings/app_strings.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key, required this.onTap});
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.blue500,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 121.h,
                ),

                const CustomImage(imageSrc: AppImages.noInternet),

                CustomText(
                  top: 12.h,
                  text: AppStrings.whoops.tr,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  bottom: 12,
                ),
                CustomText(
                  text: AppStrings.noInternetConnection.tr,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  maxLines: 2,
                ),
                SizedBox(
                  height: 24.h,
                ),

                ///=====================TryAgain Button===================
                CustomButton(
                  onTap: onTap,
                  title: AppStrings.tryAgain.tr,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
