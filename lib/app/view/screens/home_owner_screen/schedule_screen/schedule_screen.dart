import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/work_schedule_controller/work_schedule_controller.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/components/nav_bar/nav_bar.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/home_screen/home_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/schedule_screen/task_schedule/task_schedule.dart';
import 'work_schedule/pdf_download_page.dart';
import 'work_schedule/work_schedule.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<ScheduleScreen> {
  int selectedTabIndex = 0;


  final List<Widget> screens = [
    const TaskSchedule(),   // LEFT
    const WorkSchedule(),   // RIGHT
  ];

  final List<String> schedule = [
    AppStrings.taskSchedule.tr, // LEFT
    AppStrings.workSchedule.tr, // RIGHT
  ];


  final WorkScheduleController controller = Get.find<WorkScheduleController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.off(() => const HomeScreen());
        return false;
      },
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          bottomNavigationBar: const NavBar(currentIndex: 1),
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xCCE8F3FA), // First color (with opacity)
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
                    ///=============================== Schedule Appbar ========================
                    CustomMenuAppbar(
                      onDownload: () {
                        Get.to(const WorkScheduleDownloadScreen());
                      },
                      title: AppStrings.scheduleOverview.tr,
                      onBack: () {
                        Get.off(() => const HomeScreen());
                      },
                      // download: selectedTabIndex == 0,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(20)),

                    ///=============================== Tab Switching ========================
                    Row(
                      children: List.generate(
                        schedule.length,
                        (index) => Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedTabIndex = index;
                              });
                            },
                            child: Container(
                              padding: ResponsiveHelper.symmetric(
                                  vertical: 10, horizontal: 28),
                              decoration: BoxDecoration(
                                  color: selectedTabIndex == index
                                      ? AppColors.light50
                                      : AppColors.light50,
                                  border: Border(
                                    bottom: selectedTabIndex == index
                                        ? BorderSide(
                                            color: AppColors.blue900,
                                            width: ResponsiveHelper.width(4))
                                        : BorderSide(
                                            color: AppColors.blue50,
                                            width: ResponsiveHelper.width(4)),
                                  )),
                              child: CustomText(
                                text: schedule[index],
                                fontWeight: FontWeight.w400,
                                fontSize:ResponsiveHelper.fontSize(18),
                                color: AppColors.blue900,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(20)),

                    ///=============================== Selected Screen ========================
                    screens[selectedTabIndex],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
