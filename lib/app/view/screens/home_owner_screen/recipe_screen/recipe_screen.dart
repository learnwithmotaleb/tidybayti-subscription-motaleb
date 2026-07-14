import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/utils/app_images/app_images.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';

import 'package:tidybayte/app/view/components/custom_menu_item/custom_menu_item.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/components/nav_bar/nav_bar.dart';

import 'package:tidybayte/app/view/screens/home_owner_screen/home_screen/home_screen.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

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
          bottomNavigationBar: const NavBar(currentIndex: 3),
          body: Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  AppImages.recipeBacground,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50.h,
                      ),

                      /// Menu Title
                      CustomText(
                        text: AppStrings.recipe.tr,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: AppColors.dark500,
                      ),

                      const SizedBox(
                          height: 100), // Space between title and menu items

                      /// Menu Items
                      Expanded(
                        child: ListView(
                          padding:  ResponsiveHelper.all(16.0),
                          children: [
                            /// Add Recipe
                            CustomMenuItem(
                              image: AppIcons.add,
                              text: AppStrings.addRecipe.tr,
                              onTap: () {
                                Get.toNamed(AppRoutes.addRecipeScreen);
                              },
                            ),

                            /// My Recipe
                            CustomMenuItem(
                              image: AppIcons.myRecipe,
                              text: AppStrings.myRecipe.tr,
                              onTap: () {
                                Get.toNamed(AppRoutes.myRecipeScreen);
                              },
                            ),

                            /// Favorite Recipes
                            CustomMenuItem(
                              image: AppIcons.favorite,
                              text: AppStrings.favoriteRecipes.tr,
                              onTap: () {
                                Get.toNamed(AppRoutes.favoritesRecipeScreen);
                              },
                            ),

                            /// Tags
                            CustomMenuItem(
                              image: AppIcons.tags,
                              text: AppStrings.tags.tr,
                              onTap: () {
                                Get.toNamed(AppRoutes.tagsScreen);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
