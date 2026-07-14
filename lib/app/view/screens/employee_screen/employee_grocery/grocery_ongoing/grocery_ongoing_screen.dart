import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/employee_controller/employee_grocery_controller.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/screens/employee_screen/employee_grocery/grocery_pending/grocery_text_section.dart';

class GroceryOngoingScreen extends StatefulWidget {
  const GroceryOngoingScreen({super.key});

  @override
  State<GroceryOngoingScreen> createState() => _AdditionalPendingTaskState();
}

class _AdditionalPendingTaskState extends State<GroceryOngoingScreen> {
  final EmployeeGroceryController controller =
      Get.find<EmployeeGroceryController>();

  @override
  void initState() {
    super.initState();
    // Safe scheduling after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getOngoing();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveHelper.all(16),
      child: Obx(() {
        final taskList = controller.ongoingTask;

        if (controller.isLoading.value) {
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
            SizedBox(height: ResponsiveHelper.spacing(16),),
          ],
        );
      }),
    );
  }
}
