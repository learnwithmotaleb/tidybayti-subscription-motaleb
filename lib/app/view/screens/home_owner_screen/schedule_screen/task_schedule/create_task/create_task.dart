// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_text_field/custom_text_field.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/schedule_screen/task_schedule/create_task/controller/create_task_controller.dart';
import '../../../../../../utils/app_strings/app_strings.dart';
import '../../../../../components/custom_menu_appbar/custom_menu_appbar.dart';
import '../employ_list/employee_list_screen.dart';
import 'models/recurrence_data.dart';
import 'widgets/recurrence_dialog.dart';
import 'widgets/select_room_dialog/select_room_dialog.dart';
import 'widgets/select_task_shit.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final CreateTaskController controller = Get.find<CreateTaskController>();

  List<String> _selectedUsers = [];
  List<String> _selectedRooms = [];

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      final roomId = args['roomId'] ?? '';
      final roomName = args['roomName'] ?? '';
      // if (roomName.isNotEmpty && roomId.isNotEmpty) {
      //
      //
      //   setState(() {
      //     _selectedRooms = [roomName];
      //
      //   });
      //
      //   // ✅ Initialize with the room from previous screen
      //   controller.selectedRoomIdList.value = [roomId];
      //   controller.selectedRoomId.value = roomId;
      //   controller.selectedRoomName.value = roomName;
      //
      //   print('✅ Room from previous screen: $roomName (ID: $roomId)');
      // }

      if (roomName.isNotEmpty && roomId.isNotEmpty) {

        controller.refreshRoomDetails = true;
        controller.roomIdForRefresh = roomId;

        setState(() {
          _selectedRooms = [roomName];
        });

        controller.selectedRoomIdList.value = [roomId];
        controller.selectedRoomId.value = roomId;
        controller.selectedRoomName.value = roomName;
      }



    }
  }

  @override
  Widget build(BuildContext context) {
    String formatTime12Hour(TimeOfDay time) {
      final hour =
          time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod; // convert 0 => 12
      final minute = time.minute.toString().padLeft(2, '0'); // always 2 digits
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      return '$hour:$minute $period';
    }

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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ///app bar===================
                  CustomMenuAppbar(
                    title: AppStrings.createTask.tr,
                    onBack: () {
                      Get.back();
                    },
                  ),
                  Padding(
                    padding:
                        ResponsiveHelper.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [

                        ///task title name -=====================================
                        GestureDetector(
                          onTap: () async {
                            final result = await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => SelectTaskShit(
                                initiallySelected:
                                    controller.taskTitleController.text,
                                initialRecurrence:
                                    controller.recurrenceController.text,
                              ),
                            );

                            if (result != null &&
                                result is Map<String, String>) {
                              final title = result['title'] ?? '';
                              final recurrence = result['recurrence'] ?? '';
                              final rrule = result['rrule'] ?? '';

                              print('🎯 Received from preset:');
                              print('   Title: $title');
                              print('   Recurrence: $recurrence');
                              print('   RRule: $rrule');

                              // Set the task title
                              controller.taskTitleController.text = title;

                              // Check if this is a preset task with rrule
                              if (rrule.isNotEmpty) {
                                // Store the rrule for API call
                                controller.presetRrule.value = rrule;

                                // Display the recurrence text in the UI
                                controller.recurrenceController.text =
                                    recurrence.isNotEmpty
                                        ? recurrence
                                        : 'Custom Recurrence';

                                print(
                                    '✅ Preset task detected - RRule stored: $rrule');
                              } else {
                                // Clear preset rrule
                                controller.presetRrule.value = '';

                                // Set recurrence for non-preset tasks
                                if (recurrence.isNotEmpty) {
                                  controller.recurrenceController.text =
                                      recurrence;

                                  // Try to map to RecurrenceData for standard recurrences
                                  controller
                                      .setRecurrenceFromPreset(recurrence);
                                } else {
                                  // Default to one-time
                                  controller.recurrenceController.text =
                                      AppStrings.oneTime.tr;
                                  controller.customRecurrenceData.value =
                                      const RecurrenceData.oneTime();
                                }
                              }

                              // Update UI
                              setState(() {});
                            }
                          },
                          ///title name======================================
                          child: Container(
                            padding: ResponsiveHelper.symmetric(
                                vertical: 15, horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
                              border: Border.all(color: AppColors.taskColor),
                              color: AppColors.taskColor,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    controller.taskTitleController.text.isEmpty
                                        ? AppStrings.taskTitle.tr
                                        : controller.taskTitleController.text,
                                    style: TextStyle(
                                        fontSize: ResponsiveHelper.fontSize(24),
                                        color: AppColors.black),
                                  ),
                                ),
                                const Icon(Icons.open_in_new_rounded,
                                    color: AppColors.black),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height:ResponsiveHelper.height(12)),
                        /// assign to employee========================Replacing CustomTextField with GestureDetector + Container
                        GestureDetector(
                          onTap: () async {
                            final selectedResult =
                                await Get.to(() => EmployeeListScreen(
                                      selectedEmployeeId: controller
                                          .selectedEmployeeId
                                          .value, // Pass current selection
                                    ));
                            // If users are selected, update the state
                            if (selectedResult != null &&
                                selectedResult is Map) {
                              setState(() {
                                _selectedUsers = [selectedResult['name']];
                              });
                              controller.selectedEmployeeId.value =
                                  selectedResult['id'];
                              print(
                                  "Selected Employee ID: ${controller.selectedEmployeeId.value}");
                            }
                          },
                          child:
                          Container(
                          //  height: ResponsiveHelper.height(24), // ✅ SAME HEIGHT
                            padding: ResponsiveHelper.symmetric(
                                vertical: 15, horizontal: 16), // ✅ SAME PADDING
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r), // ✅ SAME RADIUS
                              border: Border.all(color: AppColors.taskColor),
                              color: AppColors.taskColor,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    _selectedUsers.isEmpty
                                        ? AppStrings.assignedTo.tr
                                        : _selectedUsers.join(", "),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.dark300,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 24.sp,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 18,
                                  color: AppColors.black,
                                ),
                              ],
                            ),
                          ),

                        ),
                        SizedBox(height: ResponsiveHelper.spacing(12)),
                        ///select room====================================
                        GestureDetector(
                          onTap: () async {
                            final savedHouseId = await _getSavedHouseId();
                            if (savedHouseId == null || savedHouseId.isEmpty) {
                              _showHouseSelectionSnackbar();
                              return;
                            }

                            final selectedRoomResult = await showDialog(
                              context: context,
                              builder: (_) => SelectRoomDialog(
                                preSelectedRoomIds:
                                    controller.selectedRoomIdList.toList(),
                                preSelectedRoomNames: _selectedRooms,
                              ),
                            );

                            if (selectedRoomResult != null &&
                                selectedRoomResult is Map<String, dynamic> &&
                                selectedRoomResult.containsKey("RoomNames")) {
                              setState(() {
                                _selectedRooms = List<String>.from(
                                    selectedRoomResult["RoomNames"]);
                              });

                              controller.selectedRoomIdList.value =
                                  List<String>.from(
                                      selectedRoomResult["RoomIds"]);

                              print('✅ Selected rooms: $_selectedRooms');
                              print(
                                  '✅ Selected room IDs: ${controller.selectedRoomIdList}');
                            }
                          },
                          child: Container(
                            padding: ResponsiveHelper.symmetric(
                                vertical: 15, horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
                              border: Border.all(color: AppColors.taskColor),
                              color: AppColors.taskColor,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _selectedRooms.isEmpty
                                        ? AppStrings.selectRoom.tr
                                        : _selectedRooms.join(", "),
                                    style: TextStyle(
                                      color: AppColors.dark300,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 24.sp,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.open_in_new_rounded,
                                    color: AppColors.black),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(12)),
                        ///select date======================
                        CustomTextField(
                          fieldBorderColor: AppColors.taskColor,
                          fillColor: AppColors.taskColor,
                          hintText: AppStrings.selectDate.tr,
                          suffixIcon: const Icon(Icons.calendar_month),
                          textEditingController: controller.dateController,
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                return Directionality(
                                  textDirection: TextDirection
                                      .ltr, // 👈 Forces LTR text direction
                                  child: child!,
                                );
                              },
                            );
                            // Ternary operator for date assignment
                            pickedDate != null
                                ? controller.dateController.text =
                                    intl.DateFormat('MM/dd/yyyy')
                                        .format(pickedDate)
                                : null;
                          },
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(12)),
                        ///task start time=========================
                        CustomTextField(
                          fieldBorderColor: AppColors.taskColor,
                          fillColor: AppColors.taskColor,
                          hintText: AppStrings.taskStartTime.tr,
                          suffixIcon: const Icon(Icons.watch_later_outlined),
                          textEditingController: controller.timeController,
                          readOnly: true,
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (BuildContext context, Widget? child) {
                                // Force the picker to use 12-hour format
                                return MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(alwaysUse24HourFormat: false),
                                  child: child!,
                                );
                              },
                            );
                            // Ternary operator for time assignment

                            if (pickedTime != null) {
                              controller.timeController.text =
                                  formatTime12Hour(pickedTime);
                            }
                          },
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(12)),
                        ///task end time============================
                        CustomTextField(
                          fieldBorderColor: AppColors.taskColor,
                          fillColor: AppColors.taskColor,
                          hintText: AppStrings.taskEndTime.tr,
                          suffixIcon: const Icon(Icons.watch_later_outlined),
                          textEditingController: controller.endTimeController,
                          readOnly: true,
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (BuildContext context, Widget? child) {
                                // Force the picker to use 12-hour format
                                return MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(alwaysUse24HourFormat: false),
                                  child: child!,
                                );
                              },
                            );
                            // Ternary operator for time assignment
                            // String formatTime12Hour(TimeOfDay time) {
                            //   final hour = time.hourOfPeriod == 0
                            //       ? 12
                            //       : time.hourOfPeriod; // convert 0 => 12
                            //   final minute = time.minute
                            //       .toString()
                            //       .padLeft(2, '0'); // always 2 digits
                            //   final period =
                            //       time.period == DayPeriod.am ? 'AM' : 'PM';
                            //   return '$hour:$minute $period';
                            // }

                            if (pickedTime != null) {
                              controller.endTimeController.text =
                                  formatTime12Hour(pickedTime);
                            }
                          },
                        ),

                        SizedBox(height: ResponsiveHelper.spacing(12)),
                        ///one time or re ==============
                        CustomTextField(
                          fieldBorderColor: AppColors.news,
                          fillColor: AppColors.news,
                          hintText: AppStrings.recurrence.tr,
                          readOnly: true,
                          textEditingController:
                              controller.recurrenceController,
                          suffixIcon: const Icon(Icons.open_in_new_rounded),
                          onTap: () async {
                            _showRecurrenceDialog(
                              context,
                              controller.recurrenceController,
                            );
                            print(controller.recurrenceController.text);
                          },
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(12)),
                        ///task details=================
                        CustomTextField(
                            maxLines: 5,
                            fieldBorderColor: AppColors.news,
                            fillColor: AppColors.news,
                            hintText: AppStrings.taskDetails.tr,
                            textEditingController:
                                controller.taskDetailsController),
                        SizedBox(height: ResponsiveHelper.spacing(12)),
                        ///additional message=====================================
                        CustomTextField(
                            maxLines: 5,
                            textInputAction: TextInputAction.done,
                            fieldBorderColor: AppColors.news,
                            fillColor: AppColors.news,
                            hintText: AppStrings.additionalMessage.tr,
                            textEditingController:
                                controller.additionalController),
                        SizedBox(height: ResponsiveHelper.spacing(12)),

                        ///button=================================
                        // CustomButton(
                        //   fillColor: Colors.white,
                        //   onTap: () {
                        //     controller.addTask();
                        //   },
                        //   title: AppStrings.assignTask.tr,
                        // )


                        Obx(() => Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomButton(
                              fillColor: Colors.white,
                              onTap: () {
                                if (controller.isTaskLoading.value) return;
                                controller.addTask();
                              },
                              title: controller.isTaskLoading.value ? "  " : AppStrings.assignTask.tr,
                            ),
                            if (controller.isTaskLoading.value)
                              const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 4,
                                  color: AppColors.primary,
                                ),
                              ),
                          ],
                        )),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _getSavedHouseId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedHouseId');
  }

  void _showHouseSelectionSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppStrings.pleaseSelectHouse.tr,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showRecurrenceDialog(
    BuildContext context,
    TextEditingController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return RecurrenceDialog(controller: controller);
      },
    );
  }
}
