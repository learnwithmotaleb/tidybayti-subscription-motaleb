import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/employee_controller/employee_home_controller.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import '../../../../../../data/model/owner_model/work_schedule/user_task_model.dart';
import '../../../../../components/custom_task_details_dialoge/custom_task_details_dialoge.dart';

class TaskSection extends StatefulWidget {
  final String title;
  final String? buttonTitle;
  final int taskCount;
  final bool? isButton;
  final List<Result> tasks;
  final Function(String taskId)? onTap;

  const TaskSection({
    super.key,
    required this.title,
    required this.taskCount,
    required this.tasks,
    this.onTap,
    this.isButton,
    this.buttonTitle,
  });

  @override
  State<TaskSection> createState() => _TaskSectionState();
}

class _TaskSectionState extends State<TaskSection> {
  late List<bool> isTabList;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    isTabList = List<bool>.filled(widget.taskCount, false);
  }

  final EmployeeHomeController controller = Get.find<EmployeeHomeController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.tasks.asMap().entries.map((entry) {
        Result task = entry.value;
        return Container(
          margin: ResponsiveHelper.all(10),
          padding: ResponsiveHelper.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10),),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// =================== Task Title & Info Icon ===================
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.taskName ?? AppStrings.noTaskName.tr,
                      style: TextStyle(
                        fontSize:ResponsiveHelper.fontSize(18),
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showTaskDetailsDialog(context, task);
                    },
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.grey,
                      size: ResponsiveHelper.iconSize(24),
                    ),
                  ),
                ],
              ),

              SizedBox(height:ResponsiveHelper.height(8),),
              Text(
                '${AppStrings.assignedTo.tr} - ${task.assignedTo?.firstName ?? ""} ${task.assignedTo?.lastName ?? ""}',
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(14),
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: ResponsiveHelper.spacing(8),),

              /// =================== Task Date & Confirm Button ===================
              Row(
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    color: Colors.grey,
                    size: ResponsiveHelper.iconSize(18),
                  ),
                  SizedBox(width: ResponsiveHelper.spacing(5),),
                  Text(
                    task.startDateStr ?? "No Date",
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(14),
                      color: Colors.grey[700],
                    ),
                  ),
                  const Spacer(),
                  widget.isButton == true
                      ? ElevatedButton(
                          onPressed: () {
                            if (widget.onTap != null &&
                                !controller.isPendingTask.value) {
                              widget.onTap!(task.id ??
                                  ""); // ✅ Call the method with taskId
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: controller.isPendingTask.value &&
                                    controller.pendingTaskId.value == task.id
                                ? Colors.grey // ✅ Show grey when loading
                                : Colors.grey[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            padding: ResponsiveHelper.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                          child: controller.isPendingTask.value &&
                                  controller.pendingTaskId.value == task.id
                              ? SizedBox(
                                  // ✅ Show Loader While Task is Being Updated
                                  width: ResponsiveHelper.iconSize(20),
                                  height: ResponsiveHelper.iconSize(20),
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  widget.buttonTitle ?? '',
                                  style: TextStyle(
                                      fontSize: ResponsiveHelper.fontSize(14), color: Colors.white),
                                ),
                        )
                      : const SizedBox()
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _showTaskDetailsDialog(BuildContext context, Result task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomTaskDetailsDialoge(
          task: task.taskName ?? AppStrings.noTaskName.tr,
          assignTo:
              "${task.assignedTo?.firstName ?? ""} ${task.assignedTo?.lastName ?? ""}",
          date: task.startDateStr ?? "",
          time: "${task.startTimeStr ?? ''} - ${task.endTimeStr ?? ''}",
          taskDetails: task.taskDetails ?? '',
          additionalMessage: task.additionalMessage ?? '',
          house: task.room?.house?.name ?? '',
          room: task.room?.name ?? '',
        );
      },
    );
  }
}
