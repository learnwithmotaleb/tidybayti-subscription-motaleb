import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/employee_controller/employee_home_controller.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

import '../additional_pending_task/inner/task_section.dart';

class EmployeeOngoingTask extends StatefulWidget {
  const EmployeeOngoingTask({super.key});

  @override
  State<EmployeeOngoingTask> createState() => _AdditionalPendingTaskState();
}

class _AdditionalPendingTaskState extends State<EmployeeOngoingTask> {
  final EmployeeHomeController controller = Get.find<EmployeeHomeController>();

  @override
  void initState() {
    controller.getOngoing();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Obx(() {
        final taskList = controller.ongoing.value.result ?? [];

        if (controller.isLoadingAdditionalTask.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (taskList.isEmpty) {
          return Center(
            child: CustomText(
              text: AppStrings.noOngoingTasksAvailable.tr,
              color: AppColors.dark200,
              fontWeight: FontWeight.w400,
              fontSize: ResponsiveHelper.fontSize(16),
            ),
          );
        }

        return Column(
          children: [
            /// ================== Task Schedule Section ==================
            TaskSection(
              isButton: true,
              title: AppStrings.taskSchedule.tr,
              buttonTitle: AppStrings.completeTask.tr,
              taskCount: taskList.length,
              tasks: taskList,
              onTap: (String taskId) {
                controller.employeePendingTask(
                    taskId: taskId, status: "completed");
              },
            ),
            SizedBox(height: ResponsiveHelper.spacing(16),),
          ],
        );
      }),
    );
  }
}
