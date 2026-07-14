import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/wallet_controller/wallet_controller.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/components/custom_text_field/custom_text_field.dart';

class GlobalAlert {
//Delete Dialog
  static showDeleteDialog(
      BuildContext context, VoidCallback onConfirm, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: AlertDialog(
            title: Text(AppStrings.confirmDelete.tr),
            content: Text(title),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppStrings.cancel.tr,
                    style: const TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  onConfirm();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.addedColor),
                child: Text(AppStrings.delete.tr),
              ),
            ],
          ),
        );
      },
    );
  } //Delete Dialog

  static showEditBudgetDialog(
    BuildContext context,
    WalletController controller,
    String budgetId,
    String oldCategory,
    String oldAmount,
  ) {
    final catCtrl = TextEditingController(text: oldCategory);
    final amtCtrl = TextEditingController(text: oldAmount);

    showDialog(
      context: context,
      builder: (_) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: AlertDialog(
            backgroundColor: AppColors.white,
            title: Center(
              child: Text(
                AppStrings.editBudget.tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: AppColors.black,
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  textEditingController: catCtrl,
                  readOnly: true,
                  fillColor: AppColors.blue100,
                ),
                SizedBox(height:  ResponsiveHelper.spacing(10)),
                CustomTextField(
                  textEditingController: amtCtrl,
                  fillColor: AppColors.blue100,
                ),
                SizedBox(height: ResponsiveHelper.spacing(20)),
                Obx(() => CustomButton(
                      fillColor: AppColors.blue300,
                      title: controller.isBudgetUpdating.value
                          ? AppStrings.updating.tr
                          : AppStrings.save.tr,
                      onTap: () {
                        if (controller.isBudgetUpdating.value) return;

                        controller.editBudget(
                          budgetId: budgetId,
                          category: catCtrl.text.trim(),
                          amount: amtCtrl.text.trim(),
                        );
                      },
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  //Single Task Dialog
  static void singleTaskDialog(
      BuildContext context,
      String title,
      String assignedTo,
      String recurrence,
      String startDate,
      String startTime,
      String endDate,
      String endTime) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: AlertDialog(
            backgroundColor: AppColors.white,
            title: Center(
              child: Text(
                AppStrings.taskScheduleDetails.tr,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color: AppColors.dark300),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(AppStrings.task.tr, title),
                _buildDetailRow(AppStrings.assignToColon.tr, assignedTo),
                // _buildDetailRow(AppStrings.recurrenceColon.tr, recurrence),
                _buildDetailRow('${AppStrings.startDate.tr}' ':', startDate),
                _buildDetailRow('${AppStrings.startTime.tr}' ':', startTime),
                // _buildDetailRow("End Date".tr, endDate),
                _buildDetailRow('${AppStrings.endTime.tr}' ':', endTime),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  AppStrings.close.tr,
                  style: const TextStyle(
                      color: AppColors.blue900, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.dark300,
            left: 8,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: CustomText(
              textAlign: TextAlign.start,
              text: value,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: AppColors.dark300,
            ),
          ),
        ],
      ),
    );
  }
}
