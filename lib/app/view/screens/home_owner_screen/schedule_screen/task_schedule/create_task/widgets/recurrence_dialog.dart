// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import '../controller/create_task_controller.dart';
import '../models/recurrence_data.dart';
import 'custom_recurrence_picker.dart';

class RecurrenceDialog extends StatelessWidget {
  final TextEditingController controller;

  const RecurrenceDialog({super.key, required this.controller});

  static const String oneTimeKey = "ONE_TIME";
  static const String dailyKey = "DAILY";
  static const String everyWeekKey = "EVERY_WEEK";
  static const String every2WeeksKey = "EVERY_2_WEEKS";
  static const String everyMonthKey = "EVERY_MONTH";
  static const String every3MonthsKey = "EVERY_3_MONTHS";
  static const String every6MonthsKey = "EVERY_6_MONTHS";
  static const String everyYearKey = "EVERY_YEAR";

  void _handleRecurrenceSelection(String optionKey) {
    final CreateTaskController taskController = Get.find();
    taskController.presetRrule.value = '';
    switch (optionKey) {
      case oneTimeKey:
        taskController.customRecurrenceData.value =
        const RecurrenceData.oneTime();
        break;
      case dailyKey:
        taskController.customRecurrenceData.value =
        const RecurrenceData.daily();
        break;
      case everyWeekKey:
        taskController.customRecurrenceData.value =
        const RecurrenceData.weekly();
        break;
      case every2WeeksKey:
        taskController.customRecurrenceData.value =
        const RecurrenceData(number: 2, unit: "Weeks");
        break;
      case everyMonthKey:
        taskController.customRecurrenceData.value =
        const RecurrenceData.monthly();
        break;
      case every3MonthsKey:
        taskController.customRecurrenceData.value =
        const RecurrenceData(number: 3, unit: "Months");
        break;
      case every6MonthsKey:
        taskController.customRecurrenceData.value =
        const RecurrenceData(number: 6, unit: "Months");
        break;
      case everyYearKey:
        taskController.customRecurrenceData.value =
        const RecurrenceData.yearly();
        break;
    }

    print(
        "Selected: $optionKey, RecurrenceData: ${taskController.customRecurrenceData.value}");
  }

  @override
  Widget build(BuildContext context) {


    String? selectedOption = controller.text;

    Map<String, String> options = {
      oneTimeKey: AppStrings.oneTime,
      dailyKey: AppStrings.daily,
      everyWeekKey: AppStrings.everyWeek,
      every2WeeksKey: AppStrings.every2Weeks,
      everyMonthKey: AppStrings.everyMonth,
      every3MonthsKey: AppStrings.every3Months,
      every6MonthsKey: AppStrings.every6Months,
      everyYearKey: AppStrings.everyYear,
    };

    return Directionality(
      textDirection: TextDirection.ltr,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(12), // ✅ was: 12.r
          ),
        ),
        contentPadding: const EdgeInsets.all(0),
        content: Padding(
          padding: ResponsiveHelper.symmetric(horizontal: 12, vertical: 12), // ✅ was: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h)
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...options.entries.map((entry) {
                  String optionKey = entry.key;
                  String translatedOption = entry.value;

                  return InkWell(
                    onTap: () {
                      controller.text = translatedOption;
                      _handleRecurrenceSelection(optionKey);
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: [
                        Container(
                          color: Colors.blue.shade50,
                          padding: ResponsiveHelper.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ), // ✅ was: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w)
                          child: Row(
                            children: [
                              Radio<String>(
                                value: translatedOption,
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.text = value;
                                    _handleRecurrenceSelection(optionKey);
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                              SizedBox(width: ResponsiveHelper.spacing(8)), // ✅ was: 8.w
                              CustomText(
                                text: translatedOption,
                                fontSize: ResponsiveHelper.fontSize(16), // ✅ was: 16.sp
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(8)), // ✅ was: 8.h
                      ],
                    ),
                  );
                }),
                Divider(height: ResponsiveHelper.height(1)), // ✅ was: 1.h
                SizedBox(height: ResponsiveHelper.spacing(8)), // ✅ was: 8.h
                CustomButton(
                  onTap: () async {
                    final recurrenceData = await showDialog<RecurrenceData>(
                      context: context,
                      builder: (_) => const CustomRecurrencePicker(),
                    );

                    if (recurrenceData != null) {
                      // controller.text = recurrenceData.toString();
                      // Get.find<CreateTaskController>()
                      //     .customRecurrenceData
                      //     .value = recurrenceData;
                      // Navigator.pop(context);



                      final taskController = Get.find<CreateTaskController>();

                      // 🔥 IMPORTANT: clear preset rrule
                      taskController.presetRrule.value = '';

                      // set custom recurrence
                      taskController.customRecurrenceData.value = recurrenceData;

                      controller.text = recurrenceData.toString();

                      Navigator.pop(context);
                    }
                  },
                  title: AppStrings.custom.tr,
                  fillColor: AppColors.news,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}