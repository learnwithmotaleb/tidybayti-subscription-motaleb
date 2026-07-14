import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/add_employee_controller/add_employee_controller.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/image_handdaler/image_handler.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

class EmployeeShow extends StatelessWidget {
  const EmployeeShow({
    super.key,
    required this.employeeController,
  });

  final AddEmployeeController employeeController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (employeeController.rxRequestStatus.value) {
        case Status.loading:
          return const CustomLoader();

        case Status.internetError:
          return GestureDetector(
            onTap: () {
              employeeController.getEmployee();
            },
            child: CustomText(
              textAlign: TextAlign.center,
              top: ResponsiveHelper.spacing(25),
              fontWeight: FontWeight.w500,
              fontSize: ResponsiveHelper.fontSize(16),
              text: 'No Internet',
              color: Colors.black,
            ),
          );

        case Status.error:
          return GestureDetector(
            onTap: () {
              employeeController.getEmployee();
            },
            child: CustomText(
              top: ResponsiveHelper.spacing(20),
              fontWeight: FontWeight.w500,
              fontSize: ResponsiveHelper.fontSize(16),
              text: 'Try Again',
              color: Colors.black,
            ),
          );

        case Status.completed:
          var employeeList = employeeController.employeeData.value.result ?? [];

          if (employeeList.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: ResponsiveHelper.spacing(50)),
              child: Center(
                child: CustomText(
                  text: "No Employee Found",
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: ResponsiveHelper.fontSize(16),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                employeeController.employeeData.value.result?.length ?? 0,
                    (index) {
                  final data =
                  employeeController.employeeData.value.result?[index];

                  debugPrint(
                      "==============>> Profile Image =================== >>   ${data?.profileImage}");

                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.spacing(10)),
                    child: GestureDetector(
                      onTap: () {
                        print(
                            '🔍 Tapped employee: ${data?.firstName} ${data?.lastName}');
                        print('🔍 Employee id: ${data?.id}');
                        Get.toNamed(
                          AppRoutes.employeeDetails,
                          arguments: [data?.id ?? ""],
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomNetworkImage(
                              imageUrl: ImageHandler.imagesHandle(
                                  data?.profileImage),
                              height: ResponsiveHelper.height(181),
                              width: ResponsiveHelper.width(152),
                            ),
                            SizedBox(
                              width: ResponsiveHelper.width(152),
                              child: CustomText(
                                left: ResponsiveHelper.spacing(10),
                                text:
                                "${data?.firstName ?? " "} ${data?.lastName}",
                                color: AppColors.dark400,
                                fontSize: ResponsiveHelper.fontSize(19),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
      }
    });
  }
}