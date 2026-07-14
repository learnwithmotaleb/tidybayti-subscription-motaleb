import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/screens/onboard_screen/models/package_item.dart';

class FreeServiceNewScreen extends StatelessWidget {
  FreeServiceNewScreen({super.key});

  List<PackageItem> get listPackages => [
    PackageItem(
        text: AppStrings.manageMultipleHouseholds.tr,
        icon: AppIcons.home),
    PackageItem(
        text: AppStrings.addUnlimitedStaff.tr,
        icon: AppIcons.group),
    PackageItem(
        text: AppStrings.assignTrackTasks.tr,
        icon: AppIcons.assignment),
    PackageItem(
        text: AppStrings.guidedCleaningRoutines.tr,
        icon: AppIcons.clean),
    PackageItem(
        text: AppStrings.planHouseholdBudget.tr,
        icon: AppIcons.calculator),
    PackageItem(
        text: AppStrings.smartShoppingLists.tr,
        icon: AppIcons.listShopping),
    PackageItem(
        text: AppStrings.saveFavoriteRecipes.tr,
        icon: AppIcons.recipe),
  ];

  final List<String> monthly = [
    AppStrings.freeDays.tr,
    AppStrings.inviteUnlimited.tr,
    AppStrings.assignTasksTo.tr,
    AppStrings.masterYourCleaningSchedule.tr,
    AppStrings.manageMultiplePlaces.tr,
  ];

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.padding(16),
            vertical: ResponsiveHelper.spacing(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ResponsiveHelper.spacing(56)),

              /// Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: AppStrings.youHaveSevenDays,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: ResponsiveHelper.fontSize(20),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              SizedBox(height: ResponsiveHelper.spacing(8)),
              Divider(color: Colors.grey.shade300),

              CustomText(
                textAlign: TextAlign.start,
                text: AppStrings.congratulations,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w400,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                fontSize: ResponsiveHelper.fontSize(20),
              ),

              SizedBox(height: ResponsiveHelper.spacing(16)),

              /// Our Packages
              CustomText(
                text: AppStrings.ourSubscriptionPackages,
                color: AppColors.black,
                fontWeight: FontWeight.w400,
                fontSize: ResponsiveHelper.fontSize(20),
              ),
              SizedBox(height: ResponsiveHelper.spacing(16)),

              /// 12 Monthly
              _buildPackageCard(
                isMonth: true,
                context: context,
                packageTitle: AppStrings.premium,
                monthPackage: AppStrings.twelveMonthPackage,
                price: AppStrings.bhd3,
                onTap: () {},
              ),

              SizedBox(height: ResponsiveHelper.spacing(20)),

              /// 1 Monthly
              _buildPackageCard(
                isMonth: true,
                context: context,
                packageTitle: AppStrings.premiumPro,
                monthPackage: AppStrings.oneMonthsPackage,
                onTap: () {},
                price: AppStrings.bhd4,
              ),

              SizedBox(height: ResponsiveHelper.spacing(18)),
              SizedBox(height: ResponsiveHelper.spacing(8)),

              _buildPackageList(listPackages: listPackages),

              SizedBox(height: ResponsiveHelper.spacing(48)),

              /// Button
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(28),
                ),
                child: CustomButton(
                  onTap: () {
                    Get.toNamed(AppRoutes.homeScreen);
                  },
                  fillColor: AppColors.buttonRed,
                  title: AppStrings.continues,
                  textColor: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(26),
                  radius: ResponsiveHelper.borderRadius(16),
                ),
              ),

              SizedBox(height: ResponsiveHelper.spacing(18)),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageCard({
    required BuildContext context,
    required String packageTitle,
    required String monthPackage,
    required String price,
    required VoidCallback onTap,
    bool isFeatured = false,
    bool isMonth = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(16),
        ),
        border: Border.all(
          color: isFeatured ? AppColors.buttonRed : AppColors.cardBlueAccent,
          width: ResponsiveHelper.borderWidth(1),
        ),
        color: AppColors.blue100,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(18),
        vertical: ResponsiveHelper.spacing(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ResponsiveHelper.spacing(4)),
              CustomText(
                text: packageTitle,
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveHelper.fontSize(24),
                color: AppColors.red,
              ),
              CustomText(
                text: monthPackage,
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveHelper.fontSize(18),
                color: AppColors.black,
              ),
              CustomText(
                text: price,
                fontWeight: FontWeight.w400,
                fontSize: ResponsiveHelper.fontSize(18),
                color: Colors.grey.shade600,
                bottom: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }





  /// ================= LIST =================
  Widget _buildPackageList({required List<PackageItem> listPackages}) {
    return Column(
      children: List.generate(listPackages.length, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: ResponsiveHelper.spacing(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: ResponsiveHelper.spacing(34),
                child: Center(
                  child: CustomImage(
                    imageSrc: listPackages[index].icon,
                    imageType: ImageType.png,
                    imageColor: AppColors.englishText,
                  ),
                ),
              ),
              SizedBox(width: ResponsiveHelper.spacing(8)),
              Expanded(
                child: CustomText(
                  text: listPackages[index].text,
                  fontWeight: FontWeight.w400,
                  fontSize: ResponsiveHelper.fontSize(18),
                  color: AppColors.dark300,
                  textAlign: TextAlign.left, // 👈 এটা add করুন
                ),
              ),
            ],
          ),
        );
      }),
    );
  }


}