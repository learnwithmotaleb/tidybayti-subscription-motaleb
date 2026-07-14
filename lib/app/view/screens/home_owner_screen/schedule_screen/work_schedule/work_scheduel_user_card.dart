import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

class WorkScheduleUserCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final List<Map<String, String>> tasks;
  final String? offDay;
  final bool? isOffDay;
  final String? workingDay;
  final bool? isWorkingDay;

  const WorkScheduleUserCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.tasks,
    this.offDay,
    this.isOffDay = false,
    this.workingDay,
    this.isWorkingDay = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: ResponsiveHelper.all(10),
      margin: EdgeInsets.only(bottom: ResponsiveHelper.padding(15)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile Image
              CustomNetworkImage(
                boxShape: BoxShape.circle,
                imageUrl: imageUrl,
                height: ResponsiveHelper.iconSize(35),
                width: ResponsiveHelper.iconSize(35),
              ),
              SizedBox(width:ResponsiveHelper.spacing(10),),
              Expanded(
                child: CustomText(
                  textAlign: TextAlign.start,
                  text: name,
                  color: AppColors.dark400,
                  fontWeight: FontWeight.w400,
                  fontSize: ResponsiveHelper.fontSize(18),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const Spacer(),
              isOffDay == true
                  ?  CustomText(
                      text: "Off Day",
                      color: AppColors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveHelper.fontSize(14),
                    )
                  : SizedBox(height: ResponsiveHelper.spacing(50),),
            ],
          ),
          isOffDay == true
              ? const SizedBox()
              : SizedBox(
                  height: ResponsiveHelper.height(95),
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Container(
                        width: ResponsiveHelper.width(200),
                        margin: EdgeInsets.only(right: 10.r),
                        padding: ResponsiveHelper.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.blue100,
                          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(6),),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Task Title
                            CustomText(
                              textAlign: TextAlign.start,
                              text: task['title']!,
                              color: AppColors.dark500,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                            ),

                            SizedBox(height: ResponsiveHelper.height(5),),

                            // Task Details
                            Expanded(
                              child: CustomText(
                                textAlign: TextAlign.start,
                                text: task['details']!,
                                color: AppColors.dark300,
                                fontWeight: FontWeight.w400,
                                fontSize: ResponsiveHelper.fontSize(14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            SizedBox(height: ResponsiveHelper.height(5),),

                            // Time with Calendar Icon
                            Row(
                              children: [
                                const CustomImage(
                                  imageSrc: AppIcons.watch,
                                  imageType: ImageType.svg,
                                  imageColor: AppColors.dark400,
                                ),
                                Expanded(
                                  child: CustomText(
                                    left: 5,
                                    textAlign: TextAlign.start,
                                    text: task['time']!,
                                    color: AppColors.dark400,
                                    fontWeight: FontWeight.w400,
                                    fontSize: ResponsiveHelper.fontSize(12),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
