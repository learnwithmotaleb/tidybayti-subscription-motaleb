import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tidybayte/app/data/platform/platform_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {super.key,
      this.maxLines,
      this.textAlign = TextAlign.center,
      this.left = 0,
      this.right = 0,
      this.top = 0,
      this.bottom = 0,
      this.fontSize = 12,
      this.fontWeight = FontWeight.w300,
      this.color = AppColors.dark400,
      required this.text,
      this.overflow = TextOverflow.ellipsis,
      this.decoration, this.decorationColor
      // this.decoration = TextDecoration.none,
      });

  final double left;
  final double right;
  final double top;
  final double bottom;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final TextDecoration? decoration;
  final Color? decorationColor;

  @override
  Widget build(BuildContext context) {
    // ✅ iOS-only fix for Apple review Guideline 4 (text cut off on iPad):
    // when a caller doesn't set `maxLines`, Flutter's text layout still
    // honors the default `TextOverflow.ellipsis` as if maxLines were 1,
    // silently truncating text that was only ever meant to wrap. Scoped to
    // iOS only so Android (already live on Play Store) is not affected.
    final effectiveOverflow = (maxLines == null && PlatformHelper.isIOS)
        ? TextOverflow.visible
        : overflow;

    return Padding(
      padding: EdgeInsets.only(
          left: left.w, right: right.w, top: top.h, bottom: bottom.h),
      child: Text(
        textAlign: textAlign,
        text,
        maxLines: maxLines,
        overflow: effectiveOverflow,
        style: GoogleFonts.jost(
          fontSize: fontSize.sp,
          fontWeight: fontWeight,
          color: color,
          decoration: decoration,
          decorationColor:decorationColor?? AppColors.blue,
          decorationThickness: 2,
        ),
      ),
    );
  }
}
