import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_menu_item/custom_menu_item.dart';

import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

class TaskSchedule extends StatelessWidget {
  const TaskSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.createTask);
          },
          child: Container(
            height: ResponsiveHelper.height(64),
            // ✅ same height
            margin: ResponsiveHelper.all(10),
            // ✅ same margin
            padding: ResponsiveHelper.symmetric(horizontal: 16),
            // ✅ same padding
            decoration: BoxDecoration(
              color: AppColors.blue50, // 🎨 different background color
              borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8),), // ✅ same radius
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // ✅ CENTER CONTENT
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 CustomImage(
                  imageSrc: AppIcons.add,
                  imageType: ImageType.svg,
                  //imageColor: AppColors.primaryBg, // 🎨 different icon color
                  imageColor: AppColors.black,
                  sizeHeight: ResponsiveHelper.iconSize(24),
                ),
                SizedBox(width: ResponsiveHelper.spacing(12),),
                CustomText(
                  text: AppStrings.addTask.tr,
                  fontSize: ResponsiveHelper.fontSize(24),
                  fontWeight: FontWeight.w400,
                  //color: AppColors.dark400,
                 // color: AppColors.blue,
                  color: AppColors.black,
                ),
              ],
            ),
          ),
        ),

        ///========================All task ======================
        CustomMenuItem(
            image: AppIcons.allTask,
            text: AppStrings.allTasks.tr,
            onTap: () {
              Get.toNamed(AppRoutes.allTaskScreen);
            }),

        ///=============================Completed task===============
        CustomMenuItem(
            image: AppIcons.completeTask,
            text: AppStrings.completedTask.tr,
            onTap: () {
              Get.toNamed(AppRoutes.completedScreen);
            }),

        ///==================================Ongoing Task==============
        // CustomMenuItem(
        //     image: AppIcons.ongoing,
        //     text: AppStrings.ongoingTask.tr,
        //     onTap: () {
        //       Get.toNamed(AppRoutes.ongoingTask);
        //     }),

        ///=============================Pending ==================
        CustomMenuItem(
            image: AppIcons.ongoing,
            text: AppStrings.pendingTask.tr,
            onTap: () {
              Get.toNamed(AppRoutes.pendingTask);
            }),

        ///==============================Grocery====================
        CustomMenuItem(
            image: AppIcons.grocery,
            text: AppStrings.shoppingList.tr,
            onTap: () {
              Get.toNamed(AppRoutes.groceryTask);
            }),
      ],
    );
  }
}
