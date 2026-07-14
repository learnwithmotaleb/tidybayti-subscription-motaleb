import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/employee_controller/employee_home_controller.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'inner/task_section.dart';

class AdditionalPendingTask extends StatefulWidget {
  const AdditionalPendingTask({super.key});

  @override
  State<AdditionalPendingTask> createState() => _AdditionalPendingTaskState();
}

class _AdditionalPendingTaskState extends State<AdditionalPendingTask> {
  final EmployeeHomeController controller = Get.find<EmployeeHomeController>();

  @override
  void initState() {
    controller.getPending();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Loading pending:==================================================== ${controller.isLoadingAdditionalTask.value}");

    return Padding(
      padding: ResponsiveHelper.all(16),
      child: Obx(() {
        final taskList = controller.pendingTask.value.result ?? [];

        if (controller.isLoadingPendingTask.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (taskList.isEmpty) {
          return Center(
            child: CustomText(
              text: AppStrings.noPendingTasks.tr,
              color: AppColors.dark200,
              fontWeight: FontWeight.w400,
              fontSize: ResponsiveHelper.fontSize(16),
            ),
          );
        }

        // 🔍 Get today's day name (e.g., "Sunday")
        final String today = DateTime.now().weekday == DateTime.monday
            ? 'Monday'
            : DateTime.now().weekday == DateTime.tuesday
                ? 'Tuesday'
                : DateTime.now().weekday == DateTime.wednesday
                    ? 'Wednesday'
                    : DateTime.now().weekday == DateTime.thursday
                        ? 'Thursday'
                        : DateTime.now().weekday == DateTime.friday
                            ? 'Friday'
                            : DateTime.now().weekday == DateTime.saturday
                                ? 'Saturday'
                                : 'Sunday';

        // 🧍 Assuming all tasks belong to same assignedTo (first one)
        final assignedTo = taskList.first.assignedTo;
        final isOffDay = assignedTo?.offDay == today;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isOffDay) ...[
              Container(
                padding: ResponsiveHelper.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8),),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange),
                    SizedBox(width: ResponsiveHelper.width(8),),
                    Expanded(
                      child: CustomText(
                        text: "${AppStrings.todayIsYourOffDay.tr} ($today).",
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                        fontSize: ResponsiveHelper.fontSize(14),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(16),),
            ],

            /// ================== Task Schedule Section ==================
            if (!isOffDay)
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
            // TaskSection(
            //   isButton: true,
            //   title: AppStrings.taskSchedule.tr,
            //   buttonTitle: AppStrings.confirmTask.tr,
            //   taskCount: taskList.length,
            //   tasks: taskList,
            //   onTap: (String taskId) {
            //     controller.employeePendingTask(
            //         taskId: taskId, status: "ongoing");
            //   },
            // ),
            SizedBox(height: ResponsiveHelper.spacing(16),),
          ],
        );
      }),
    );
  }
}
