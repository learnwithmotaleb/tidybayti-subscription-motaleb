import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

/*class RecipeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const RecipeButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(14.r),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      height: 64.h,
      width: MediaQuery.of(context).size.width,
      color: AppColors.blue50,
      child: GestureDetector(
        onTap: onPressed,
        child: CustomText(
          textAlign: TextAlign.center,
          text: text,
          fontWeight: FontWeight.w300,
          fontSize: 24,
          color: AppColors.dark500,
        ),
      ),
    );
  }
}*/
class RecipeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const RecipeButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(14.r),
      height: 64.h,
      width: MediaQuery.of(context).size.width,
      child: Material(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(12.r), // 🔵 fully rounded
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onPressed,
          child: Center(
            child: CustomText(
              textAlign: TextAlign.center,
              text: text,
              fontWeight: FontWeight.w300,
              fontSize: 24,
              color: AppColors.dark500,
            ),
          ),
        ),
      ),
    );
  }
}
