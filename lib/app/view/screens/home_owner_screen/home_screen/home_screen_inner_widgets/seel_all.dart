import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

class SeeAll extends StatelessWidget {
  const SeeAll({
    super.key, this.color,
  });

  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         CustomText(
          text: AppStrings.employees.tr,
          fontSize: ResponsiveHelper.fontSize(20),
          fontWeight: FontWeight.w500,
          color:color?? AppColors.black,
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.allEmployeeShow);
          },
          child:  CustomText(
            text: AppStrings.seeAll.tr,
            fontSize: ResponsiveHelper.fontSize(16),
            fontWeight: FontWeight.w500,
            color:color?? AppColors.black,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.black,

          ),
        ),
      ],
    );
  }
}