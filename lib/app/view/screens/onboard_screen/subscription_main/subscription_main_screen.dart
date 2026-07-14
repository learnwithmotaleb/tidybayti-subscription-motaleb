
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/data/subscription/subscription_controller.dart';
import 'package:tidybayte/app/data/subscription/subscription_service.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/screens/onboard_screen/models/package_item.dart';

class SubscriptionMainScreen extends StatefulWidget {
  final bool isOnboarding;
  final bool isFreeEnd;

  const SubscriptionMainScreen({
    super.key,
    required this.isOnboarding,
    this.isFreeEnd = false,
  });

  @override
  State<SubscriptionMainScreen> createState() =>
      _SubscriptionMainScreenState();
}

class _SubscriptionMainScreenState
    extends State<SubscriptionMainScreen> {
  static const int _yearlyPlanIndex = 0;
  static const int _monthlyPlanIndex = 1;
  final SubscriptionController _subController = Get.find<SubscriptionController>();


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

  int selectedPlanIndex = _yearlyPlanIndex;
  late final Worker _purchaseWorker;
  late final Worker _productWorker;

  @override
  void initState() {
    super.initState();
    _syncActivePlan();

    _purchaseWorker =
        ever(_subController.isPurchased, (_) => _syncActivePlan());
    _productWorker =
        ever(_subController.activeProductId, (_) => _syncActivePlan());
  }

  @override
  void dispose() {
    _purchaseWorker.dispose();
    _productWorker.dispose();
    super.dispose();
  }

  void _syncActivePlan() {
    if (!_subController.isPurchased.value) return;

    final productId = _subController.activeProductId.value;
    final newIndex = productId == SubscriptionService.monthlyProductId
        ? _monthlyPlanIndex
        : _yearlyPlanIndex;

    if (selectedPlanIndex != newIndex) {
      setState(() => selectedPlanIndex = newIndex);
    }
  }

  void selectPlan(int index) {
    setState(() => selectedPlanIndex = index);
  }

  bool _isYearlyActive(String activeProductId) {
    return activeProductId == SubscriptionService.yearlyProductId;
  }

  bool _isMonthlyActive(String activeProductId) {
    return activeProductId == SubscriptionService.monthlyProductId;
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: ResponsiveHelper.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ResponsiveHelper.spacing(16)),

              /// TOP BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!widget.isFreeEnd)
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios),
                    )
                  else
                    const SizedBox.shrink(),

                  Obx(() {
                    if (!_subController.isPurchased.value) return const SizedBox.shrink();
                    return GestureDetector(
                      onTap: () => Get.defaultDialog(
                        title: 'Cancel Subscription',
                        middleText: 'Continue Google Play Store ?',
                        textConfirm: 'Go to Play Store',
                        textCancel: 'Back',
                        confirmTextColor: Colors.white,
                        buttonColor: AppColors.buttonRed,
                        onConfirm: () {
                          Get.back();
                          _subController.cancelSubscription();
                        },
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.padding(18),
                          vertical: ResponsiveHelper.spacing(4),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.black,
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(6),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.fontSize(13),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }),


                ],
              ),

              SizedBox(height: ResponsiveHelper.spacing(4)),

              /// TITLE
              Center(
                child: CustomText(
                  text: AppStrings.chooseYourPlan.tr,
                  color: AppColors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: ResponsiveHelper.fontSize(24),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: ResponsiveHelper.spacing(8)),
              Divider(color: Colors.grey.shade300),

              Obx(() {
                if (!_subController.isPurchased.value) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: ResponsiveHelper.spacing(16),
                  ),
                  child: _buildActiveSubscriptionBanner(),
                );
              }),

              CustomText(
                text: AppStrings.plans.tr,
                color: AppColors.black,
                fontWeight: FontWeight.w400,
                fontSize: ResponsiveHelper.fontSize(24),
              ),

              CustomText(
                text: AppStrings.sameFeaturesChooseHowYouPay.tr,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w400,
                fontSize: ResponsiveHelper.fontSize(20),
              ),

              SizedBox(height: ResponsiveHelper.spacing(16)),

              Obx(() {
                final activeProductId = _subController.activeProductId.value;
                final isPurchased = _subController.isPurchased.value;

                return Column(
                  children: [
                    /// YEARLY
                    _buildPackageCard(
                      context: context,
                      packageTitle: AppStrings.yearly.tr,
                      price: AppStrings.yearlyPackage.tr,
                      isSelected: selectedPlanIndex == _yearlyPlanIndex,
                      isActivePlan:
                          isPurchased && _isYearlyActive(activeProductId),
                      isFeatured: true,
                      onTap: () => selectPlan(_yearlyPlanIndex),
                    ),

                    SizedBox(height: ResponsiveHelper.spacing(20)),

                    /// MONTHLY
                    _buildPackageCard(
                      context: context,
                      packageTitle: AppStrings.monthly.tr,
                      price: AppStrings.monthlyPackage.tr,
                      isSelected: selectedPlanIndex == _monthlyPlanIndex,
                      isActivePlan:
                          isPurchased && _isMonthlyActive(activeProductId),
                      onTap: () => selectPlan(_monthlyPlanIndex),
                    ),
                  ],
                );
              }),

              SizedBox(height: ResponsiveHelper.spacing(18)),

              CustomText(
                text: AppStrings.allPlansInclude.tr,
                color: AppColors.black,
                fontWeight: FontWeight.w400,
                fontSize: ResponsiveHelper.fontSize(20),
              ),

              SizedBox(height: ResponsiveHelper.spacing(8)),

              _buildPackageList(listPackages: listPackages),

              SizedBox(height: ResponsiveHelper.spacing(16)),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.padding(28),
                ),


                child: Column(
                  children: [
                    // Obx(() {
                    //   final isLoading = _subController.isLoading.value;
                    //   final isPurchased = _subController.isPurchased.value;
                    //
                    //   return CustomButton(
                    //     onTap: () {
                    //
                    //
                    //     //  _subController.testSubscriptionApi();
                    //
                    //       if (isLoading || isPurchased) return;
                    //
                    //       _subController.subscribe(
                    //         selectedPlanIndex == _yearlyPlanIndex,
                    //       );
                    //     },
                    //     fillColor:  AppColors.buttonRed,
                    //     title: isLoading
                    //         ? 'Loading...'
                    //         : isPurchased
                    //             ? AppStrings.subscriptionActive.tr
                    //             : AppStrings.subscribeNow.tr,
                    //     textColor: Colors.white,
                    //     fontSize: ResponsiveHelper.fontSize(26),
                    //     radius: ResponsiveHelper.borderRadius(16),
                    //   );
                    // }),


                    Obx(() {
                      final isLoading = _subController.isLoading.value;
                      final isPurchased = _subController.isPurchased.value;

                      return CustomButton(
                        onTap: () {
                          if (isLoading || isPurchased) return; // ✅ double tap + purchased guard
                          _subController.subscribe(
                            selectedPlanIndex == _yearlyPlanIndex,
                          );
                        },
                        fillColor: AppColors.buttonRed,
                        title: isLoading
                            ? 'Loading...'
                            : isPurchased
                            ? AppStrings.subscriptionActive.tr
                            : AppStrings.subscribeNow.tr,
                        textColor: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(26),
                        radius: ResponsiveHelper.borderRadius(16),
                      );
                    }),
                    SizedBox(height: ResponsiveHelper.spacing(16)),


                  ],
                ),

              ),

              SizedBox(height: ResponsiveHelper.spacing(18)),
            ],
          ),
        ),
      ),
    );
  }
///if active
  Widget _buildActiveSubscriptionBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(14),
        vertical: ResponsiveHelper.spacing(12),
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryBg,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(12),
        ),
        border: Border.all(color: AppColors.black),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppColors.black,
            size: ResponsiveHelper.fontSize(22),
          ),
          SizedBox(width: ResponsiveHelper.spacing(10)),
          Expanded(
            child: CustomText(
              text: AppStrings.youHaveActiveSubscription.tr,
              fontSize: ResponsiveHelper.fontSize(16),
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= PACKAGE CARD =================
  Widget _buildPackageCard({
    required BuildContext context,
    required String packageTitle,
    required String price,
    required VoidCallback onTap,
    required bool isSelected,
    bool isActivePlan = false,
    bool isFeatured = false,
  }) {
    final borderColor = isActivePlan
        ? AppColors.black
        : isSelected
            ? AppColors.buttonRed
            : AppColors.cardBlueAccent;

    return InkWell(
      borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(16)),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.padding(18),
          vertical: ResponsiveHelper.spacing(8),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(16)),
          border: Border.all(
            color: borderColor,
            width: isSelected || isActivePlan ? 2 : 1,
          ),
          color: isActivePlan
              ? AppColors.primaryBg
              : isSelected
                  ? AppColors.cardBlue
                  : AppColors.blue100,
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ResponsiveHelper.spacing(4)),
                CustomText(
                  text: packageTitle,
                  fontWeight: FontWeight.w400,
                  fontSize: ResponsiveHelper.fontSize(24),
                  color: AppColors.black,
                ),
                CustomText(
                  text: price,
                  fontWeight: FontWeight.w500,
                  fontSize: ResponsiveHelper.fontSize(18),
                  color: AppColors.black,
                ),
                CustomText(
                  text: isFeatured
                      ? AppStrings.billedAnnually.tr
                      : AppStrings.billedMonthly.tr,
                  fontWeight: FontWeight.w400,
                  fontSize: ResponsiveHelper.fontSize(18),
                  color: Colors.grey.shade600,
                ),
              ],
            ),

            const Spacer(),

            if (isActivePlan)
              _buildActivePlanBadge()
            else if (isFeatured)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.spacing(10),
                      vertical: ResponsiveHelper.spacing(4),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.buttonRed,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(6),
                      ),
                    ),
                    child: Text(
                      AppStrings.bestValue.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.fontSize(14),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(8)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.spacing(10),
                      vertical: ResponsiveHelper.spacing(4),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cardBlue,
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(6),
                      ),
                    ),
                    child: Text(
                      AppStrings.sevenDayFree.tr,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: ResponsiveHelper.fontSize(12),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivePlanBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.spacing(10),
        vertical: ResponsiveHelper.spacing(6),
      ),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(6),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified,
            color: Colors.white,
            size: ResponsiveHelper.fontSize(16),
          ),
          SizedBox(width: ResponsiveHelper.spacing(4)),
          Text(
            AppStrings.activePlan.tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.fontSize(14),
              fontWeight: FontWeight.w600,
            ),
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
