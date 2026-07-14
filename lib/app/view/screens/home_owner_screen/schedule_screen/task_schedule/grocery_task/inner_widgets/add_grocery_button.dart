import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import '../../../../../../../controller/owner_controller/grocery_controller/grocery_controller.dart';
import '../../../../../../../data/service/api_url.dart';
import '../add_grocery_task/add_grocery_task.dart';

class AddGroceryButton extends StatelessWidget {
  const AddGroceryButton({super.key});

  @override
  Widget build(BuildContext context) {


    final GroceryController controller = Get.find<GroceryController>();

    return GestureDetector(
      onTap: () async {
        final result = await Get.to(() => const AddGroceryTask());

        if (result == true) {
          print("🔄 AddGroceryTask returned true → updating Pending List");

          final GroceryController controller = Get.find<GroceryController>();

          controller.selectedTabIndex.value = 0;

          await Future.delayed(const Duration(milliseconds: 300));

          await controller.getMyGrocery(apiUrl: ApiUrl.getGroceryOngoing);
        }
      },
      child: Container(
        height: ResponsiveHelper.height(60),
        margin: EdgeInsets.all(ResponsiveHelper.padding(10)),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.padding(30),
        ),
        decoration: BoxDecoration(
          color: AppColors.blue50,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.borderRadius(8),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomImage(
              imageSrc: AppIcons.add,
              imageType: ImageType.svg,
              imageColor: AppColors.blue900,
            ),
            SizedBox(width: ResponsiveHelper.spacing(12)),
            CustomText(
              text: AppStrings.addShopping.tr,
              fontSize: ResponsiveHelper.fontSize(24),
              fontWeight: FontWeight.w400,
              color: AppColors.dark400,
            ),
          ],
        ),
      ),
    );
  }
}