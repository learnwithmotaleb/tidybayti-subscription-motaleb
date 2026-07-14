import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_colors/app_colors.dart';

class SnackbarHelper {
  static void show({
    required String message,
    String? title,
    bool showIcon = true,
    required bool isSuccess,
    IconData? icon,
    Color? backgroundColor,
    Color textColor = Colors.black,
    Duration duration = const Duration(seconds: 2),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    final Color bgColor = backgroundColor ?? AppColors.addedColor;

    final IconData selectedIcon =
        icon ?? (isSuccess ? Icons.check_circle_outline_rounded : Icons.block);

    Get.rawSnackbar(
      animationDuration: const Duration(milliseconds: 500),
      messageText: showIcon
          ? Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(selectedIcon, color: textColor),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                SizedBox(height: 4.h),
                Text(
                  message,
                  style: TextStyle(color: textColor, fontSize: 13.sp),
                ),
              ],
            ),
      backgroundColor: bgColor,
      duration: duration,
      snackPosition: position,
      margin: EdgeInsets.all(12.r),
      borderRadius: 10.r,
    );
  }
}
