import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tidybayte/app/controller/employee_controller/employee_home_controller.dart';
import 'package:tidybayte/app/controller/owner_controller/profile_controller/profile_controller.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/components/employee_nav_bar/employee_navbar.dart';
import 'package:tidybayte/app/view/components/user_task_card/user_task_card.dart';
import 'package:tidybayte/app/view/screens/employee_screen/employee_home_screen/inner_widget/employee_home_app_bar.dart';
import '../../../../utils/app_strings/app_strings.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final EmployeeHomeController controller = Get.find<EmployeeHomeController>();
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllTasksGrouped();
      profileController.getProfile();
    });
  }

  String getDisplayTitle(String dateKey) {
    try {
      DateTime date = intl.DateFormat('MM/dd/yyyy').parse(dateKey);
      return intl.DateFormat('EEEE').format(date);
    } catch (e) {
      print("Error parsing date: $dateKey - $e");
      return dateKey;
    }
  }

  List<String> getSortedDateKeys(Map<String, dynamic> groupedTasks) {
    List<String> dateKeys = groupedTasks.keys.toList();

    dateKeys.sort((a, b) {
      try {
        DateTime dateA = intl.DateFormat('MM/dd/yyyy').parse(a);
        DateTime dateB = intl.DateFormat('MM/dd/yyyy').parse(b);
        return dateA.compareTo(dateB);
      } catch (e) {
        return a.compareTo(b);
      }
    });

    return dateKeys;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.addedColor,
        bottomNavigationBar: const EmployeeNavbar(currentIndex: 0),
        body: Obx(() {
          final employee = profileController.profileModel.value;

          return Column(
            children: [
              EmployeeHomeAppBar(
                scaffoldKey: scaffoldKey,
                image: "${ApiUrl.networkUrl}${employee.profileImage ?? ""}",
                name: "${employee.firstName ?? ""} ${employee.lastName ?? ""}",
              ),

              /// ========================= Display All Tasks Grouped By Day ========================= ///
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller.getAllTasksGrouped();
                    await profileController.getProfile();
                  },
                  child: controller.isLoadingAdditionalTask.value
                      ? const Center(child: CustomLoader())
                      : controller.groupedTasks.isEmpty
                      ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: Get.height * 0.4),
                      Center(
                        child: CustomText(
                          text: AppStrings.noTask.tr,
                          color: AppColors.dark200,
                          fontWeight: FontWeight.w400,
                          fontSize: ResponsiveHelper.fontSize(16),
                        ),
                      ),
                    ],
                  )
                      : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: ResponsiveHelper.symmetric(horizontal: 20),
                      child: Column(
                        children:
                        getSortedDateKeys(controller.groupedTasks)
                            .map((dateKey) {
                          final tasksForDay =
                          controller.groupedTasks[dateKey]!;
                          final displayTitle =
                          getDisplayTitle(dateKey);

                          bool isOffDay = tasksForDay.every((task) =>
                          task.dayOfWeek != null &&
                              !(task.assignedTo?.workingDay
                                  ?.contains(task.dayOfWeek!) ??
                                  false));

                          return Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: ResponsiveHelper.spacing(10),
                              ),

                              /// Day Header
                              CustomText(
                                text: displayTitle,
                                color: AppColors.dark300,
                                fontWeight: FontWeight.w400,
                                fontSize:
                                ResponsiveHelper.fontSize(24),
                              ),

                              SizedBox(
                                height: ResponsiveHelper.spacing(8),
                              ),

                              /// Task Count - Show only if it's a work day
                              if (!isOffDay)
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: ResponsiveHelper.padding(8),
                                    bottom:
                                    ResponsiveHelper.padding(8),
                                  ),
                                  child: CustomText(
                                    text:
                                    "${tasksForDay.length} ${AppStrings.task.tr}",
                                    color: AppColors.dark200,
                                    fontWeight: FontWeight.w400,
                                    fontSize:
                                    ResponsiveHelper.fontSize(12),
                                  ),
                                ),

                              /// Horizontal Task List
                              SizedBox(
                                height:
                                ResponsiveHelper.height(290),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: tasksForDay.length,
                                  itemBuilder: (context, index) {
                                    final task = tasksForDay[index];
                                    bool isOffDay = task.dayOfWeek !=
                                        null &&
                                        !(task.assignedTo?.workingDay
                                            ?.contains(
                                            task.dayOfWeek!) ??
                                            false);
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        right:
                                        ResponsiveHelper.padding(
                                            12),
                                      ),
                                      child: UserTaskCard(
                                        date:
                                        task.startDateStr ?? "",
                                        isWorkingDay: !isOffDay,
                                        isOffDay: isOffDay,
                                        workingDay: task.recurrence ==
                                            'one_time'
                                            ? null
                                            : (task.assignedTo
                                            ?.workingDay ??
                                            [])
                                            .map((day) => day
                                            .toString()
                                            .split('.')
                                            .last)
                                            .join(', '),
                                        name:
                                        "${task.assignedTo?.firstName ?? ""} ${task.assignedTo?.lastName ?? ""}",
                                        role:
                                        task.status ?? "Pending",
                                        workTitle: task.taskName ??
                                            "Unknown Task",
                                        workDetails:
                                        task.taskDetails ??
                                            "Unknown Task",
                                        time:
                                        '${task.startTimeStr ?? ""} To ${task.endTimeStr ?? ""}',
                                        imageUrl:
                                        "${ApiUrl.networkUrl}${task.assignedTo?.profileImage ?? ""}",
                                        offDay: task.dayOfWeek,
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}