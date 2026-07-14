import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/notification_controller/notification_controller.dart';
import 'package:tidybayte/app/global/helper/GenerelError/general_error.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/global/helper/time_converter/time_converter.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/no_internet_screen/no_internet_screen.dart';
import 'package:tidybayte/app/view/components/notification_card/notification_card.dart';

class EmployeeNotificationScreen extends StatelessWidget {
  EmployeeNotificationScreen({super.key});

  final NotificationController notificationController =
      Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
          backgroundColor: const Color(0xFFE3F2FD), // Light blue background
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
            child: Padding(
              padding: ResponsiveHelper.symmetric(horizontal: 16, vertical: 25),
              child: Column(
                children: [
                  CustomMenuAppbar(
                    title: AppStrings.notification.tr,
                    onBack: () {
                      Get.back();
                    },
                  ),
                  Expanded(
                    child: Obx(() {
                      switch (notificationController.rxRequestStatus.value) {
                        case Status.loading:
                          return const Center(
                              child: CustomLoader()); // ✅ Loader Centered

                        case Status.internetError:
                          return NoInternetScreen(
                            onTap: () {
                              notificationController.getNotification();
                            },
                          );

                        case Status.error:
                          return GeneralErrorScreen(
                            onTap: () {
                              notificationController.getNotification();
                            },
                          );

                        case Status.completed:
                          if (notificationController.notificationList.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: ResponsiveHelper.all(20),
                                child: Text(
                                  AppStrings.noNotificationsFound.tr,
                                  style: TextStyle(
                                    fontSize: ResponsiveHelper.fontSize(16),
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }

                          return RefreshIndicator(
                            onRefresh: () async {
                              notificationController
                                  .getNotification(); // ✅ Refresh Indicator Added
                            },
                            child: ListView.builder(
                              padding: ResponsiveHelper.symmetric(vertical: 10),
                              itemCount: notificationController
                                  .notificationList.length,
                              itemBuilder: (context, index) {
                                final data = notificationController
                                    .notificationList[index];
                                return Padding(
                                  padding: ResponsiveHelper.all(8),
                                  child: NotificationCard(
                                    icon: Icons.notifications_none_outlined,
                                    title: data.message ?? "",
                                    createdAt: data.createdAt!,
                                    // timeAgo: data.message ?? "",
                                    date: DateConverter.estimatedDate(
                                        data.createdAt!.toLocal()),
                                  ),
                                );
                              },
                            ),
                          );
                      }
                    }),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          )),
    );
  }
}
