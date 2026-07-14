import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:tidybayte/app/controller/owner_controller/task_controller/task_controller.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/GenerelError/general_error.dart';
import 'package:tidybayte/app/global/helper/global_alart/global_alart.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';

import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_room_card/custom_room_card.dart';
import 'package:tidybayte/app/view/components/no_internet_screen/no_internet_screen.dart';

class PendingTask extends StatefulWidget {
  const PendingTask({super.key});

  @override
  State<PendingTask> createState() => _PendingTaskState();
}

class _PendingTaskState extends State<PendingTask> {
  final TaskController taskController = Get.find<TaskController>();

  @override
  void initState() {
    taskController.getTaskData(apiUrl: ApiUrl.getPendingTask);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xCCE8F3FA),
                Color(0xFFB5D8EE),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                ///===============================  AppBar ========================
                CustomMenuAppbar(
                  title: AppStrings.pendingTask.tr,
                  onBack: () => Get.back(),
                ),

                ///===============================  Task List ========================
                Expanded(
                  child: Obx(() {
                    switch (taskController.rxRequestStatus.value) {
                      case Status.loading:
                        return const CustomLoader();

                      case Status.internetError:
                        return NoInternetScreen(
                          onTap: () => taskController.getTaskData(
                            apiUrl: ApiUrl.getPendingTask,
                          ),
                        );

                      case Status.error:
                        return GeneralErrorScreen(
                          onTap: () => taskController.getTaskData(
                            apiUrl: ApiUrl.getPendingTask,
                          ),
                        );

                      case Status.completed:
                        if (taskController.taskList.isEmpty) {
                          return Center(
                            child: Text(
                              AppStrings.noData.tr,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.fontSize(18),
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: ResponsiveHelper.symmetric(horizontal: 20),
                          itemCount: taskController.taskList.length,
                          itemBuilder: (context, index) {
                            final task = taskController.taskList[index];

                            return CustomRoomCard(
                              taskName: task.taskName ?? "",
                              assignedTo:
                                  "${task.assignedTo?.firstName ?? ""} ${task.assignedTo?.lastName ?? ""}",
                              time:
                                  "${task.startTimeStr ?? ""} To ${task.endTimeStr ?? ""}",
                              onInfoPressed: () {
                                GlobalAlert.singleTaskDialog(
                                  context,
                                  task.taskName ?? "",
                                  "${task.assignedTo?.firstName ?? ""} ${task.assignedTo?.lastName ?? ""}",
                                  task.recurrence ?? "",
                                  task.startDateStr ?? "",
                                  task.startTimeStr ?? "",
                                  task.endDateStr ?? "",
                                  task.endTimeStr ?? "",
                                );
                              },
                              onDeletePressed: () {
                                GlobalAlert.showDeleteDialog(
                                  context,
                                  () async {
                                    await taskController.removeTask(
                                      taskId: task.id ?? "",
                                    );
                                    taskController.getTaskData(
                                      apiUrl: ApiUrl.getPendingTask,
                                    );
                                  },
                                  AppStrings.removeYourPendingTask.tr,
                                );
                              },
                            );
                          },
                        );
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
