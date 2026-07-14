import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tidybayte/app/controller/owner_controller/add_employee_controller/add_employee_controller.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/GenerelError/general_error.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:tidybayte/app/view/components/custom_profile_item/custom_profile_item.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/components/no_internet_screen/no_internet_screen.dart';

class EmployeeDetails extends StatefulWidget {
  const EmployeeDetails({super.key});

  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  final AddEmployeeController employeeController =
  Get.find<AddEmployeeController>();

  final String employeeId = Get.arguments[0];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await employeeController.getSingleEmployee(
          employeeId: employeeId.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("EmployeeId===========================$employeeId");

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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ///==================================✅✅employeeDetails Appbar✅✅=======================
                  CustomMenuAppbar(
                    onTap: () async {
                      Get.toNamed(AppRoutes.editEmployeeDetails,
                          arguments: {"employeeId": employeeId});
                    },
                    isEdit: true,
                    title: AppStrings.employeeDetails.tr,
                    onBack: () {
                      Get.back();
                    },
                  ),

                  ///==========================Body Here=====================
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.padding(21)),
                    child: Container(
                      padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xCCE8F3FA),
                            Color(0xCCE8F3FA),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Obx(() {
                        if (employeeController.rxRequestStatus.value ==
                            Status.loading) {
                          return const CustomLoader();
                        }

                        if (employeeController.rxRequestStatus.value ==
                            Status.internetError) {
                          return NoInternetScreen(onTap: () {
                            employeeController.getSingleEmployee(
                                employeeId: employeeId.toString());
                          });
                        }

                        if (employeeController.rxRequestStatus.value ==
                            Status.error) {
                          return GeneralErrorScreen(onTap: () {
                            employeeController.getSingleEmployee(
                                employeeId: employeeId.toString());
                          });
                        }

                        var data = employeeController.singleEmployeeData.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: CustomNetworkImage(
                                boxShape: BoxShape.circle,
                                imageUrl:
                                "${ApiUrl.networkUrl}${data.profileImage}",
                                height: ResponsiveHelper.height(128),
                                width: ResponsiveHelper.width(128),
                              ),
                            ),

                            SizedBox(height: ResponsiveHelper.spacing(25)),

                            Row(
                              children: [
                                CustomText(
                                  textAlign: TextAlign.start,
                                  top: ResponsiveHelper.spacing(10),
                                  text: "${AppStrings.name.tr} ",
                                  color: AppColors.dark400,
                                  fontWeight: FontWeight.w500,
                                  fontSize: ResponsiveHelper.fontSize(20),
                                ),
                                Expanded(
                                  child: CustomText(
                                    textAlign: TextAlign.start,
                                    top: ResponsiveHelper.spacing(10),
                                    text:
                                    '${data.firstName ?? ""} ${data.lastName ?? ""}',
                                    color: AppColors.dark400,
                                    fontWeight: FontWeight.w500,
                                    fontSize: ResponsiveHelper.fontSize(20),
                                  ),
                                ),
                              ],
                            ),

                            ///================================id========================
                            CustomProfileItem(
                              title: AppStrings.id.tr,
                              subTitle: data.id ?? "",
                            ),

                            ///================================Email========================
                            CustomProfileItem(
                              title: '${AppStrings.email.tr}:',
                              subTitle: data.email ?? "",
                            ),

                            ///================================Contact No========================
                            CustomProfileItem(
                              title: "${AppStrings.contactNumber.tr}:",
                              subTitle: data.phoneNumber ?? "",
                            ),

                            ///================================CPR========================
                            CustomProfileItem(
                              title: '${AppStrings.cPR.tr}:',
                              subTitle: data.cprNumber ?? "",
                            ),

                            ///================================Passport========================
                            CustomProfileItem(
                              title: '${AppStrings.passport.tr}:',
                              subTitle: data.passportNumber ?? "",
                            ),

                            ///================================Note========================
                            CustomProfileItem(
                              title: "${AppStrings.note.tr} :",
                              subTitle: data.note ?? "",
                            ),

                            ///================================jobType========================
                            CustomProfileItem(
                              title: '${AppStrings.jobType.tr}:',
                              subTitle: data.jobType ?? "",
                            ),

                            CustomProfileItem(
                              title: '${AppStrings.designation.tr}:',
                              subTitle: data.designation ?? "",
                            ),

                            CustomProfileItem(
                              title: '${AppStrings.address.tr}:',
                              subTitle: data.address ?? "",
                            ),

                            ///================================dutyTime========================
                            CustomProfileItem(
                              title: AppStrings.dutyTime.tr,
                              subTitle: data.dutyTime == null
                                  ? ""
                                  : convertTimeRange(data.dutyTime!),
                            ),

                            ///================================BreakTime========================
                            CustomProfileItem(
                              title: AppStrings.breakTimeColon.tr,
                              subTitle: (data.breakTimeStart != null &&
                                  data.breakTimeEnd != null)
                                  ? "${_formatTime(data.breakTimeStart!)} - ${_formatTime(data.breakTimeEnd!)}"
                                  : "",
                            ),

                            ///================================workingDay========================
                            CustomProfileItem(
                              title: AppStrings.workingDay.tr,
                              subTitle:
                              (data.workingDay ?? []).join(', ').isEmpty
                                  ? AppStrings.noWorkingDaysAvailable.tr
                                  : (data.workingDay ?? []).join(', '),
                              maxLine: 3,
                            ),

                            ///================================offDay========================
                            CustomProfileItem(
                              title: AppStrings.offDayColon.tr,
                              subTitle: data.offDay ?? "",
                            ),

                            SizedBox(height: ResponsiveHelper.spacing(20)),
                          ],
                        );
                      }),
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

  String convertTimeRange(String timeRange) {
    try {
      final parts = timeRange.split('-');
      if (parts.length != 2) return timeRange;
      return '${_formatTime(parts[0])} - ${_formatTime(parts[1])}';
    } catch (e) {
      return timeRange;
    }
  }

  String _formatTime(String time) {
    final format = intl.DateFormat("HH:mm");
    final parsedTime = format.parse(time);
    return intl.DateFormat("hh:mm a").format(parsedTime);
  }
}