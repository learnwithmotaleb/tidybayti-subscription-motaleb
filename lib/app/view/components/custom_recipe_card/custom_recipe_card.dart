import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

class CustomRecipeCard extends StatelessWidget {
  final String recipeId;
  final String title;
  final String cuisine;
  final String cookTime;
  final String imageUrl;
  final bool isDelete;
  final VoidCallback? onDelete;
  final VoidCallback? onFavorite;
  final RxBool isFavorite;

  const CustomRecipeCard({
    super.key,
    required this.recipeId,
    required this.title,
    required this.cuisine,
    required this.cookTime,
    required this.imageUrl,
    required this.isFavorite,
    this.onDelete,
    this.isDelete = false,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
            child: CustomNetworkImage(
              imageUrl: imageUrl,
              height: 65.h,
              width: 67.w,
            ),
          ),
          SizedBox(width: 10.w), // Space between image and text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        top: 10,
                        textAlign: TextAlign.start,
                        text: title,
                        color: AppColors.dark400,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),

                    // Favorite Button (Reactive)
                    // CustomRecipeCard এ Obx এর মধ্যে:
                    Obx(() => IconButton(
                          icon: isFavorite.value
                              ? const Icon(Icons.favorite,
                                  color: Colors.red, size: 24)
                              : const Icon(Icons.favorite_border,
                                  color: Colors.black, size: 24),
                          onPressed: () {
                            if (onFavorite != null) onFavorite!();
                          },
                        )),

                    // Delete Button (Only if `isDelete` is true)
                    if (isDelete)
                      GestureDetector(
                        onTap: onDelete,
                        child: const CustomImage(
                          imageSrc: AppIcons.delete,
                          imageType: ImageType.svg,
                          imageColor: AppColors.dark400,
                        ),
                      ),
                    SizedBox(width: 10.w),
                  ],
                ),
                CustomText(
                  textAlign: TextAlign.start,
                  text: cuisine,
                  color: AppColors.dark300,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                CustomText(
                  textAlign: TextAlign.start,
                  text: '${AppStrings.cookingTimes.tr} $cookTime',
                  color: AppColors.dark300,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
