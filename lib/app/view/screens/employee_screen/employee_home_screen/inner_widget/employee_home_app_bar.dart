import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

class EmployeeHomeAppBar extends StatelessWidget {
  const EmployeeHomeAppBar({
    super.key,
    required this.scaffoldKey,
    required this.image,
    required this.name,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;

  final String image;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        color: const Color(0xffE8F3FA),
        margin: EdgeInsets.only(
          top:ResponsiveHelper.height(32),
        ),
        padding: ResponsiveHelper.symmetric(horizontal: 17, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///====================================Top Section================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ///==================== Profile image =====================
                    image.isEmpty
                        ? Icon(
                            Icons.person,
                            size: ResponsiveHelper.iconSize(60),
                          )
                        : CustomNetworkImage(
                            boxShape: BoxShape.circle,
                            imageUrl: image,
                            height: ResponsiveHelper.iconSize(60),
                            width: ResponsiveHelper.iconSize(60),
                          ),

                    SizedBox(
                      width:ResponsiveHelper.spacing(16),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: name,
                          fontWeight: FontWeight.w600,
                          color: AppColors.dark400,
                          fontSize:ResponsiveHelper.fontSize(16),
                        ),
                        CustomText(
                          text: AppStrings.welcome.tr,
                          fontWeight: FontWeight.w500,
                          color: AppColors.dark300,
                          fontSize: ResponsiveHelper.fontSize(16),
                        ),

                        ///=====================user name =======================
                      ],
                    )
                  ],
                ),
                SizedBox(
                  width: ResponsiveHelper.spacing(50),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.employeeNotificationScreen);
                  },
                  child:  CustomImage(
                    imageSrc: AppIcons.notification,
                    sizeHeight: ResponsiveHelper.iconSize(28),
                    imageType: ImageType.svg,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
