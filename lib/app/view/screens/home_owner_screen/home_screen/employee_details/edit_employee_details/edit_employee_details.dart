// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tidybayte/app/controller/owner_controller/add_employee_controller/add_employee.dart';
import 'package:tidybayte/app/controller/owner_controller/add_employee_controller/add_employee_controller.dart';
import 'package:tidybayte/app/global/helper/GenerelError/general_error.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/components/custom_text_field/custom_text_field.dart';
import 'package:tidybayte/app/view/components/no_internet_screen/no_internet_screen.dart';
import '../../../../../../data/service/api_url.dart';

class EditEmployeeDetails extends StatefulWidget {
  const EditEmployeeDetails({super.key});

  @override
  State<EditEmployeeDetails> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<EditEmployeeDetails> {
  final AddEmployeeController controller = Get.find<AddEmployeeController>();

  late String userId = '';
  late String authId = '';
  late String employeeId = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeEmployeeData();
    });
  }

  void _initializeEmployeeData() async {
    final args = Get.arguments ?? {};
    employeeId = args["employeeId"]?.toString() ?? '';

    if (employeeId.isEmpty) {
      print("❌ No employee ID provided");
      Get.back();
      return;
    }

    print("🔄 Loading employee data for ID: $employeeId");
    controller.clearAllData();

    try {
      await controller.getSingleEmployee(employeeId: employeeId);

      if (controller.rxRequestStatus.value == Status.completed) {
        var employeeData = controller.singleEmployeeData.value;

        userId = employeeData.id ?? '';
        authId = employeeData.authId ?? '';

        controller.firstNameController.text = employeeData.firstName ?? '';
        controller.lastNameController.text = employeeData.lastName ?? '';
        controller.jobTypeController.text = employeeData.jobType ?? '';
        controller.designationController.text = employeeData.designation ?? '';
        controller.addressController.text = employeeData.address ?? '';
        controller.selectedJobType.value = employeeData.jobType ?? '';
        controller.cprNumberController.text = employeeData.cprNumber ?? '';
        controller.cprExpireDateController.text = employeeData.cprExpDate ?? '';
        controller.passportController.text = employeeData.passportNumber ?? '';
        controller.passportExpireDateController.text =
            employeeData.passportExpDate ?? '';
        controller.noteController.text = employeeData.note ?? '';
        controller.phoneNumberController.text = employeeData.phoneNumber ?? '';
        controller.image.value = employeeData.profileImage ?? '';

        String dutyTime = employeeData.dutyTime ?? '';
        if (dutyTime.isNotEmpty && dutyTime.contains('-')) {
          List<String> times = dutyTime.split('-');
          if (times.length == 2) {
            controller.startTimeController.text =
                _formatTo12Hour(times[0].trim());
            controller.endTimeController.text =
                _formatTo12Hour(times[1].trim());
          }
        }

        if (employeeData.breakTimeStart != null &&
            employeeData.breakTimeStart!.isNotEmpty) {
          controller.breakStartTimeController.text =
              _formatTo12Hour(employeeData.breakTimeStart!);
        }

        if (employeeData.breakTimeEnd != null &&
            employeeData.breakTimeEnd!.isNotEmpty) {
          controller.breakEndTimeController.text =
              _formatTo12Hour(employeeData.breakTimeEnd!);
        }

        for (int i = 0; i < controller.selectedWorkingDays.length; i++) {
          controller.selectedWorkingDays[i] = false;
        }

        if (employeeData.workingDay != null &&
            employeeData.workingDay!.isNotEmpty) {
          for (String workingDay in employeeData.workingDay!) {
            int dayIndex = controller.daysOfWeek.indexOf(workingDay);
            if (dayIndex != -1 &&
                dayIndex < controller.selectedWorkingDays.length) {
              controller.selectedWorkingDays[dayIndex] = true;
            }
          }
        }

        controller.selectedOffDayIndex = -1;
        if (employeeData.offDay != null && employeeData.offDay!.isNotEmpty) {
          int offDayIndex =
          controller.daysOfWeek.indexOf(employeeData.offDay!);
          if (offDayIndex != -1) {
            controller.selectedOffDayIndex = offDayIndex;
          }
        }

        print("✅ Employee data loaded successfully:");
        print("UserId: $userId");
        print("AuthId: $authId");
        print("FirstName: ${controller.firstNameController.text}");
        print("WorkingDays: ${controller.selectedWorkingDays}");
        print("OffDayIndex: ${controller.selectedOffDayIndex}");
      }
    } catch (error) {
      print("❌ Error loading employee data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
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
                CustomMenuAppbar(
                  title: AppStrings.editEmployeeDetails.tr,
                  onBack: () {
                    Get.back();
                    controller.clearAllData();
                  },
                ),
                Expanded(
                  child: _buildBody(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.rxRequestStatus.value == Status.loading) {
        return const Center(child: CustomLoader());
      }
      if (controller.rxRequestStatus.value == Status.internetError) {
        return NoInternetScreen(onTap: () => _initializeEmployeeData());
      }
      if (controller.rxRequestStatus.value == Status.error) {
        return GeneralErrorScreen(onTap: () => _initializeEmployeeData());
      }
      if (controller.rxRequestStatus.value == Status.completed) {
        return _buildForm();
      }
      return const Center(child: CustomLoader());
    });
  }

  Widget _buildForm() {
    return ListView(
      padding: EdgeInsets.all(ResponsiveHelper.padding(16.0)),
      children: [
        // Employee Image
        EditEmployeeImage(controller: controller),
        SizedBox(height: ResponsiveHelper.spacing(20)),

        // First Name
        CustomTextField(
          hintText: AppStrings.firstName.tr,
          fillColor: AppColors.employeeCardColor,
          textEditingController: controller.firstNameController,
        ),
        SizedBox(height: ResponsiveHelper.spacing(8)),

        // Last Name
        CustomTextField(
          hintText: AppStrings.lastName.tr,
          fillColor: AppColors.employeeCardColor,
          textEditingController: controller.lastNameController,
        ),
        SizedBox(height: ResponsiveHelper.spacing(8)),

        // Job Type
        JobType(controller: controller),
        SizedBox(height: ResponsiveHelper.spacing(8)),

        CustomTextField(
          hintText: AppStrings.designation.tr,
          fillColor: AppColors.employeeCardColor,
          textEditingController: controller.designationController,
        ),
        SizedBox(height: ResponsiveHelper.spacing(8)),

        CustomTextField(
          hintText: AppStrings.address.tr,
          fillColor: AppColors.employeeCardColor,
          textEditingController: controller.addressController,
        ),
        SizedBox(height: ResponsiveHelper.spacing(8)),

        // CPR Section
        CustomTextField(
          readOnly: true,
          onTap: () {
            controller.isCprOpen.value = !controller.isCprOpen.value;
          },
          suffixIcon: Icon(
            controller.isCprOpen.value
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
          ),
          hintText: AppStrings.cPR.tr,
          fillColor: Colors.white.withOpacity(0.5),
        ),
        SizedBox(height: ResponsiveHelper.spacing(8)),
        CprOption(controller: controller),
        SizedBox(height: ResponsiveHelper.spacing(8)),

        // Passport Section
        CustomTextField(
          readOnly: true,
          onTap: () {
            controller.isPassportOpen.value = !controller.isPassportOpen.value;
          },
          suffixIcon: Icon(
            controller.isPassportOpen.value
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
          ),
          hintText: AppStrings.passport.tr,
          fillColor: AppColors.employeeCardColor,
        ),
        SizedBox(height: ResponsiveHelper.spacing(8)),
        PassportOption(controller: controller),
        SizedBox(height: ResponsiveHelper.spacing(8)),

        // Note
        CustomTextField(
          textEditingController: controller.noteController,
          hintText: AppStrings.note.tr,
          fillColor: AppColors.employeeCardColor,
        ),
        SizedBox(height: ResponsiveHelper.spacing(8)),

        // Phone Number
        CustomTextField(
          textEditingController: controller.phoneNumberController,
          hintText: AppStrings.contactNumber.tr,
          fillColor: AppColors.employeeCardColor,
        ),
        SizedBox(height: ResponsiveHelper.spacing(8)),

        // Duty Time Label
        CustomText(
          textAlign: TextAlign.start,
          text: "${AppStrings.dutyTime.tr} ",
          fontSize: ResponsiveHelper.fontSize(16),
          color: Colors.black,
          bottom: ResponsiveHelper.spacing(8),
          fontWeight: FontWeight.w500,
        ),

        // Start Time & End Time Row
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                textEditingController: controller.startTimeController,
                readOnly: true,
                hintText: AppStrings.startTime.tr,
                fillColor: Colors.white,
                suffixIcon: const Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: false),
                        child: child!,
                      );
                    },
                  );
                  if (pickedTime != null) {
                    controller.startTimeController.text =
                        intl.DateFormat("hh:mm a").format(DateTime(
                            2023, 1, 1, pickedTime.hour, pickedTime.minute));
                  }
                },
              ),
            ),
            SizedBox(width: ResponsiveHelper.spacing(15)),
            Expanded(
              child: CustomTextField(
                textEditingController: controller.endTimeController,
                readOnly: true,
                hintText: AppStrings.endTime.tr,
                fillColor: Colors.white,
                suffixIcon: const Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: false),
                        child: child!,
                      );
                    },
                  );
                  if (pickedTime != null) {
                    controller.endTimeController.text =
                        intl.DateFormat("hh:mm a").format(DateTime(
                            2023, 1, 1, pickedTime.hour, pickedTime.minute));
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.spacing(15)),

        // Break Time Label
        CustomText(
          textAlign: TextAlign.start,
          text: "${AppStrings.breakTimeColon.tr}: ",
          fontSize: ResponsiveHelper.fontSize(16),
          color: Colors.black,
          bottom: ResponsiveHelper.spacing(8),
          fontWeight: FontWeight.w500,
        ),

        // Break Start & End Time Row
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                textEditingController: controller.breakStartTimeController,
                readOnly: true,
                hintText: AppStrings.breakStartTime.tr,
                fillColor: Colors.white,
                suffixIcon: const Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: false),
                        child: child!,
                      );
                    },
                  );
                  if (pickedTime != null) {
                    controller.breakStartTimeController.text =
                        intl.DateFormat("hh:mm a").format(DateTime(
                            2023, 1, 1, pickedTime.hour, pickedTime.minute));
                  }
                },
              ),
            ),
            SizedBox(width: ResponsiveHelper.spacing(15)),
            Expanded(
              child: CustomTextField(
                textEditingController: controller.breakEndTimeController,
                readOnly: true,
                hintText: AppStrings.breakEndTime.tr,
                fillColor: Colors.white,
                suffixIcon: const Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: false),
                        child: child!,
                      );
                    },
                  );
                  if (pickedTime != null) {
                    controller.breakEndTimeController.text =
                        intl.DateFormat("hh:mm a").format(DateTime(
                            2023, 1, 1, pickedTime.hour, pickedTime.minute));
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.spacing(15)),

        // Working Days Section
        Padding(
          padding: EdgeInsets.only(
            bottom: ResponsiveHelper.spacing(16),
            top: ResponsiveHelper.spacing(16),
          ),
          child: CustomText(
            text: AppStrings.selectWorkingDays.tr,
            fontSize: ResponsiveHelper.fontSize(18),
            fontWeight: FontWeight.w600,
          ),
        ),
        _buildDaySelectionGrid(controller.selectedWorkingDays, true),
        SizedBox(height: ResponsiveHelper.spacing(24)),

        // Off Days Section
        CustomText(
          textAlign: TextAlign.start,
          bottom: ResponsiveHelper.spacing(24),
          text: AppStrings.selectOffDays.tr,
          fontWeight: FontWeight.w400,
          fontSize: ResponsiveHelper.fontSize(16),
          color: AppColors.dark400,
        ),
        _buildDaySelectionOfGrid(),
        SizedBox(height: ResponsiveHelper.spacing(24)),

        // Submit Button
        Obx(() => controller.isEditLoading.value
            ? const CustomLoader()
            : CustomButton(
          onTap: () {
            AddEmployee.editEmployee(
              authId: authId,
              userId: userId,
              firstName: controller.firstNameController.text.trim(),
              lastName: controller.lastNameController.text.trim(),
              designation: controller.designationController.text.trim(),
              address: controller.addressController.text.trim(),
              profileImage: controller.profileImage.value,
              phoneNumber: controller.phoneNumberController.text.trim(),
              jobType: controller.selectedJobType.value,
              cprNumber: controller.cprNumberController.text.trim(),
              cprExpDate: controller.cprExpireDateController.text.trim(),
              passportNumber: controller.passportController.text.trim(),
              passportExpDate:
              controller.passportExpireDateController.text.trim(),
              note: controller.noteController.text.trim(),
              dutyTime:
              "${controller.startTimeController.text}-${controller.endTimeController.text}",
              workingDay: controller.getSelectedDays(),
              offDay: controller.getSelectedOffDays(),
              context: context,
              breakTimeStart: controller.breakStartTimeController.text,
              breakTimeEnd: controller.breakEndTimeController.text,
            );
          },
          fillColor: Colors.white,
          title: AppStrings.submit.tr,
        )),
      ],
    );
  }

  String _formatTo12Hour(String time24) {
    try {
      if (time24.isEmpty) return '';
      final format24 = intl.DateFormat("HH:mm");
      final parsedTime = format24.parse(time24);
      final format12 = intl.DateFormat("hh:mm a");
      return format12.format(parsedTime);
    } catch (e) {
      print("Error formatting time: $e");
      return time24;
    }
  }

  Widget _buildDaySelectionGrid(List<bool> selectedDays, bool isWorkingDay) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.daysOfWeek.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: ResponsiveHelper.isTablet ? 4.5 : 5,
        crossAxisSpacing: ResponsiveHelper.spacing(16),
        mainAxisSpacing: ResponsiveHelper.spacing(8),
      ),
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            Checkbox(
              activeColor: AppColors.blue900,
              checkColor: AppColors.light200,
              value: selectedDays[index],
              onChanged: (bool? newValue) {
                setState(() {
                  if (isWorkingDay) {
                    if (controller.selectedOffDayIndex == index &&
                        (newValue ?? false)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppStrings.thisDayIsOffDay.tr),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    controller.selectedWorkingDays[index] = newValue ?? false;
                  }
                });
              },
            ),
            CustomText(
              text: controller.daysOfWeek[index],
              fontSize: ResponsiveHelper.fontSize(16),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDaySelectionOfGrid() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: ResponsiveHelper.spacing(8),
        mainAxisSpacing: ResponsiveHelper.spacing(8),
        childAspectRatio: ResponsiveHelper.isTablet ? 3.0 : 2.5,
      ),
      itemCount: controller.daysOfWeek.length,
      itemBuilder: (context, index) {
        bool isSelected = controller.selectedOffDayIndex == index;
        bool isWorkingDay = controller.selectedWorkingDays[index];

        return GestureDetector(
          onTap: isWorkingDay
              ? () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppStrings.thisDayIsWorkingDay.tr),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          }
              : () {
            if (isSelected && controller.selectedOffDayIndex != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppStrings.minimumOneOffDayRequired.tr),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 2),
                ),
              );
              return;
            }
            setState(() {
              controller.toggleOffDay(index);
            });
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isWorkingDay
                  ? Colors.grey[400]
                  : (isSelected ? Colors.red : Colors.grey[300]),
              borderRadius:
              BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
            ),
            child: CustomText(
              text: controller.daysOfWeek[index],
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.fontSize(13),
            ),
          ),
        );
      },
    );
  }
}

///==================================✅✅Passport Option✅✅=======================
class PassportOption extends StatelessWidget {
  const PassportOption({super.key, required this.controller});
  final AddEmployeeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isPassportOpen.value
        ? Column(
      children: [
        CustomTextField(
          textEditingController: controller.passportController,
          hintText: AppStrings.passportNumber.tr,
          fillColor: Colors.white,
        ),
        SizedBox(height: ResponsiveHelper.spacing(8)),
        CustomTextField(
          textEditingController: controller.passportExpireDateController,
          readOnly: true,
          hintText: AppStrings.expireDate.tr,
          fillColor: Colors.white,
          suffixIcon: const Icon(Icons.calendar_month),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              controller.passportExpireDateController.text =
              "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
            }
          },
        ),
      ],
    )
        : const SizedBox());
  }
}

///==================================✅✅CPR Option✅✅=======================
class CprOption extends StatelessWidget {
  const CprOption({super.key, required this.controller});
  final AddEmployeeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isCprOpen.value
        ? Column(
      children: [
        CustomTextField(
          textEditingController: controller.cprNumberController,
          hintText: AppStrings.cprNumber.tr,
          fillColor: Colors.white.withOpacity(0.5),
        ),
        SizedBox(height: ResponsiveHelper.spacing(8)),
        CustomTextField(
          textEditingController: controller.cprExpireDateController,
          readOnly: true,
          hintText: AppStrings.expireDate.tr,
          fillColor: Colors.white.withOpacity(0.5),
          suffixIcon: const Icon(Icons.calendar_month),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              controller.cprExpireDateController.text =
              "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
            }
          },
        ),
      ],
    )
        : const SizedBox());
  }
}

///==================================✅✅Job Type✅✅=======================
class JobType extends StatelessWidget {
  const JobType({super.key, required this.controller});
  final AddEmployeeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => CustomTextField(
      textEditingController: controller.jobTypeController,
      suffixIcon: PopupMenuButton<String>(
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        onSelected: (value) {
          controller.updateJobType(value);
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: "Full Time",
            child: CustomText(
              text: AppStrings.fullTime,
              fontSize: ResponsiveHelper.fontSize(14),
            ),
          ),
          PopupMenuItem(
            value: "Part Time",
            child: CustomText(
              text: AppStrings.partTime,
              fontSize: ResponsiveHelper.fontSize(14),
            ),
          ),
        ],
      ),
      hintText: controller.selectedJobType.value.isEmpty
          ? AppStrings.jobType.tr
          : controller.selectedJobType.value,
      readOnly: true,
      fillColor: AppColors.employeeCardColor,
    ));
  }
}

///==================================✅✅Edit Employee Image✅✅=======================
class EditEmployeeImage extends StatelessWidget {
  const EditEmployeeImage({super.key, required this.controller});
  final AddEmployeeController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.pickImage();
      },
      child: Obx(() {
        final imageProvider = _getImageProvider();

        return SizedBox(
          width: ResponsiveHelper.width(117),
          height: ResponsiveHelper.height(117),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: ResponsiveHelper.width(58.5),
            backgroundImage: imageProvider,
            child: ClipOval(
              child: Image(
                image: imageProvider!,
                width: ResponsiveHelper.width(117),
                height: ResponsiveHelper.height(117),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
        );
      }),
    );
  }

  ImageProvider<Object>? _getImageProvider() {
    if (controller.profileImage.value != null) {
      return FileImage(controller.profileImage.value!);
    } else if (controller.image.value.isNotEmpty) {
      return NetworkImage("${ApiUrl.networkUrl}${controller.image.value}");
    } else {
      return null;
    }
  }
}