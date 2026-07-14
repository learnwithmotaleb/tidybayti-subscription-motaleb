import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/home_screen/home_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/menu_screen/menu_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/owner_nav/owner_nav_controller.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/recipe_screen/recipe_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/schedule_screen/schedule_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/wallet_screen/wallet_screen.dart';

class OwnerNavScreen extends StatelessWidget {
  const OwnerNavScreen({super.key});
  static const String routeName = '/OwnerNavScreen';

  @override
  Widget build(BuildContext context) {
    final OwnerNavController controller = Get.put(OwnerNavController());

    final List<Widget> pages = [
      const HomeScreen(),
      const ScheduleScreen(),
      const WalletScreen(),
      const RecipeScreen(),
      const MenuScreen(),
    ];

    final List<IconData> icons = const [
      Icons.home_outlined,
      Icons.calendar_today_outlined,
      Icons.account_balance_wallet_outlined,
      Icons.restaurant_menu_outlined,
      Icons.menu_outlined,
    ];

    final List<IconData> selectedIcons = const [
      Icons.home,
      Icons.calendar_today,
      Icons.account_balance_wallet,
      Icons.restaurant_menu,
      Icons.menu,
    ];

    final List<String> labels = const [
      'Home',
      'Schedule',
      'Wallet',
      'Recipe',
      'Menu',
    ];

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Obx(() {
          print('📍 Current Index: ${controller.currentIndex.value}');
          return SafeArea(
            bottom: false,
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
              },
              child: IndexedStack(
                index: controller.currentIndex.value,
                children: pages,
              ),
            ),
          );
        }),
        bottomNavigationBar: Obx(() {
          final currentIndex = controller.currentIndex.value;
          return NavigationBar(
            backgroundColor: AppColors.primary,
            indicatorColor: Colors.green.withOpacity(0.3),
            surfaceTintColor: Colors.transparent,
            elevation: 8,
            height: 70.h,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            selectedIndex: currentIndex,
            onDestinationSelected: (int index) {
              print('✅ Tapped nav icon: $index');
              controller.setIndex(index);
            },
            destinations: List.generate(
              pages.length,
                  (index) => NavigationDestination(
                icon: Icon(
                  icons[index],
                  size: ResponsiveHelper.iconSize(24),
                ),
                selectedIcon: Icon(
                  selectedIcons[index],
                  size:ResponsiveHelper.iconSize(24),
                ),
                label: labels[index],
              ),
            ),
          );
        }),
      ),
    );
  }
}