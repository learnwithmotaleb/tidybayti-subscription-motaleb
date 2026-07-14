import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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

import '../../../../../../controller/owner_controller/task_controller/task_controller.dart';

class OngoingTask extends StatefulWidget {
  const OngoingTask({super.key});

  @override
  State<OngoingTask> createState() => _OngoingTaskState();
}

class _OngoingTaskState extends State<OngoingTask> {
  final TaskController taskController = Get.find<TaskController>();

  @override
  void initState() {
    taskController.getTaskData(apiUrl: ApiUrl.getOngoing);
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
              colors: [Color(0xCCE8F3FA), Color(0xFFB5D8EE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                ///=============================== Title ========================
                CustomMenuAppbar(
                  title: AppStrings.ongoingTask.tr,
                  onBack: () => Get.back(),
                ),

                ///=============================== Task List ========================
                Expanded(
                  child: Obx(() {
                    switch (taskController.rxRequestStatus.value) {
                      case Status.loading:
                        return const CustomLoader();

                      case Status.internetError:
                        return NoInternetScreen(
                          onTap: () {
                            taskController.getTaskData(
                                apiUrl: ApiUrl.getOngoing);
                          },
                        );

                      case Status.error:
                        return GeneralErrorScreen(
                          onTap: () {
                            taskController.getTaskData(
                                apiUrl: ApiUrl.getOngoing);
                          },
                        );

                      case Status.completed:
                        if (taskController.taskList.isEmpty) {
                          return Center(
                            child: Text(
                              AppStrings.noTasks.tr,
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
                            final data = taskController.taskList[index];

                            return Padding(
                              padding: EdgeInsets.only(bottom: ResponsiveHelper.height(10),),
                              child: CustomRoomCard(
                                taskName:
                                    data.taskName ?? AppStrings.noTaskName.tr,
                                assignedTo:
                                    "${data.assignedTo?.firstName ?? ""} ${data.assignedTo?.lastName ?? ""}",
                                time:
                                    '${data.startTimeStr ?? ""} To ${data.endTimeStr ?? ""}',
                                onInfoPressed: () {
                                  GlobalAlert.singleTaskDialog(
                                    context,
                                    data.taskName ?? AppStrings.noTaskName.tr,
                                    "${data.assignedTo?.firstName ?? ""} ${data.assignedTo?.lastName ?? ""}",
                                    data.recurrence ?? "",
                                    data.startDateStr ?? "",
                                    data.startTimeStr ?? "",
                                    data.endDateStr ?? "",
                                    data.endTimeStr ?? "",
                                  );
                                },
                                onDeletePressed: () async {
                                  bool? isConfirmed =
                                      await GlobalAlert.showDeleteDialog(
                                    context,
                                    () async {
                                      await taskController.removeTask(
                                          taskId: data.id ?? "");

                                      await taskController.getTaskData(
                                          apiUrl: ApiUrl.getOngoing);
                                    },
                                    AppStrings.removeYourOngoingTask.tr,
                                  );

                                  if (isConfirmed ?? false) {
                                    debugPrint("✅ Task Deleted & Refreshed");
                                  }
                                },
                              ),
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
