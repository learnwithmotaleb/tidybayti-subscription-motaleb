import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

class CustomMenuItem extends StatelessWidget {
  final String image;
  final String text;
  final VoidCallback onTap;

  const CustomMenuItem({
    super.key,
    required this.image,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 64.h,
        margin: EdgeInsets.all(10.r),
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Leading Icon with fixed size
            SizedBox(
              width: 24.w,  // Add this
              height: 24.h, // Add this
              child: CustomImage(
                imageSrc: image,
                imageType: ImageType.svg,
                imageColor: Colors.black,
              ),
            ),

            // Spacer between icon and text
            SizedBox(width: 16.w),

            // Text
            Expanded(
              child: CustomText(
                textAlign: TextAlign.start,
                text: text,
                fontWeight: FontWeight.w300,
                fontSize: 24,
                color: AppColors.dark300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}