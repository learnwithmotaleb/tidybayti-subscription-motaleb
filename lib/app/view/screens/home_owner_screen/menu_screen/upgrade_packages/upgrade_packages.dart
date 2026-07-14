import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

class UpgradePackages extends StatelessWidget {
  UpgradePackages({super.key});

  final List<String> listPackages = [
    AppStrings.freeDays.tr,
    AppStrings.inviteUnlimited.tr,
    AppStrings.assignTasksTo.tr,
    AppStrings.masterYourCleaningSchedule.tr,
    AppStrings.manageMultiplePlaces.tr
  ];

  final List<String> monthly = [
    AppStrings.freeDays.tr,
    AppStrings.inviteUnlimited.tr,
    AppStrings.assignTasksTo.tr,
    AppStrings.masterYourCleaningSchedule.tr,
    AppStrings.manageMultiplePlaces.tr
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xCCE8F3FA), // First color (with opacity)
                Color(0xFFB5D8EE),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                ///=============================== Upgrade Packages ========================
                CustomMenuAppbar(
                  title: AppStrings.subscription.tr,
                  onBack: () {
                    Get.back();
                  },
                ),

                ///=============================== Premium Pro ========================
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildPackageCard(
                          context: context,
                          packageTitle: 'yearly',
                          price: AppStrings.yearlyPackage.tr,
                          listPackages: listPackages,
                          onTap: () {},
                          isFeatured: true,
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(20),),

                        ///=============================== Monthly ========================
                        _buildPackageCard(
                          context: context,
                          packageTitle: AppStrings.monthly,
                          price: AppStrings.monthlyPackage,
                          listPackages: monthly,
                          onTap: () {},
                        ),
                        SizedBox(height: ResponsiveHelper.spacing(20),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Reusable method to build a package card
  Widget _buildPackageCard({
    required BuildContext context,
    required String packageTitle,
    required String price,
    required List<String> listPackages,
    required VoidCallback onTap,
    bool isFeatured = false, // NEW PARAMETER
  }) {
    return Padding(
      padding:  ResponsiveHelper.symmetric(horizontal: 21),
      child: Container(
        decoration: BoxDecoration(
          gradient: isFeatured
              ? const LinearGradient(
                  colors: [
                    Color(0xFFFFF4D2), // light gold
                    Color(0xFFFFE7A0), // deep gold
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(16),),
          border: Border.all(
            color: isFeatured ? Colors.amber.shade700 : AppColors.blue100,
            width: isFeatured ? 2.5 : 1,
          ),
          boxShadow: isFeatured
              ? [
                  BoxShadow(
                    color: Colors.amber.shade200.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
          color: !isFeatured ? AppColors.blue100 : null,
        ),
        padding:  ResponsiveHelper.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ⭐ Featured Badge
            if (isFeatured)
              Container(
                padding:
                     ResponsiveHelper.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade700,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12),),
                ),
                child:  Text(
                  "Best Value",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveHelper.fontSize(12),
                  ),
                ),
              ),

             SizedBox(height: ResponsiveHelper.spacing(16),),

            CustomText(
              text: packageTitle,
              fontWeight: FontWeight.w700,
              fontSize: ResponsiveHelper.fontSize(16),
              color: isFeatured ? Colors.amber.shade900 : AppColors.red,
            ),
            CustomText(
              top: ResponsiveHelper.spacing(8),
              text: price,
              fontWeight: FontWeight.w800,
              fontSize: ResponsiveHelper.fontSize(24),
              color: isFeatured ? Colors.black87 : AppColors.bhdColor,
              bottom: ResponsiveHelper.spacing(16),
            ),
            _buildPackageList(listPackages),
            SizedBox(height: ResponsiveHelper.spacing(16),),
            CustomButton(
              onTap: onTap,
              fillColor: isFeatured ? Colors.amber.shade700 : AppColors.light50,
              title: AppStrings.buyNow.tr,
              textColor: isFeatured ? Colors.white : AppColors.black,
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable method to build a list of package features
  Widget _buildPackageList(List<String> listPackages) {
    return Column(
      children: List.generate(listPackages.length, (index) {
        return Column(
          children: [
            Row(
              children: [
                const CustomImage(imageSrc: AppIcons.premium),
                SizedBox(width: ResponsiveHelper.spacing(5),),
                CustomText(
                  text: listPackages[index],
                  fontWeight: FontWeight.w400,
                  fontSize: ResponsiveHelper.fontSize(16),
                  color: AppColors.dark300,
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.spacing(10),),
          ],
        );
      }),
    );
  }
}
