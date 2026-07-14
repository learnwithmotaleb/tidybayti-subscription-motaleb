import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import '../../../../../../controller/owner_controller/add_employee_controller/add_employee_controller.dart';
import '../../../../../../core/app_routes/app_routes.dart';
import '../../../../../../data/model/owner_model/employee_model.dart';
import '../../../../../../data/service/api_url.dart';
import '../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../utils/app_strings/app_strings.dart';
import '../../../../../components/custom_button/custom_button.dart';
import '../../../../../components/custom_loader/custom_loader.dart';
import '../../../../../components/custom_menu_appbar/custom_menu_appbar.dart';
import '../../../../../components/custom_netwrok_image/custom_network_image.dart';
import '../../../../../components/custom_text/custom_text.dart';

class EmployeeListScreen extends StatefulWidget {
  final String? selectedEmployeeId;
  const EmployeeListScreen({super.key, this.selectedEmployeeId});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final AddEmployeeController employeeController =
          Get.find<AddEmployeeController>();
      employeeController.getEmployee();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AddEmployeeController employeeController =
        Get.find<AddEmployeeController>();
    // In the future, replace this with API data

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: SafeArea(
          child: Container(
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
            child: Column(
              children: [
                CustomMenuAppbar(
                  title: AppStrings.employeeList.tr,
                  onBack: () => Get.back(),
                ),
                Expanded(
                  child: Obx(() {
                    final employees =
                        employeeController.employeeData.value.result;
                    if (employeeController.rxRequestStatus.value ==
                        Status.loading) {
                      return const Center(child: CustomLoader());
                    }
                    if (employees == null || employees.isEmpty) {
                      return Center(
                        child: CustomText(
                          text: AppStrings.noEmployeesFound.tr,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.dark400,
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: ResponsiveHelper.all(16),
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        final data = employees[index];
                        return EmployeeCard(
                          employee: data,
                          isSelected: data.id == widget.selectedEmployeeId,
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

class EmployeeCard extends StatefulWidget {
  final Result employee;
  final bool isSelected;
  const EmployeeCard(
      {super.key, required this.employee, required this.isSelected});

  @override
  State<EmployeeCard> createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.employeeCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12))),
      margin: ResponsiveHelper.symmetric(vertical: 8),
      child: Padding(
        padding: ResponsiveHelper.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: ClipOval(
                    child: CustomNetworkImage(
                      imageUrl:
                          "${ApiUrl.networkUrl}${widget.employee.profileImage ?? ""}",
                      height: ResponsiveHelper.iconSize(56),
                      width: ResponsiveHelper.iconSize(56),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveHelper.spacing(16),),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: widget.employee.name ??
                            "${widget.employee.firstName ?? ''} ${widget.employee.lastName ?? ''}",
                        fontSize: ResponsiveHelper.fontSize(16),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      CustomText(
                          text:
                              "${AppStrings.designation.tr}: ${widget.employee.designation ?? 'N/A'}",
                          color: Colors.grey),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    Get.toNamed(AppRoutes.employeeDetails,
                        arguments: [widget.employee.id ?? ""]);
                  },
                ),
              ],
            ),

            // ✅ FIXED: Corrected button logic
            CustomButton(
              onTap: widget.isSelected
                  ? () {} // Disabled but still tappable (no action)
                  : () {
                      // Return selected employee data
                      Get.back(result: {
                        "id": widget.employee.id ?? "",
                        "name":
                            "${widget.employee.firstName ?? ''} ${widget.employee.lastName ?? ''}"
                                .trim(),
                      });
                    },
              height: 50.h,
              width: 230.w,
              // ✅ Change colors based on selection state
              fillColor: widget.isSelected
                  ? AppColors.blue100 // Light blue when selected
                  : AppColors.blue900, // Dark blue when not selected
              textColor: widget.isSelected
                  ? AppColors.blue900 // Dark text when selected
                  : Colors.white, // White text when not selected
              title: widget.isSelected
                  ? AppStrings.selected.tr
                  : AppStrings.selectEmployee.tr,
            ),
          ],
        ),
      ),
    );
  }
}
