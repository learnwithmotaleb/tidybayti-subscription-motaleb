import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';

import '../custom_text/custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.height = 64,
    this.width = double.maxFinite,
    required this.onTap,
    this.title = '',
    this.marginVertical = 0,
    this.marginHorizontal = 0,
    this.fillColor,
    this.textColor = AppColors.dark400,
    this.isBorder = false,
    this.radius, this.fontSize,
  });

  final double height;
  final double? width;
  final Color? fillColor;
  final Color textColor;
  final VoidCallback onTap;
  final String title;
  final double marginVertical;
  final double marginHorizontal;
  final bool isBorder;
  final double?radius;
  final double?fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: marginVertical, horizontal: marginHorizontal),
        alignment: Alignment.center,
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: isBorder
              ? Border.all(
                  color: textColor,
                )
              : null,
          borderRadius: BorderRadius.circular(radius??8.r), // ✅ UPDATED
          color: fillColor,
        ),
        child: CustomText(
          fontSize:fontSize?? 24,
          fontWeight: FontWeight.w400,
          color: textColor,
          textAlign: TextAlign.center,
          text: title,
        ),
      ),
    );
  }
}
