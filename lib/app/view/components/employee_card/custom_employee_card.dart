import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

class CustomEmployeeData extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String designation;
  final String id;
  final String email;
  final VoidCallback onDetailsTap;
  final VoidCallback onDeleteTap;

  const CustomEmployeeData({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.designation,
    required this.id,
    required this.email,
    required this.onDetailsTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.normal,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      AppColors.addedColor, // Border color (Change as needed)
                  width: 2.5.w, // Border thickness
                ),
              ),
              child: CustomNetworkImage(
                imageUrl: imageUrl,
                height: 53.h,
                width: 53.w,
                boxShape: BoxShape.circle,
              ),
            ),

            SizedBox(width: 10.w),

            // Employee Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: CustomText(
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          text: '${AppStrings.name.tr} $name',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppColors.dark400,
                        ),
                      ),
                      const Spacer(),

                      // Details Icon
                      GestureDetector(
                        onTap: onDetailsTap,
                        child: const CustomImage(
                          imageSrc: AppIcons.details,
                          imageType: ImageType.svg,
                          imageColor: AppColors.dark400,
                        ),
                      ),
                      SizedBox(width: 10.w),

                      // Delete Icon
                      GestureDetector(
                        onTap: onDeleteTap,
                        child: const CustomImage(
                          imageSrc: AppIcons.delete,
                          imageType: ImageType.svg,
                          imageColor: AppColors.dark400,
                        ),
                      ),
                    ],
                  ),
                  CustomText(
                    text: '${AppStrings.jobType.tr}: $designation',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: AppColors.dark300,
                  ),
                  CustomText(
                    text: '${AppStrings.id.tr}: $id',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: AppColors.dark400,
                  ),
                  CustomText(
                    text: '${AppStrings.email.tr}: $email',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: AppColors.dark400,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
