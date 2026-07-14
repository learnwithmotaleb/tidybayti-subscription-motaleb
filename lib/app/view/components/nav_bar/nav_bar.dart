import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/home_screen/home_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/menu_screen/menu_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/recipe_screen/recipe_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/schedule_screen/schedule_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/wallet_screen/wallet_screen.dart';

// ✅ GLOBAL PERMANENT NavBar Controller - NEVER DELETED
class NavBarController extends GetxController {
  static NavBarController get instance {
    if (Get.isRegistered<NavBarController>()) {
      return Get.find<NavBarController>();
    } else {
      return Get.put(NavBarController(), permanent: true);
    }
  }

  final Rx<int> selectedIndex = 0.obs;

  void setIndex(int index) {
    selectedIndex.value = index;
  }
}

class NavBar extends StatelessWidget {
  final int currentIndex;

  const NavBar({required this.currentIndex, super.key});

  @override
  Widget build(BuildContext context) {
    // Get or create the permanent controller
    final navBarController = NavBarController.instance;

    // Always update currentIndex when NavBar rebuilds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navBarController.selectedIndex.value != currentIndex) {
        navBarController.setIndex(currentIndex);
      }
    });

    final List<String> unselectedIcon = [
      AppIcons.homeUnselected,
      AppIcons.scheduleUnselected,
      AppIcons.walletUnselected,
      AppIcons.recipeUnselected,
      AppIcons.menuUnselected,
    ];

    final List<String> selectedIcon = [
      AppIcons.homeSelected,
      AppIcons.scheduleSelected,
      AppIcons.walletSelected,
      AppIcons.recipeSelected,
      AppIcons.menuSelected,
    ];

    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        bottom: MediaQuery.of(context).padding.bottom, // dynamic safe area
        // top: 10.h, // add top padding manually
      ),
      color: AppColors.blue300,
      child: SizedBox(
        height: 54.h, // fixed height for your icons row
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            unselectedIcon.length,
            (index) => Obx(
              () => InkWell(
                onTap: () => _onTap(index),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: CustomImage(
                    imageSrc: navBarController.selectedIndex.value == index
                        ? selectedIcon[index]
                        : unselectedIcon[index],
                    imageType: ImageType.svg,
                    sizeHeight: 24.r, // icon stays large
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(int index) {
    final navBarController = NavBarController.instance;

    if (index != navBarController.selectedIndex.value) {
      navBarController.setIndex(index);

      switch (index) {
        case 0:
          Get.offAll(() => const HomeScreen());
          break;
        case 1:
          Get.offAll(() => const ScheduleScreen());
          break;
        case 2:
          Get.offAll(() => const WalletScreen());
          break;
        case 3:
          Get.offAll(() => const RecipeScreen());
          break;
        case 4:
          Get.offAll(() => const MenuScreen());
          break;
      }
    }
  }
}
