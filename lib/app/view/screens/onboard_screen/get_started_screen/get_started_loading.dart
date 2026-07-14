import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_images/app_images.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';

class GetStartedLoadingScreen extends StatefulWidget {
  const GetStartedLoadingScreen({super.key});

  @override
  State<GetStartedLoadingScreen> createState() =>
      _GetStartedLoadingScreenState();
}

class _GetStartedLoadingScreenState extends State<GetStartedLoadingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onSwipe(DragEndDetails details) {
    if (details.primaryVelocity == null) return;

    // swipe right → previous page
    if (details.primaryVelocity! > 0) {
      if (_currentPage > 0) {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }

    // swipe left → next page
    if (details.primaryVelocity! < 0) {
      if (_currentPage < 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: Colors.white,

      /// 🔥 GLOBAL SWIPE DETECTOR (FULL SCREEN)
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragEnd: _onSwipe,

        child: Stack(
          children: [
            /// BACKGROUND IMAGE
            SizedBox(
              width: ResponsiveHelper.screenWidth,
              height: ResponsiveHelper.screenHeight * 0.91,
              child: Image.asset(
                AppImages.onBoardingLoadingBg,
                fit: BoxFit.cover,
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: ResponsiveHelper.spacing(20)),

                  /// LOGO
                  Image.asset(
                    AppImages.onBoardingHeading,
                    width: ResponsiveHelper.width(320),
                    height: ResponsiveHelper.height(100),
                    fit: BoxFit.contain,
                  ),

                  CustomText(
                    text: AppStrings.smartHouseholdManagement.tr,
                    fontSize: ResponsiveHelper.fontSize(18),
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),

                  const Spacer(),

                  /// PAGE VIEW (ONLY CARD SWAP)
                  ExpandablePageView(
                    controller: _pageController,
                    onPageChanged: (value) =>
                        setState(() => _currentPage = value),
                    children: [
                      _buildContentCard(
                        AppStrings.simplifyYourHome.tr,
                        AppStrings.spaceUpYourLife.tr,
                      ),
                      _buildContentCard(
                        AppStrings.smartManagement.tr,
                        AppStrings.timeForWhatMatters.tr,
                        isLastPage: true,
                      ),
                    ],
                  ),

                  SizedBox(height: ResponsiveHelper.spacing(20)),

                  /// DOTS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      2,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.spacing(4),
                        ),
                        height: ResponsiveHelper.spacing(8),
                        width: ResponsiveHelper.spacing(8),
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? const Color(0xFFB4C1D1)
                              : const Color(0xFFD9D9D9),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.spacing(15)),

                  /// TEXT ACTION
                  GestureDetector(
                    onTap: () {
                      if (_currentPage == 1) {
                        Get.offAllNamed(AppRoutes.getStartedScreen);
                      }
                    },
                    child: CustomText(
                      text: _currentPage == 0
                          ? AppStrings.swipeLeft.tr
                          : AppStrings.continues.tr,
                      fontSize: ResponsiveHelper.fontSize(18),
                      fontWeight: _currentPage == 0
                          ? FontWeight.w500
                          : FontWeight.bold,
                      color: _currentPage == 0
                          ? const Color(0xFF7F8C8D)
                          : AppColors.buttonRed,
                      decoration: _currentPage == 0
                          ? TextDecoration.none
                          : TextDecoration.underline,
                      decorationColor: _currentPage == 0
                          ? Colors.transparent
                          : const Color(0xFFD65C5C),
                    ),
                  ),

                  SizedBox(height: ResponsiveHelper.spacing(12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// CARD
  Widget _buildContentCard(String title, String subtitle,
      {bool isLastPage = false}) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(24),
      ),
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.spacing(18),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.borderRadius(24),
        ),
        border: Border.all(
          color: AppColors.buttonRed,
          width: ResponsiveHelper.borderWidth(1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: title,
            fontSize: ResponsiveHelper.fontSize(22),
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1A1F26),
          ),
          SizedBox(height: ResponsiveHelper.spacing(8)),
          CustomText(
            text: subtitle,
            fontSize: ResponsiveHelper.fontSize(22),
            fontWeight: FontWeight.w500,
            color: AppColors.buttonRed,
          ),
        ],
      ),
    );
  }
}