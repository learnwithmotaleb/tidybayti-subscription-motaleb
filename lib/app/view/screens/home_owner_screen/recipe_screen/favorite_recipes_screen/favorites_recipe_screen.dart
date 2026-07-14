import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/recipe_controller/recipe_controller.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/GenerelError/general_error.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/utils/app_images/app_images.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_recipe_card/custom_recipe_card.dart';
import 'package:tidybayte/app/view/components/no_internet_screen/no_internet_screen.dart';

class FavoritesRecipeScreen extends StatelessWidget {
  FavoritesRecipeScreen({super.key});

  final RecipeController recipeController = Get.find<RecipeController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        // bottomNavigationBar: const NavBar(currentIndex: 3),
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
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SafeArea(
                child: Column(
                  children: [
                    /// Menu Title
                    CustomMenuAppbar(
                      title: AppStrings.favoriteRecipes.tr,
                      onBack: () {
                        Get.back();
                      },
                    ),

                    /// **✅ Refreshable Favorite List with Obx()**
                    Expanded(
                      child: Obx(() {
                        switch (recipeController.rxRequestStatus.value) {
                          case Status.loading:
                            return const Center(child: CustomLoader());

                          case Status.internetError:
                            return NoInternetScreen(
                                onTap: recipeController.getMyRecipe);

                          case Status.error:
                            return GeneralErrorScreen(
                                onTap: recipeController.getMyRecipe);

                          case Status.completed:

                            /// **✅ Now `favoriteRecipes` updates dynamically**
                            final favoriteRecipes = recipeController
                                    .myRecipeData.value.recipeWithFavorite
                                    ?.where((recipe) => recipeController
                                        .getFavoriteStatus(recipe.id ?? "",
                                            recipe.isFavorite ?? false)
                                        .value)
                                    .toList() ??
                                [];

                            if (favoriteRecipes.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: ResponsiveHelper.symmetric(vertical: 20),
                                  child: Text(
                                    AppStrings.noFavoriteRecipes.tr,
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.fontSize(16),
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              padding: ResponsiveHelper.symmetric(
                                  horizontal: 16, vertical: 8),
                              itemCount: favoriteRecipes.length,
                              itemBuilder: (context, index) {
                                final data = favoriteRecipes[index];
                                final isFavorite =
                                    recipeController.getFavoriteStatus(
                                        data.id ?? "",
                                        data.isFavorite ?? false);

                                return GestureDetector(
                                  onTap: () {
                                    Get.toNamed(AppRoutes.myRecipeDetails,
                                        arguments: data.id);
                                  },
                                  child: CustomRecipeCard(
                                    onFavorite: () {
                                      recipeController
                                          .toggleFavorite(data.id ?? "");
                                      recipeController
                                          .update(); // ✅ Force UI refresh
                                    },
                                    title: data.recipeName ??
                                        AppStrings.untitledRecipe.tr,
                                    cuisine: data.description ?? "",
                                    cookTime: data.cookingTime ?? "N/A",
                                    imageUrl:
                                        "${ApiUrl.networkUrl}${data.recipeImage ?? ""}",
                                    recipeId: data.id ?? "",
                                    isFavorite: isFavorite,
                                  ),
                                );
                              },
                            );
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
