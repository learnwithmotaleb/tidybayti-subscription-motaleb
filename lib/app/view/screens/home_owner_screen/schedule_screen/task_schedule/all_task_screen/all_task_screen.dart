import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/task_controller/task_controller.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/global_alart/global_alart.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_room_card/custom_room_card.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'toggle_widget.dart';

class AllTaskScreen extends StatefulWidget {
  const AllTaskScreen({super.key});

  @override
  State<AllTaskScreen> createState() => _AllTaskScreenState();
}

class _AllTaskScreenState extends State<AllTaskScreen> {
  final TaskController controller = Get.find<TaskController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectedDayIndex.value = 0;
      controller.getTaskData(apiUrl: ApiUrl.getOneTimeTask);
    });
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
                ///=============================== App Bar ========================
                CustomMenuAppbar(
                  title: AppStrings.allTasks.tr,
                  onBack: () => Get.back(),
                ),

                SizedBox(height: ResponsiveHelper.spacing(16)), // ✅ was: 16.h

                /// Toggle Widget
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.padding(24), // ✅ already using ResponsiveHelper
                  ),
                  child: const ToggleWidget(),
                ),

                SizedBox(height: ResponsiveHelper.spacing(16)), // ✅ was: 16.h
                const Divider(),
                SizedBox(height: ResponsiveHelper.spacing(10)), // ✅ was: 10.h

                ///=============================== Task List ========================
                Expanded(
                  child: Obx(() {
                    if (controller.rxRequestStatus.value == Status.loading) {
                      return const CustomLoader();
                    }
                    if (controller.rxRequestStatus.value ==
                        Status.internetError) {
                      return Center(
                        child: CustomText(
                          text: AppStrings.noInternet.tr,
                          fontSize: ResponsiveHelper.fontSize(16), // ✅
                        ),
                      );
                    }
                    if (controller.rxRequestStatus.value == Status.error) {
                      return Center(
                        child: CustomText(
                          text: AppStrings.somethingWentWrong.tr,
                          fontSize: ResponsiveHelper.fontSize(16), // ✅
                        ),
                      );
                    }

                    if (controller.taskList.isEmpty) {
                      return Center(
                        child: CustomText(
                          text: AppStrings.noTasks.tr,
                          fontSize: ResponsiveHelper.fontSize(18), // ✅
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.padding(20), // ✅ was: 20.h (note: was incorrectly using .h)
                      ),
                      itemCount: controller.taskList.length,
                      itemBuilder: (context, index) {
                        final task = controller.taskList[index];

                        return Column(
                          children: [
                            CustomRoomCard(
                              taskName: task.taskName ?? "",
                              assignedTo:
                              "${task.assignedTo?.firstName ?? ""} ${task.assignedTo?.lastName ?? ""}",
                              time:
                              '${task.startTimeStr ?? ""} To ${task.endTimeStr ?? ""}',
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
                              onDeletePressed: () async {
                                final bool? confirmed =
                                await GlobalAlert.showDeleteDialog(
                                  context,
                                      () async {
                                    await controller.removeTask(
                                        taskId: task.id ?? "");

                                    final selectedIndex =
                                        controller.selectedDayIndex.value;

                                    if (selectedIndex == 0) {
                                      await controller.getTaskData(
                                          apiUrl: ApiUrl.getOneTimeTask);
                                    } else if (selectedIndex == 1) {
                                      await controller.getTaskData(
                                          apiUrl: ApiUrl.getRecurrenceTask);
                                    }
                                  },
                                  AppStrings.areYouSure.tr,
                                );

                                if (confirmed ?? false) {
                                  debugPrint(
                                      "✅ Task Deleted and API Refreshed");
                                }
                              },
                            ),
                            SizedBox(height: ResponsiveHelper.spacing(10)), // ✅ was: 10.h
                          ],
                        );
                      },
                    );
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