import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/task_controller/task_controller.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';

import '../../../../../../utils/app_colors/app_colors.dart';

class ToggleWidget extends StatelessWidget {
  const ToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find<TaskController>();

    return Obx(() {
      // 0 = One time, 1 = Recurrence
      final bool isOneTime = controller.selectedDayIndex.value == 0;

      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary),
        ),
        child: Row(
          children: [
            /// One Time Button
            Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.selectedDayIndex.value = 0;
                  controller.getTaskData(apiUrl: ApiUrl.getOneTimeTask);
                },
                child: _ToggleItem(title: 'One time', isSelected: isOneTime),
              ),
            ),

            /// Recurrence Button
            Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.selectedDayIndex.value = 1;
                  controller.getTaskData(apiUrl: ApiUrl.getRecurrenceTask);
                },
                child: _ToggleItem(title: 'Recurrence', isSelected: !isOneTime),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _ToggleItem extends StatelessWidget {
  final String title;
  final bool isSelected;

  const _ToggleItem({required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      key: ValueKey(isSelected),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding:  ResponsiveHelper.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.blue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}