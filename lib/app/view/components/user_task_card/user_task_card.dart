import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

class UserTaskCard extends StatelessWidget {
  final String name;
  final String role;
  final String workTitle;
  final String? offDay;
  final String? workingDay;
  final String workDetails;
  final String time;
  final String imageUrl;
  final bool? isOffDay;
  final bool? isWorkingDay;
  final String? date; // ✅ যোগ করুন

  const UserTaskCard({
    super.key,
    required this.name,
    required this.role,
    required this.workTitle,
    required this.workDetails,
    required this.time,
    required this.imageUrl,
    this.offDay,
    this.isOffDay,
    this.workingDay,
    this.isWorkingDay,
    this.date, // ✅ যোগ করুন
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 250.w,

          padding: ResponsiveHelper.all(10),
          margin: EdgeInsets.only(top: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)


          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isOffDay == true)
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: CustomText(
                    text: AppStrings.offDay.tr,
                    color: AppColors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                )
              else
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      textAlign: TextAlign.start,
                      text: workTitle,
                      color: AppColors.dark400,
                      fontWeight: FontWeight.w400,
                      fontSize: ResponsiveHelper.fontSize(18),
                    ),
                    CustomText(
                      textAlign: TextAlign.start,
                      text: role,
                      color: AppColors.dark200,
                      fontWeight: FontWeight.w400,
                      fontSize: ResponsiveHelper.fontSize(14),
                    ),
                    SizedBox(height:ResponsiveHelper.spacing(10)),
                    Container(
                      width: 200.w,
                      margin: EdgeInsets.only(right: 10.w),
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: AppColors.blue100,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5.h),
                          CustomText(
                            textAlign: TextAlign.start,
                            text: workDetails,
                            color: AppColors.dark300,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),

                          // ✅ Date row যোগ করুন
                          if (date != null && date!.isNotEmpty)
                            Row(
                              children: [
                                 CustomImage(
                                  imageSrc: AppIcons.calendar,
                                  imageType: ImageType.svg,
                                  imageColor: AppColors.dark400,
                                  sizeHeight: ResponsiveHelper.iconSize(18),
                                  sizeWidth:ResponsiveHelper.iconSize(18),
                                ),
                                CustomText(
                                  left: 5,
                                  textAlign: TextAlign.start,
                                  text: date!,
                                  color: AppColors.dark400,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ],
                            ),

                          // ✅ Time row (আগের মতোই)
                          Row(
                            children: [
                               CustomImage(
                                imageSrc: AppIcons.clock,
                                imageType: ImageType.svg,
                                imageColor: AppColors.dark400,
                                sizeHeight: ResponsiveHelper.iconSize(18),
                                 sizeWidth:ResponsiveHelper.iconSize(18),
                              ),
                              CustomText(
                                left: 5,
                                textAlign: TextAlign.start,
                                text: time,
                                color: AppColors.dark400,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ],
                          ),



                        ],
                      ),
                    ),


                    // ✅ inner Container এর নিচে এটা যোগ করুন
                    if (workingDay != null && workingDay!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Wrap(
                          spacing: 4.w,
                          runSpacing: 4.h,
                          children: workingDay!.split(', ').map((day) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.blue100,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.blue300,
                                  width: 1,
                                ),
                              ),
                              child: CustomText(
                                text: day,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.dark400,
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}