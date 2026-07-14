import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/employee_controller/employee_grocery_controller.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import '../../../../../utils/app_const/app_const.dart';
import 'grocery_text_section.dart';

class GroceryPendingScreen extends StatefulWidget {
  const GroceryPendingScreen({super.key});

  @override
  State<GroceryPendingScreen> createState() => _AdditionalPendingTaskState();
}

class _AdditionalPendingTaskState extends State<GroceryPendingScreen> {
  final EmployeeGroceryController controller =
      Get.find<EmployeeGroceryController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getPending(); // Delayed until after first build
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveHelper.all(16),
      child: Obx(() {
        final taskList = controller.pendingTask;

        switch (controller.rxRequestStatus.value) {
          case Status.loading:
            return const Center(child: CircularProgressIndicator());

          case Status.error:
            return Center(
              child: CustomText(
                text: AppStrings.groceryLoadError.tr,
                color: AppColors.dark200,
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveHelper.fontSize(16),
              ),
            );

          case Status.completed:
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

            return Column(
              children: [
                GroceryTextSection(
                  isButton: true,
                  title: AppStrings.taskSchedule.tr,
                  buttonTitle: AppStrings.completeTask.tr,
                  taskCount: taskList.length,
                  tasks: taskList,
                  onTap: (String taskId) {
                    controller.employeePendingTask(
                        groceryId: taskId, status: "completed");
                  },
                ),
                // GroceryTextSection(
                //   isButton: true,
                //   title: AppStrings.taskSchedule.tr,
                //   taskCount: taskList.length,
                //   tasks: taskList,
                //   onTap: (String groceryId) {
                //     controller.employeePendingTask(
                //       groceryId: groceryId,
                //       status: "ongoing",
                //     );
                //   },
                // ),
                SizedBox(height: ResponsiveHelper.spacing(16),),
              ],
            );
          case Status.internetError:
            return Center(
              child: CustomText(
                text: AppStrings.noInternet.tr,
                color: AppColors.dark200,
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveHelper.fontSize(16),
              ),
            );
        }
      }),
    );
  }
}
