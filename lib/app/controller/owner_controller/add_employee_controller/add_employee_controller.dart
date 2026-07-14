import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/core/dependency/path.dart';
import 'package:tidybayte/app/data/model/owner_model/employee_model.dart';
import 'package:tidybayte/app/data/model/owner_model/single_employee_model.dart';
import 'package:tidybayte/app/data/service/api_check.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/local_db/local_db.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

class AddEmployeeController extends GetxController {
  ApiClient apiClient = serviceLocator();
  DBHelper dbHelper = serviceLocator();
  final RxBool isCprOpen = true.obs;
  final RxBool isPassportOpen = true.obs;
  final RxString selectedJobType = ''.obs;
  var isLoading = false.obs;

  void setLoading(bool value) {
    isLoading.value = value;
  }

  var isEditLoading = false.obs;

  void editLoading(bool value) {
    isEditLoading.value = value;
  }

  void updateJobType(String jobType) {
    selectedJobType.value = jobType;
    jobTypeController.text = jobType;
    debugPrint("Selected Job Type: =======================$jobType");
  }

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final designationController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final jobTypeController = TextEditingController();
  final cprNumberController = TextEditingController();
  final cprExpireDateController = TextEditingController();
  final passportController = TextEditingController();
  final noteController = TextEditingController();
  final passportExpireDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final breakStartTimeController = TextEditingController();
  final breakEndTimeController = TextEditingController();
  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  final rxRequestStatus = Status.loading.obs;

  ///
  String formatTo12Hour(int hour, int minute) {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0
        ? 12
        : hour > 12
            ? hour - 12
            : hour;
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  final List<String> daysOfWeek = [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  List<String> getSelectedDays() {
    List<String> workingDays = [];

    for (int i = 0; i < daysOfWeek.length; i++) {
      if (selectedWorkingDays[i]) {
        workingDays.add(daysOfWeek[i]);
      }
    }

    return workingDays;
  }

  List<bool> selectedWorkingDays = [true, false, true, true, true, true, true];

  // Off day - initially Sunday (index 1)
  int? selectedOffDayIndex = 1;

  void toggleOffDay(int index) {
    // Prevent selecting a day that's already a working day
    if (selectedWorkingDays[index]) {
      Get.snackbar(
        'Invalid Selection',
        'This day is already selected as a working day',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedOffDayIndex == index) {
      selectedOffDayIndex = null;
    } else {
      selectedOffDayIndex = index;
    }
  }

  // Toggle working day with validation
  void toggleWorkingDay(int index) {
    // Prevent unchecking if it would be selected as off day
    if (selectedOffDayIndex == index && selectedWorkingDays[index]) {
      Get.snackbar(
        'Invalid Selection',
        'This day is selected as an off day. Remove it from off days first.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    selectedWorkingDays[index] = !selectedWorkingDays[index];
  }

  String getSelectedOffDays() {
    return selectedOffDayIndex != null ? daysOfWeek[selectedOffDayIndex!] : "";
  }

  ///

  addEmployeeFieldClear() {
    firstNameController.clear();
    lastNameController.clear();
    phoneNumberController.clear();
    jobTypeController.clear();
    cprNumberController.clear();
    cprExpireDateController.clear();
    passportController.clear();
    startTimeController.clear();
    endTimeController.clear();
    passportExpireDateController.clear();
    noteController.clear();
  }

  RxString image = "".obs;

  Rx<File?> profileImage = Rx<File?>(null);

  /// Validate that the profile image is selected
  bool validateProfileImage() {
    if (profileImage.value == null) {
      Get.snackbar(
        AppStrings.error.tr,
        AppStrings.profileImageIsRequired.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
      print("✅ Selected Image:===== ${profileImage.value!.path}");
    } else {
      print("❌ No Image Selected");
    }
  }

  ///==================================✅✅Get Employee✅✅=======================

  Rx<EmployeeData> employeeData = EmployeeData().obs;
  RxString selectedEmployeeId = ''.obs;

  getEmployee() async {
    setRxRequestStatus(Status.loading);
    refresh();
    try {
      final response =
          await apiClient.get(url: ApiUrl.getEmployee, showResult: true);

      if (response.statusCode == 200) {
        employeeData.value = EmployeeData.fromJson(response.body["data"]);

        print('StatusCode==================${response.statusCode}');
        print(
            'Employee Result==================${employeeData.value.result?.length}');
        setRxRequestStatus(Status.completed);
        refresh();
      } else {
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      setRxRequestStatus(Status.error);
    }
  }

  ///==================================✅✅Get Single Employee✅✅=======================

  Rx<SingleEmployeeData> singleEmployeeData = SingleEmployeeData().obs;

  getSingleEmployee({required String employeeId}) async {
    setRxRequestStatus(Status.loading);
    refresh();
    try {
      final response = await apiClient.get(
          url: ApiUrl.singleEmployee(employeeId), showResult: true);

      if (response.statusCode == 200) {
        singleEmployeeData.value =
            SingleEmployeeData.fromJson(response.body["data"]);

        print('StatusCode==================${response.statusCode}');
        print(
            'Employee Result==================${singleEmployeeData.value.employeeId}');
        setRxRequestStatus(Status.completed);
        refresh();
      } else {
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      setRxRequestStatus(Status.error);
    }
  }

  ///==================================✅✅sendEmail✅✅=======================
  void sendEmail(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            backgroundColor: AppColors.addedColor,
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  Container(
                    height: 96,
                    width: 96,
                    decoration: const BoxDecoration(
                      color: AppColors.blue900,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                        child: CustomImage(
                      imageSrc: AppIcons.rightUp,
                    )),
                  ),
                  CustomText(
                    top: 24,
                    bottom: 40,
                    maxLines: 2,
                    text: AppStrings.employeeAddedSu.tr,
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                    color: AppColors.successFullyColor,
                  ),
                  CustomText(
                    maxLines: 5,
                    text: AppStrings.emplyeesAccountDetails.tr,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.dark400,
                  ),
                  CustomText(
                    maxLines: 2,
                    bottom: 20,
                    text: emailController.text,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.dark400,
                  ),
                  Row(
                    children: [
                      CustomText(
                        maxLines: 2,
                        text: "${AppStrings.temporaryPassword}:".tr,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.dark400,
                      ),
                      CustomText(
                        maxLines: 2,
                        text: passwordController.text,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: AppColors.dark400,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 48.h,
                  ),
                  CustomButton(
                    title: "Ok".tr,
                    onTap: () {
                      Get.toNamed(AppRoutes.mainSentSuccessfullyScreen);
                      emailController.clear();
                      passwordController.clear();
                    },
                    fillColor: Colors.white,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void clearAllData() {
    // Clear all text controllers
    firstNameController.clear();
    lastNameController.clear();
    jobTypeController.clear();
    cprNumberController.clear();
    cprExpireDateController.clear();
    passportController.clear();
    passportExpireDateController.clear();
    noteController.clear();
    phoneNumberController.clear();
    startTimeController.clear();
    endTimeController.clear();
    breakStartTimeController.clear();
    breakEndTimeController.clear();

    // Clear reactive variables
    selectedJobType.value = '';
    image.value = '';
    profileImage.value = null;

    // Reset working days to default
    selectedWorkingDays = [true, false, true, true, true, true, true];

    // Reset off day to Sunday (index 1)
    selectedOffDayIndex = 1;

    // Reset dropdown states
    isCprOpen.value = false;
    isPassportOpen.value = false;

    print("🧹 All controller data cleared");
  }
}
