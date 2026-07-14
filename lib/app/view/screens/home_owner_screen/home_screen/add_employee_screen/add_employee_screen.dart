import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/add_employee_controller/add_employee.dart';
import 'package:tidybayte/app/controller/owner_controller/add_employee_controller/add_employee_controller.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_images/app_images.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/components/custom_text_field/custom_text_field.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final AddEmployeeController controller = Get.find<AddEmployeeController>();

  @override
  Widget build(BuildContext context) {


    print(
        "selectedWorkingDays======================${controller.selectedWorkingDays}");
    print(
        "selectedWorkingDays======================${controller.selectedOffDayIndex}");

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
                ///==================================✅✅Add Employee Title✅✅=======================
                CustomMenuAppbar(
                  title: AppStrings.addEmployee.tr,
                  onBack: () {
                    Get.back();
                  },
                ),

                ///==================================✅✅Employee Content✅✅=======================
                Expanded(
                  child: Obx(() {
                    return ListView(
                      padding: EdgeInsets.all(ResponsiveHelper.padding(16.0)),
                      children: [
                        Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              ///==================================✅✅Employee Image✅✅=======================
                              AddEmployeeImage(controller: controller),

                              SizedBox(height: ResponsiveHelper.spacing(4)),
                          const Text(
                            AppStrings.tapUploadImage,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            )),

                              SizedBox(height: ResponsiveHelper.spacing(20)),

                              ///==================================✅✅Employee Personal List✅✅=======================
                              CustomTextField(
                                hintText: AppStrings.employeeFirstName.tr,
                                fillColor: AppColors.employeeCardColor,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.pleaseEnterYourFirstName.tr;
                                  }
                                  return null;
                                },
                                textEditingController: controller.firstNameController,
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(8)),

                              CustomTextField(
                                hintText: AppStrings.employeeLastName.tr,
                                fillColor: AppColors.employeeCardColor,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.pleaseEnterYourLastName.tr;
                                  }
                                  return null;
                                },
                                textEditingController: controller.lastNameController,
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(8)),

                              ///==================================✅✅jobType✅✅=======================
                              JobType(controller: controller),
                              SizedBox(height: ResponsiveHelper.spacing(8)),

                              CustomTextField(
                                hintText: AppStrings.employeeDesignation.tr,
                                fillColor: AppColors.employeeCardColor,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.pleaseEnterYourDesignation.tr;
                                  }
                                  return null;
                                },
                                textEditingController: controller.designationController,
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(8)),

                              CustomTextField(

                                hintText: AppStrings.employeeAddress.tr,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.pleaseEnterYourAddress.tr;
                                  }
                                  return null;
                                },
                                fillColor: AppColors.employeeCardColor,
                                textEditingController: controller.addressController,
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(8)),

                              ///==================================✅✅CPR✅✅=======================
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
                                hintText: AppStrings.employeeCPR.tr,
                                fillColor: AppColors.white,
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(8)),

                              CprOption(controller: controller),
                              SizedBox(height: ResponsiveHelper.spacing(8)),

                              ///==================================✅✅Passport✅✅=======================
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
                                hintText: AppStrings.employeePassport.tr,
                                fillColor: AppColors.employeeCardColor,
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(8)),

                              PassportOption(controller: controller),
                              SizedBox(height: ResponsiveHelper.spacing(8)),

                              ///==================================✅✅Note✅✅=======================
                              CustomTextField(
                                textEditingController: controller.noteController,
                                hintText: AppStrings.note.tr,
                                fillColor: AppColors.employeeCardColor,
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(8)),

                              ///==================================✅✅Phone✅✅=======================
                              CustomTextField(
                                textEditingController: controller.phoneNumberController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.pleaseEnterPhoneNumber.tr;
                                  }
                                  String phone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
                                  final phoneRegex = RegExp(r'^\+?[0-9]{8,16}$');
                                  if (!phoneRegex.hasMatch(phone)) {
                                    return AppStrings.pleaseEnterValidPhoneNumber.tr;
                                  }
                                  return null;
                                },
                                hintText: AppStrings.employeeContactNumber.tr,
                                fillColor: AppColors.employeeCardColor,
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(8)),

                              ///==================================✅✅Email✅✅=======================
                              CustomTextField(
                                textEditingController: controller.emailController,
                                hintText: AppStrings.employeeEmail.tr,
                                fillColor: AppColors.employeeCardColor,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.pleaseEnterYourEmployeeMail.tr;
                                  }
                                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                  if (!emailRegex.hasMatch(value)) {
                                    return AppStrings.pleaseEnterValidEmail.tr;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(8)),

                              ///==================================✅✅Temporary Password✅✅=======================
                              CustomTextField(
                                textEditingController: controller.passwordController,
                                hintText: AppStrings.temporaryPassword.tr,
                                fillColor: AppColors.employeeCardColor,
                                isPassword: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.passwordMustHaveEightWith.tr;
                                  } else if (value.length < 8 ||
                                      !AppStrings.passRegexp.hasMatch(value)) {
                                    return AppStrings.passwordLengthAndContain.tr;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(15)),

                              ///==================================✅✅Start Time✅✅=======================
                              CustomTextField(
                                textEditingController: controller.startTimeController,
                                readOnly: true,
                                hintText: AppStrings.workStartTime.tr,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.pleaseEnterStartTime.tr;
                                  }
                                  return null;
                                },
                                fillColor: Colors.white,
                                suffixIcon: const Icon(Icons.access_time),
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    helpText: AppStrings.workStartTime.tr,
                                    builder: (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: false),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (pickedTime != null) {
                                    controller.startTimeController.text =
                                        controller.formatTo12Hour(pickedTime.hour, pickedTime.minute);
                                  }
                                },
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(15)),

                              ///==================================✅✅End Time✅✅=======================
                              CustomTextField(
                                textEditingController: controller.endTimeController,
                                readOnly: true,
                                hintText: AppStrings.workEndTime.tr,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.pleaseEnterEndTime.tr;
                                  }
                                  return null;
                                },
                                fillColor: Colors.white,
                                suffixIcon: const Icon(Icons.access_time),
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    helpText: AppStrings.workEndTime.tr,
                                    builder: (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: false),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (pickedTime != null) {
                                    controller.endTimeController.text =
                                        controller.formatTo12Hour(pickedTime.hour, pickedTime.minute);
                                  }
                                },
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(15)),

                              ///==================================✅✅Break Start Time✅✅=======================
                              CustomTextField(
                                textEditingController: controller.breakStartTimeController,
                                readOnly: true,
                                hintText: AppStrings.breakStartTime.tr,
                                fillColor: Colors.white,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.pleaseEnterBreakStartTime.tr;
                                  }
                                  return null;
                                },
                                suffixIcon: const Icon(Icons.access_time),
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    helpText: AppStrings.breakStartTime.tr,
                                    builder: (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: false),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (pickedTime != null) {
                                    controller.breakStartTimeController.text =
                                        controller.formatTo12Hour(pickedTime.hour, pickedTime.minute);
                                  }
                                },
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(15)),

                              ///==================================✅✅Break End Time✅✅=======================
                              CustomTextField(
                                textEditingController: controller.breakEndTimeController,
                                readOnly: true,
                                hintText: AppStrings.breakEndTime.tr,
                                fillColor: Colors.white,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppStrings.pleaseEnterBreakEndTime.tr;
                                  }
                                  return null;
                                },
                                suffixIcon: const Icon(Icons.access_time),
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    helpText: AppStrings.breakEndTime.tr,
                                    builder: (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: false),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (pickedTime != null) {
                                    controller.breakEndTimeController.text =
                                        controller.formatTo12Hour(pickedTime.hour, pickedTime.minute);
                                  }
                                },
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(15)),

                              ///==================================✅✅Select Working Days✅✅=======================
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

                              ///==================================✅✅Select Off Days✅✅=======================
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

                              ///==================================✅✅Add New Employee Button✅✅=======================
                              controller.isLoading.value
                                  ? const CustomLoader()
                                  : CustomButton(
                                onTap: () {
                                  if (!controller.formKey.currentState!.validate() &&
                                      controller.validateProfileImage()) {
                                    return;
                                  }
                                  AddEmployee.addEmployee(
                                    firstName: controller.firstNameController.text.trim(),
                                    lastName: controller.lastNameController.text.trim(),
                                    email: controller.emailController.text.trim(),
                                    password: controller.passwordController.text.trim(),
                                    profileImage: controller.profileImage.value!,
                                    phoneNumber: controller.phoneNumberController.text.trim(),
                                    jobType: controller.selectedJobType.value,
                                    designation: controller.designationController.text.trim(),
                                    address: controller.addressController.text.trim(),
                                    cprNumber: controller.cprNumberController.text.trim(),
                                    cprExpDate: controller.cprExpireDateController.text.trim(),
                                    passportNumber: controller.passportController.text.trim(),
                                    passportExpDate: controller.passportExpireDateController.text.trim(),
                                    note: controller.noteController.text.trim(),
                                    dutyTime:
                                    "${controller.startTimeController.text}-${controller.endTimeController.text}",
                                    workingDay: controller.getSelectedDays(),
                                    offDay: controller.getSelectedOffDays(),
                                    context: context,
                                    breakTimeStar: controller.breakStartTimeController.text,
                                    breakTimeEnd: controller.breakEndTimeController.text,
                                  );
                                },
                                fillColor: Colors.white,
                                title: AppStrings.addNewEmployee.tr,
                              ),
                            ],
                          ),
                        )
                      ],
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
                    if (controller.selectedOffDayIndex == index && (newValue ?? false)) {
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
              borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(10)),
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

///==================================✅✅Passport Section✅✅=======================
class PassportOption extends StatelessWidget {
  const PassportOption({super.key, required this.controller});

  final AddEmployeeController controller;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Obx(() => controller.isPassportOpen.value
        ? Container(
      margin: EdgeInsets.only(top: ResponsiveHelper.spacing(6)),
      padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          CustomTextField(
            hintStyle: TextStyle(fontSize: ResponsiveHelper.fontSize(18)),
            textEditingController: controller.passportController,
            hintText: AppStrings.passportNumber.tr,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.pleaseEnterPassportNumber.tr;
              }
              return null;
            },
            fillColor: Colors.white,
          ),
          SizedBox(height: ResponsiveHelper.spacing(8)),
          CustomTextField(
            textEditingController: controller.passportExpireDateController,
            readOnly: true,
            hintStyle: TextStyle(fontSize: ResponsiveHelper.fontSize(18)),
            hintText: AppStrings.passportExpireDate.tr,

            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.pleaseEnterPassportExpireDate.tr;
              }
              return null;
            },
            fillColor: Colors.white,
            suffixIcon: const Icon(Icons.calendar_month),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                helpText:AppStrings.passportExpireDate.tr,
                builder: (context, child) {
                  return Directionality(
                    textDirection: TextDirection.ltr,
                    child: child!,
                  );
                },
              );
              if (pickedDate != null) {
                controller.passportExpireDateController.text =
                "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
              }
            },
          ),
        ],
      ),
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
    ResponsiveHelper.init(context);
    return Obx(() => controller.isCprOpen.value
        ? Container(
      margin: EdgeInsets.only(top: ResponsiveHelper.spacing(6)),
      padding: EdgeInsets.all(ResponsiveHelper.padding(12)),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          CustomTextField(
            textEditingController: controller.cprNumberController,
            hintText: AppStrings.cprNumber.tr,
            hintStyle: TextStyle(fontSize: ResponsiveHelper.fontSize(18)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.pleaseEnterCprNumber.tr;
              }
              return null;
            },
            fillColor: AppColors.white,
          ),
          SizedBox(height: ResponsiveHelper.spacing(8)),
          CustomTextField(
            textEditingController: controller.cprExpireDateController,
            readOnly: true,
            hintText: AppStrings.cprExpireDate.tr,
            hintStyle: TextStyle(fontSize: ResponsiveHelper.fontSize(18)),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.pleaseEnterCprExpireDate.tr;
              }
              return null;
            },
            fillColor: AppColors.white,
            suffixIcon: const Icon(Icons.calendar_month),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                  helpText: AppStrings.cprExpireDate.tr,
                builder: (context, child) {
                  return Directionality(
                    textDirection: TextDirection.ltr,
                    child: child!,
                  );
                },
              );
              if (pickedDate != null) {
                controller.cprExpireDateController.text =
                "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
              }
            },
          ),
        ],
      ),
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
    ResponsiveHelper.init(context);
    return Obx(() => CustomTextField(
      textEditingController: controller.jobTypeController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppStrings.pleaseEnterJobType.tr;
        }
        return null;
      },
      suffixIcon: PopupMenuButton<String>(
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        color: Colors.white,
        onSelected: (value) {
          controller.updateJobType(value);
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: "Full Time",
            child: CustomText(
              text: AppStrings.fullTime.tr,
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: ResponsiveHelper.fontSize(14),
            ),
          ),
          PopupMenuItem(
            value: "Part Time",
            child: CustomText(
              text: AppStrings.partTime.tr,
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: ResponsiveHelper.fontSize(14),
            ),
          ),
        ],
      ),
      hintText: controller.selectedJobType.value.isEmpty
          ? AppStrings.jobType.tr
          : controller.selectedJobType.value,
      readOnly: true,
      fillColor: AppColors.white,
    ));
  }
}

///==================================✅✅Add Employee Image✅✅=======================
class AddEmployeeImage extends StatelessWidget {
  const AddEmployeeImage({super.key, required this.controller});

  final AddEmployeeController controller;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            controller.pickImage();
          },
          child: Obx(() {
            return CircleAvatar(
              radius: ResponsiveHelper.width(58.5),
              backgroundImage: controller.profileImage.value != null
                  ? FileImage(controller.profileImage.value!)
                  : const AssetImage(AppImages.avatar) as ImageProvider<Object>,
              child: controller.profileImage.value == null
                  ? Icon(
                Icons.add_a_photo,
                size: ResponsiveHelper.iconSize(30),
                color: Colors.white,
              )
                  : null,
            );
          }),
        ),
      ],
    );
  }
}