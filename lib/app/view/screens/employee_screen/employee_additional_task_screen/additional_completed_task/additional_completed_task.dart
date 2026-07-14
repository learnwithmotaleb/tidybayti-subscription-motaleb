import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/employee_controller/employee_home_controller.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';

import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/screens/employee_screen/employee_additional_task_screen/additional_pending_task/inner/task_section.dart';

class AdditionalCompletedTask extends StatefulWidget {
  const AdditionalCompletedTask({super.key});

  @override
  State<AdditionalCompletedTask> createState() => _AdditionalPendingTaskState();
}

class _AdditionalPendingTaskState extends State<AdditionalCompletedTask> {
  final EmployeeHomeController controller = Get.find<EmployeeHomeController>();

  @override
  void initState() {
    controller.getComplete();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Loading completed:==================================================== ${controller.isLoadingAdditionalTask.value}");
    return Padding(
      padding: ResponsiveHelper.all(16),
      child: Obx(() {
        final taskList = controller.completeTask.value.result ?? [];

        if (controller.isLoadingCompletedTask.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (taskList.isEmpty) {
          return Center(
            child: CustomText(
              text: AppStrings.noCompletedTasksAvailable.tr,
              color: AppColors.dark200,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          );
        }

        return Column(
          children: [
            /// ================== Task Schedule Section ==================
            TaskSection(
              title: AppStrings.taskSchedule.tr,
              taskCount: taskList.length,
              tasks: taskList,
            ),
            SizedBox(height: ResponsiveHelper.spacing(16),),
          ],
        );
      }),
    );
  }
}


