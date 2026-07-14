import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tidybayte/app/controller/owner_controller/add_employee_controller/add_employee_controller.dart';
import 'package:tidybayte/app/controller/owner_controller/grocery_controller/grocery_controller.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart' show ResponsiveHelper;
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/components/custom_text_field/custom_text_field.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/schedule_screen/task_schedule/employ_list/employee_list_screen.dart';
import '../../../../../../../data/service/api_url.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../select_grocery_dialog/select_grocery_shit.dart';

class AddGroceryTask extends StatefulWidget {
  const AddGroceryTask({super.key});

  @override
  State<AddGroceryTask> createState() => _AddGroceryTaskState();
}

class _AddGroceryTaskState extends State<AddGroceryTask> {
  final GroceryController controller = Get.find<GroceryController>();

  String selectedEmployee = '';
  List<String> _suggestedGrocery = [];

  final AddEmployeeController employeeController =
  Get.find<AddEmployeeController>();

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
                /// ================= Header =================
                CustomMenuAppbar(
                  title: AppStrings.addGrocery.tr,
                  onBack: () => Get.back(),
                ),

                /// ================= Form =================
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.padding(30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: ResponsiveHelper.spacing(12)),

                        /// ================= Grocery Picker =================
                        GestureDetector(
                          onTap: () async {
                            final result = await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => SelectGroceryShit(
                                initiallySelected: _suggestedGrocery,
                              ),
                            );

                            if (result != null &&
                                result is Map<String, dynamic> &&
                                result.containsKey('SelectedItems')) {
                              setState(() {
                                _suggestedGrocery = List<String>.from(
                                  result['SelectedItems'] ?? [],
                                );
                              });
                              controller.groceryItems
                                  .assignAll(_suggestedGrocery);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveHelper.spacing(15),
                              horizontal: ResponsiveHelper.padding(16),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(8),
                              ),
                              border: Border.all(color: AppColors.taskColor),
                              color: AppColors.taskColor,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _suggestedGrocery.isEmpty
                                        ? AppStrings.addGroceryItem.tr
                                        : _suggestedGrocery.join(", "),
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w300,
                                      fontSize: ResponsiveHelper.fontSize(24),
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.open_in_new_rounded,
                                  color: AppColors.black,
                                  size: ResponsiveHelper.iconSize(22),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: ResponsiveHelper.spacing(16)),

                        /// ================= Employee Picker =================
                        InkWell(
                          onTap: () async {
                            final result =
                            await Get.to(() => EmployeeListScreen(
                              selectedEmployeeId: controller.assignedId,
                            ));
                            if (result != null &&
                                result is Map<String, String>) {
                              setState(() {
                                selectedEmployee = result["name"] ?? "";
                                controller.assignedId = result["id"] ?? "";
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveHelper.padding(16),
                              vertical: ResponsiveHelper.spacing(14),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    text: controller.assignedId.isEmpty
                                        ? AppStrings.selectEmployee.tr
                                        : selectedEmployee,
                                    fontSize: ResponsiveHelper.fontSize(14),
                                    color: AppColors.dark300,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: ResponsiveHelper.iconSize(18),
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: ResponsiveHelper.spacing(16)),

                        /// ================= Date =================
                        CustomTextField(
                          hintText: AppStrings.taskDate.tr,
                          suffixIcon: Icon(
                            Icons.calendar_month_outlined,
                            size: ResponsiveHelper.iconSize(22),
                          ),
                          textEditingController: controller.startDateController,
                          readOnly: true,
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              controller.startDateController.text =
                                  intl.DateFormat('MM/dd/yyyy')
                                      .format(pickedDate);
                            }
                          },
                        ),

                        SizedBox(height: ResponsiveHelper.spacing(16)),

                        /// ================= Start Time =================
                        CustomTextField(
                          hintText: AppStrings.startTime.tr,
                          suffixIcon: Icon(
                            Icons.watch_later_outlined,
                            size: ResponsiveHelper.iconSize(22),
                          ),
                          textEditingController: controller.startTimeController,
                          readOnly: true,
                          onTap: () async {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (pickedTime != null) {
                              final now = DateTime.now();
                              final selected = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                              controller.startTimeController.text =
                                  intl.DateFormat('hh:mm a').format(selected);
                            }
                          },
                        ),

                        SizedBox(height: ResponsiveHelper.spacing(16)),

                        /// ================= End Time =================
                        CustomTextField(
                          hintText: AppStrings.endTime.tr,
                          suffixIcon: Icon(
                            Icons.watch_later_outlined,
                            size: ResponsiveHelper.iconSize(22),
                          ),
                          textEditingController: controller.endTimeController,
                          readOnly: true,
                          onTap: () async {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (pickedTime != null) {
                              final now = DateTime.now();
                              final selected = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                              controller.endTimeController.text =
                                  intl.DateFormat('hh:mm a').format(selected);
                            }
                          },
                        ),

                        SizedBox(height: ResponsiveHelper.spacing(25)),

                        /// ================= Submit Button =================
                        Obx(() {
                          return controller.isAddGroceryLoading.value
                              ? const CustomLoader()
                              : CustomButton(
                            onTap: controller.addGrocery,
                            fillColor: Colors.white,
                            title: AppStrings.confirm.tr,
                          );
                        }),

                        SizedBox(height: ResponsiveHelper.spacing(30)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}