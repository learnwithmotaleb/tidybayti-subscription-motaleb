import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/recipe_controller/recipe_controller.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/global_alart/global_alart.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/utils/app_images/app_images.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_recipe_card/custom_recipe_card.dart';
import 'package:tidybayte/app/view/components/custom_text_field/custom_text_field.dart';
import 'package:tidybayte/app/view/components/no_internet_screen/no_internet_screen.dart';

import '../../../../../data/service/api_url.dart';

class MyRecipeScreen extends StatefulWidget {
  const MyRecipeScreen({super.key});

  @override
  State<MyRecipeScreen> createState() => _MyRecipeScreenState();
}

class _MyRecipeScreenState extends State<MyRecipeScreen> {
  final RecipeController recipeController = Get.find<RecipeController>();

  @override
  void initState() {
    super.initState();
    // Clear previous favorite status when entering the screen
    recipeController.clearFavoriteStatus();
    // Load recipes
    recipeController.getMyRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
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
                      title: AppStrings.myRecipe.tr,
                      onBack: () {
                        Get.back();
                      },
                    ),

                    ///=============================== Search ========================
                    Padding(
                      padding: ResponsiveHelper.symmetric(horizontal: 20),
                      child: CustomTextField(
                        onFieldSubmitted: (value) {
                          recipeController.searchRecipe(recipeName: value);
                        },
                        hintText: AppStrings.search.tr,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        fillColor: Colors.white,
                        fieldBorderColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)),
                    const Divider(color: AppColors.blue500),
                    SizedBox(height:ResponsiveHelper.spacing(16)),

                    Expanded(
                      child: Padding(
                        padding: ResponsiveHelper.symmetric(horizontal: 20),
                        child: Obx(() {
                          switch (recipeController.rxRequestStatus.value) {
                            case Status.loading:
                              return const Center(child: CustomLoader());

                            case Status.internetError:
                              return Center(
                                child: NoInternetScreen(
                                  onTap: () {
                                    recipeController.getMyRecipe();
                                  },
                                ),
                              );

                            case Status.error:
                              return Center(
                                child: Text(AppStrings.errorLoadingRecipes.tr),
                              );

                            case Status.completed:
                              final recipes = recipeController
                                      .myRecipeData.value.recipeWithFavorite ??
                                  [];

                              if (recipes.isEmpty) {
                                return Center(
                                  child: Text(
                                    AppStrings.noRecipeFound.tr,
                                    style: TextStyle(
                                      fontSize:ResponsiveHelper.fontSize(16),
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                itemCount: recipes.length,
                                itemBuilder: (context, index) {
                                  final data = recipes[index];

                                  // Get or initialize favorite status for this recipe
                                  final favoriteStatus =
                                      recipeController.getFavoriteStatus(
                                          data.id ?? "",
                                          data.isFavorite ?? false);

                                  return GestureDetector(
                                    onTap: () {
                                      Get.toNamed(AppRoutes.myRecipeDetails,
                                          arguments: data.id);
                                    },
                                    child: CustomRecipeCard(
                                      recipeId: data.id ?? "",
                                      title: data.recipeName ??
                                          AppStrings.untitledRecipe.tr,
                                      cuisine: data.description ?? "",
                                      cookTime: data.cookingTime ?? "N/A",
                                      imageUrl:
                                          "${ApiUrl.networkUrl}${data.recipeImage ?? ""}",
                                      isFavorite: favoriteStatus,
                                      onFavorite: () => recipeController
                                          .toggleFavorite(data.id ?? ""),
                                      isDelete: true,
                                      onDelete: () {
                                        GlobalAlert.showDeleteDialog(context,
                                            () {
                                          recipeController.removeRecipe(
                                              recipeId: data.id ?? "");
                                        }, AppStrings.removeMyRecipe.tr);
                                      },
                                    ),
                                  );
                                },
                              );
                          }
                        }),
                      ),
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
