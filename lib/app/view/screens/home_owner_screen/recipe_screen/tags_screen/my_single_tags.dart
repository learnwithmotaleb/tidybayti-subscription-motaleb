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

class MySingleTags extends StatefulWidget {
  const MySingleTags({super.key});

  @override
  State<MySingleTags> createState() => _MySingleTagsState();
}

class _MySingleTagsState extends State<MySingleTags> {
  final RecipeController recipeController = Get.find<RecipeController>();
  final args = Get.arguments as Map<String, dynamic>;
  late final String tagName = args["tagName"];
  late final String title = args["title"];

  @override
  void initState() {
    recipeController.getSingleTags(tagText: tagName);
    super.initState();
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
                    /// **Menu Title**
                    CustomMenuAppbar(
                      title: title,
                      onBack: () {
                        Get.back();
                      },
                    ),

                    /// **Recipe List or Loader**
                    Expanded(
                      child: Padding(
                        padding: ResponsiveHelper.symmetric(horizontal: 20),
                        child: Obx(() {
                          switch (recipeController.rxRequestStatus.value) {
                            case Status.loading:
                              return const Center(
                                child: CustomLoader(), // ✅ Loader now centered
                              );

                            case Status.internetError:
                              return Center(
                                child: NoInternetScreen(
                                  onTap: () {
                                    recipeController.getSingleTags(
                                        tagText: tagName);
                                  },
                                ),
                              );

                            case Status.error:
                              return Center(
                                child: GeneralErrorScreen(
                                  onTap: () {
                                    recipeController.getSingleTags(
                                        tagText: tagName);
                                  },
                                ),
                              );

                            case Status.completed:
                              final recipes = recipeController
                                      .singleTags.value.recipeWithFavorite ??
                                  [];

                              if (recipes.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding:
                                        ResponsiveHelper.symmetric(vertical: 80),
                                    child: Text(
                                      AppStrings.noRecipeFound.tr,
                                      style: TextStyle(
                                        fontSize:
                                        ResponsiveHelper.fontSize(18), // ✅ Slightly bigger font
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                padding: EdgeInsets.only(top:ResponsiveHelper.height(10)),
                                itemCount: recipes.length,
                                itemBuilder: (context, index) {
                                  final data = recipes[index];
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
                                      title:
                                          data.recipeName ?? "Untitled Recipe",
                                      cuisine: data.description ?? "",
                                      cookTime: data.cookingTime ?? "N/A",
                                      imageUrl:
                                          "${ApiUrl.networkUrl}${data.recipeImage ?? ""}",
                                      recipeId: '',
                                      isFavorite: favoriteStatus,
                                      onFavorite: () => recipeController
                                          .toggleFavorite(data.id ?? ""),
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
