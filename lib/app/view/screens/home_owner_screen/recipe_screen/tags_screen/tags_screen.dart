import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/recipe_controller/recipe_controller.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';

import 'package:tidybayte/app/utils/app_strings/app_strings.dart';

import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';

import 'package:tidybayte/app/view/components/tags_card/tags_card.dart';

class TagsScreen extends StatelessWidget {
  TagsScreen({super.key});

  final RecipeController recipeController = Get.find<RecipeController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        // bottomNavigationBar: const NavBar(currentIndex: 4),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xCCE8F3FA), // First color (with opacity)
                Color(0xFFB5D8EE),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              ///=============================== Menu Title ========================
              Padding(
                padding: EdgeInsets.only(top: ResponsiveHelper.padding(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomMenuAppbar(
                      title: AppStrings.tags.tr,
                      onBack: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),

              ///=============================== Menu Items ========================
              Expanded(
                child: ListView(
                  padding: ResponsiveHelper.symmetric(horizontal: 20),
                  children: [
                    SizedBox(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: recipeController.tags.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.mySingleTags,
                                arguments: {
                                  "tagName": recipeController.tags[index]
                                      ["key"],
                                  "title": recipeController.tags[index]
                                      ["title"],
                                },
                              );
                            },
                            child: TagsCard(
                              title: recipeController.tags[index]['title']!,
                              imageUrl: recipeController.tags[index]
                                  ['imageUrl']!,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
