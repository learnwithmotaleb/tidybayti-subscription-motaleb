import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

class MyPlanScreen extends StatelessWidget {
  MyPlanScreen({super.key});

  final List<String> listPackages = [
    AppStrings.inviteUnlimited,
    AppStrings.assignTasksTo,
    AppStrings.masterYourCleaningSchedule,
    AppStrings.manageMultiplePlaces,
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
                Color(0xCCE8F3FA),
                Color(0xFFB5D8EE),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ///=============================== My Plan AppBar ========================
                  CustomMenuAppbar(
                    title: AppStrings.myPlan,
                    onBack: () {
                      Get.back();
                    },
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(20)),

                  ///=============================== Premium Plan Card ========================
                  _buildPackageCard(
                    context: context,
                    packageTitle: AppStrings.premium,
                    price: AppStrings.sixMonth,
                    listPackages: listPackages,
                    onAutoRenewTap: () {},
                    onRenewPlanTap: () {},
                    onBuyNewPackagesTap: () {},
                    bhd: 'BHD 60/Month',
                    expireDate: 'Expiry date :22 Feb 2024',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPackageCard({
    required BuildContext context,
    required String packageTitle,
    required String price,
    required String expireDate,
    required String bhd,
    required List<String> listPackages,
    required VoidCallback onAutoRenewTap,
    required VoidCallback onRenewPlanTap,
    required VoidCallback onBuyNewPackagesTap,
  }) {
    return Padding(
      padding: ResponsiveHelper.symmetric(horizontal: 21), // ✅
      child: Container(
        padding: ResponsiveHelper.symmetric(horizontal: 20, vertical: 30), // ✅
        decoration: BoxDecoration(
          color: AppColors.blue100,
          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)), // ✅
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: packageTitle,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveHelper.fontSize(14), // ✅
              color: AppColors.red,
            ),
            CustomText(
              top: ResponsiveHelper.spacing(8),        // ✅
              text: price,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveHelper.fontSize(20), // ✅
              color: AppColors.bhdColor,
              bottom: ResponsiveHelper.spacing(16),    // ✅
            ),
            CustomText(
              top: ResponsiveHelper.spacing(8),        // ✅
              text: bhd,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveHelper.fontSize(20), // ✅
              color: AppColors.bhdColor,
              bottom: ResponsiveHelper.spacing(16),    // ✅
            ),
            _buildPackageList(listPackages),
            CustomText(
              top: ResponsiveHelper.spacing(8),        // ✅
              text: expireDate,
              fontWeight: FontWeight.w400,
              fontSize: ResponsiveHelper.fontSize(14), // ✅
              color: AppColors.red,
              bottom: ResponsiveHelper.spacing(16),    // ✅
            ),
            SizedBox(height: ResponsiveHelper.spacing(16)),

            ///=========================== Auto-Renewal Button ============================
            Center(
              child: CustomButton(
                width: ResponsiveHelper.width(MediaQuery.of(context).size.width / 2), // ✅
                onTap: onAutoRenewTap,
                fillColor: AppColors.light50,
                title: AppStrings.autoRenewal,
              ),
            ),
            SizedBox(height: ResponsiveHelper.spacing(16)),

            ///=========================== Renew Plan Button ============================
            Center(
              child: CustomButton(
                width: ResponsiveHelper.width(MediaQuery.of(context).size.width / 2), // ✅
                onTap: onRenewPlanTap,
                fillColor: AppColors.light50,
                title: AppStrings.reNewPlan,
              ),
            ),
            SizedBox(height: ResponsiveHelper.spacing(16)),

            ///=========================== Buy New Packages Button ============================
            Center(
              child: CustomButton(
                width: ResponsiveHelper.width(MediaQuery.of(context).size.width / 2), // ✅
                onTap: onBuyNewPackagesTap,
                fillColor: AppColors.light50,
                title: AppStrings.buyNewPackages,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageList(List<String> listPackages) {
    return Column(
      children: List.generate(listPackages.length, (index) {
        return Column(
          children: [
            Row(
              children: [
                const CustomImage(imageSrc: AppIcons.premium), // ✅ original এর মতোই
                SizedBox(width: ResponsiveHelper.spacing(5)),
                CustomText(
                  text: listPackages[index],
                  fontWeight: FontWeight.w400,
                  fontSize: ResponsiveHelper.fontSize(16),
                  color: AppColors.dark300,
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.spacing(10)),
          ],
        );
      }),
    );
  }
}