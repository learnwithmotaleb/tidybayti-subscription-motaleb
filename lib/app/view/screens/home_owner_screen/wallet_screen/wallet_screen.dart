import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/components/nav_bar/nav_bar.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/home_screen/home_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/wallet_screen/wallet_overview_screen.dart';
import 'wallet_budget_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int selectedTabIndex = 0;

  final List<Widget> screens = [
    WalletBudgetScreen(),
    const WalletOverviewScreen(),
  ];

  final List<String> schedule = [AppStrings.budget.tr, AppStrings.overview.tr];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.off(() => const HomeScreen());
        return false;
      },
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          bottomNavigationBar: const NavBar(currentIndex: 2),
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
              child: Column(  // ✅ SingleChildScrollView সরিয়ে Column
                children: [
                  ///=============================== Wallet Appbar ========================
                  CustomMenuAppbar(
                    title: AppStrings.wallet.tr,
                    onBack: () {
                      Get.off(() => const HomeScreen());
                    },
                    download: false,
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(20)),

                  ///=============================== Tab Switching ========================
                  Row(
                    children: List.generate(
                      schedule.length,
                          (index) => Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedTabIndex = index;
                            });
                          },
                          child: Container(
                            padding: ResponsiveHelper.symmetric(
                                vertical: 10, horizontal: 28),
                            decoration: BoxDecoration(
                              color: AppColors.light50,
                              border: Border(
                                bottom: selectedTabIndex == index
                                    ? BorderSide(
                                  color: AppColors.blue900,
                                  width: ResponsiveHelper.width(4),
                                )
                                    : BorderSide(
                                  color: AppColors.blue50,
                                  width: ResponsiveHelper.width(4),
                                ),
                              ),
                            ),
                            child: CustomText(
                              text: schedule[index],
                              fontWeight: FontWeight.w500,
                              fontSize: ResponsiveHelper.fontSize(18),
                              color: AppColors.blue900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(20)),

                  ///=============================== Selected Screen ========================
                  Expanded(  // ✅ SizedBox + SingleChildScrollView সরিয়ে Expanded
                    child: screens[selectedTabIndex],
                  ),
                ],
              ),
            ),
          ),

          ///==================================✅✅ createBudgets Button ✅✅=======================
          floatingActionButton: selectedTabIndex == 0
              ? Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(4)),
            child: CustomButton(
              width: MediaQuery.of(context).size.width / 1.2,
              onTap: () {
                Get.toNamed(AppRoutes.createBudgetScreen);
              },
              fillColor: Colors.white,
              title: AppStrings.createBudgets.tr,
            ),
          )
              : const SizedBox(),
        ),
      ),
    );
  }
}