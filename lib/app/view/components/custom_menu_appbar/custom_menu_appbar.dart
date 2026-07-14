import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

class CustomMenuAppbar extends StatelessWidget {
  final String title;
  final String? backIcon;
  final VoidCallback? onBack;
  final bool? isEdit;
  final bool? download;
  final bool? isRemove;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final VoidCallback? onDownload;
  final Color? removeColor;
  final EdgeInsetsGeometry?padding;

  const CustomMenuAppbar({
    super.key,
    required this.title,
    this.backIcon = AppIcons.back,
    this.onBack,
    this.isEdit,
    this.onTap,
    this.download,
    this.onDownload,
    this.isRemove,
    this.onRemove,
    this.removeColor = Colors.grey, this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:padding?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: SizedBox(
        height: 48.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// 🔹 Back button (LEFT)
            if (backIcon != null)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                ),
              ),

            /// 🔹 CENTER TITLE (always centered)
            CustomText(
              textAlign: TextAlign.center,
              text: title,
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: AppColors.blue900,
            ),

            /// 🔹 Right actions
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isEdit == true)
                    GestureDetector(
                      onTap: onTap,
                      child: const CustomImage(imageSrc: AppIcons.edit),
                    ),
                  if (isEdit == true) SizedBox(width: 16.w),

                  if (isRemove == true)
                    GestureDetector(
                      onTap: onRemove,
                      child: Icon(
                        Icons.delete,
                        color: removeColor,
                      ),
                    ),

                  if (download == true)
                    GestureDetector(
                      onTap: onDownload,
                      child: const CustomImage(imageSrc: AppIcons.download),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
