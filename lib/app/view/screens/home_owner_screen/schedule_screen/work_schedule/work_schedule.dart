import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/work_schedule_controller/work_schedule_controller.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

import '../../../../../data/model/owner_model/work_schedule/user_task_model.dart';
import '../../../../../utils/app_strings/app_strings.dart';
import 'work_scheduel_user_card.dart';

class WorkSchedule extends StatefulWidget {
  const WorkSchedule({super.key});

  @override
  State<WorkSchedule> createState() => _WorkScheduleState();
}

class _WorkScheduleState extends State<WorkSchedule> {
  final WorkScheduleController controller = Get.find<WorkScheduleController>();

  @override
  void initState() {
    super.initState();
    // Fetch all tasks for all employees
    controller.getAllTasks();
    controller.groupTasksByDayAndEmployee();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CustomLoader(),
          );
        }

        // Access allTasks through the getter and check if empty
        final tasks = controller.allTasks;
        if (tasks.isEmpty) {
          return Center(
            child: CustomText(
              text: AppStrings.noTasks.tr,
              color: AppColors.dark200,
              fontWeight: FontWeight.w400,
              fontSize: ResponsiveHelper.fontSize(16),
            ),
          );
        }

        // Group tasks by day and then by employee
        final groupedTasks = controller.groupTasksByDayAndEmployee();

        return SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: groupedTasks.keys.length,
                itemBuilder: (context, dayIndex) {
                  final dayName = groupedTasks.keys.elementAt(dayIndex);
                  final employeesForDay = groupedTasks[dayName]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ResponsiveHelper.spacing(10),),
                      Row(
                        children: [
                          CustomText(
                            textAlign: TextAlign.start,
                            text: dayName,
                            color: AppColors.dark300,
                            fontWeight: FontWeight.w700,
                            fontSize: ResponsiveHelper.fontSize(18),
                          ),
                        ],
                      ),
                      SizedBox(height:ResponsiveHelper.height(18),),

                      // Display tasks for each employee on this day
                      ...employeesForDay.keys.map((employeeId) {
                        final employeeData = employeesForDay[employeeId]!;

                        final tasks = employeeData['tasks']
                            as List<Result>; // Ensure tasks are Result objects
                        final employee = tasks.first.assignedTo;

                        return WorkScheduleUserCard(
                          name:
                              "${employee?.firstName ?? ""} ${employee?.lastName ?? ""}",
                          // role: employee?.role ?? "",
                          imageUrl:
                              "${ApiUrl.networkUrl}${employee?.profileImage ?? ""}",
                          isOffDay: employeeData['isOffDay'],
                          offDay: employeeData['offDay'],
                          isWorkingDay: employeeData['isWorkingDay'],
                          workingDay: employeeData['workingDay'],
                          tasks: tasks.map((task) {
                            return {
                              'title':
                                  task.taskName ?? AppStrings.noTaskName.tr,
                              'details':
                                  task.taskDetails ?? "No details provided",
                              'time':
                                  '${task.startTimeStr ?? ""} To ${task.endTimeStr ?? ""}',
                            };
                          }).toList(),
                        );
                      }),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
