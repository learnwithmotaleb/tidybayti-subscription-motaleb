import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/data/platform/platform_helper.dart';
import 'package:tidybayte/app/data/subscription/ios_subscriptions.dart';
import 'package:tidybayte/app/data/subscription/subscription_controller.dart';
import 'package:tidybayte/app/data/subscription/subscription_service.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

/// Shows the user's real, live subscription status (wired to
/// [SubscriptionController]) instead of the previous hardcoded mock data.
class MyPlanScreen extends StatelessWidget {
  MyPlanScreen({super.key});

  final SubscriptionController subController =
      Get.find<SubscriptionController>();

  final List<String> listPackages = [
    AppStrings.inviteUnlimited,
    AppStrings.assignTasksTo,
    AppStrings.masterYourCleaningSchedule,
    AppStrings.manageMultiplePlaces,
  ];

  bool _isYearlyActive(String activeProductId) {
    return PlatformHelper.isIOS
        ? activeProductId == IosSubscriptionService.yearlyProductId
        : activeProductId == SubscriptionService.yearlyProductId;
  }

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

                  ///=============================== Plan Card (live data) ========================
                  Obx(() {
                    final isPurchased = subController.isPurchased.value;
                    final isYearly =
                        _isYearlyActive(subController.activeProductId.value);
                    final price = isYearly
                        ? subController.yearlyPrice.value
                        : subController.monthlyPrice.value;

                    if (!isPurchased) {
                      return _buildFreePlanCard(context);
                    }

                    return _buildPackageCard(
                      context: context,
                      packageTitle: AppStrings.premium,
                      planName:
                          isYearly ? AppStrings.yearly.tr : AppStrings.monthly.tr,
                      price: price.trim().isNotEmpty ? price : '',
                      listPackages: listPackages,
                      onManageTap: subController.cancelSubscription,
                      onChangePlanTap: () => Get.toNamed(
                        AppRoutes.subscriptionOnboardingScreen,
                        arguments: {'isOnboarding': false, 'isFreeEnd': false},
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFreePlanCard(BuildContext context) {
    return Padding(
      padding: ResponsiveHelper.symmetric(horizontal: 21),
      child: Container(
        width: double.infinity,
        padding: ResponsiveHelper.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(
          color: AppColors.blue100,
          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "You're on the Free plan",
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveHelper.fontSize(18),
              color: AppColors.black,
            ),
            CustomText(
              top: ResponsiveHelper.spacing(8),
              text:
                  'Upgrade to Premium to unlock unlimited staff, budgeting, and more.',
              fontWeight: FontWeight.w400,
              fontSize: ResponsiveHelper.fontSize(15),
              color: AppColors.dark300,
              bottom: ResponsiveHelper.spacing(20),
            ),
            Center(
              child: CustomButton(
                width: ResponsiveHelper.width(
                  MediaQuery.of(context).size.width / 1.6,
                ),
                fillColor: AppColors.buttonRed,
                textColor: Colors.white,
                onTap: () => Get.toNamed(
                  AppRoutes.subscriptionOnboardingScreen,
                  arguments: {'isOnboarding': false, 'isFreeEnd': false},
                ),
                title: AppStrings.subscribeNow.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCard({
    required BuildContext context,
    required String packageTitle,
    required String planName,
    required String price,
    required List<String> listPackages,
    required VoidCallback onManageTap,
    required VoidCallback onChangePlanTap,
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
              text: planName,
              fontWeight: FontWeight.w600,
              fontSize: ResponsiveHelper.fontSize(20), // ✅
              color: AppColors.bhdColor,
              bottom: ResponsiveHelper.spacing(8),
            ),
            if (price.isNotEmpty)
              CustomText(
                text: price,
                fontWeight: FontWeight.w600,
                fontSize: ResponsiveHelper.fontSize(20), // ✅
                color: AppColors.bhdColor,
                bottom: ResponsiveHelper.spacing(16),    // ✅
              ),
            _buildPackageList(listPackages),
            SizedBox(height: ResponsiveHelper.spacing(16)),

            ///=========================== Manage Subscription Button ============================
            /// Opens the platform's native subscription management page
            /// (App Store / Play Store), same as the paywall's Cancel flow.
            Center(
              child: CustomButton(
                width: ResponsiveHelper.width(MediaQuery.of(context).size.width / 2), // ✅
                onTap: onManageTap,
                fillColor: AppColors.light50,
                title: 'Manage Subscription',
              ),
            ),
            SizedBox(height: ResponsiveHelper.spacing(16)),

            ///=========================== Change Plan Button ============================
            Center(
              child: CustomButton(
                width: ResponsiveHelper.width(MediaQuery.of(context).size.width / 2), // ✅
                onTap: onChangePlanTap,
                fillColor: AppColors.light50,
                title: AppStrings.buyNewPackages.tr,
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
