import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart'; // Assuming you use GetX
import 'package:tidybayte/app/global/helper/responsive_helper.dart';

import 'package:tidybayte/app/utils/app_colors/app_colors.dart'; // Example path
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart'; // Example path

class CustomGroceryDetailsDialog extends StatelessWidget {
  const CustomGroceryDetailsDialog({
    super.key,
    required this.assignTo,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.groceryItems,
    this.taskDetails,
    this.additionalMessage,
    this.house,
    this.room,
    this.recurrence,
  });

  final String assignTo;
  final String startTime;
  final String endTime;
  final String date;
  final List<String> groceryItems;
  final String? taskDetails;
  final String? additionalMessage;
  final String? house;
  final String? room;
  final String? recurrence;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular( ResponsiveHelper.borderRadius(10),),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            minHeight: 100.h,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: ResponsiveHelper.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar with title and close icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: AppStrings.shoppingTaskDetails.tr,
                        fontSize: ResponsiveHelper.fontSize(20),
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark400,
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(Icons.close,
                            size:  ResponsiveHelper.iconSize(24),
                            color: AppColors.dark300),
                      ),
                    ],
                  ),
                  SizedBox(height:  ResponsiveHelper.spacing(20),),

                  // Assign to
                  _buildDetailRow("${AppStrings.assignTo.tr} :", assignTo),
                  SizedBox(height: ResponsiveHelper.spacing(10),),

                  // Date
                  _buildDetailRow("${AppStrings.date.tr} :", date),
                  SizedBox(height: ResponsiveHelper.spacing(10),),

                  // Start Time
                  _buildDetailRow("${AppStrings.startTime.tr} :", startTime),
                  SizedBox(height: ResponsiveHelper.spacing(10),),

                  // End Time
                  _buildDetailRow("${AppStrings.endTime.tr} :", endTime),
                  SizedBox(height: ResponsiveHelper.spacing(10),),

                  // Grocery Items Title
                  CustomText(
                    text: "${AppStrings.shoppingItem.tr}:".tr,
                    fontSize: ResponsiveHelper.fontSize(16),
                    fontWeight: FontWeight.w500,
                    color: AppColors.dark300,
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(5),),

                  // Grocery Items List
                  ListView.separated(
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable inner scroll
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: ResponsiveHelper.spacing(4),),
                    itemCount: groceryItems.length,
                    separatorBuilder: (_, __) => SizedBox(height: ResponsiveHelper.spacing(6),),
                    itemBuilder: (context, index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: ResponsiveHelper.spacing(20),),
                          Expanded(
                            child: CustomText(
                              text: "${index + 1}. ${groceryItems[index]}",
                              fontSize: ResponsiveHelper.fontSize(18),
                              fontWeight: FontWeight.w400,
                              color: AppColors.dark300,
                              maxLines: 3,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label.tr,
          fontSize: ResponsiveHelper.fontSize(18),
          fontWeight: FontWeight.w500,
          color: AppColors.dark300,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: CustomText(
            text: value,
            fontSize: ResponsiveHelper.fontSize(18),
            fontWeight: FontWeight.w400,
            color: AppColors.dark300,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
