import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/recipe_controller/recipe_controller.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/GenerelError/general_error.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/components/no_internet_screen/no_internet_screen.dart';

class MyRecipeDetails extends StatefulWidget {
  const MyRecipeDetails({super.key});

  @override
  State<MyRecipeDetails> createState() => _MyRecipeDetailsState();
}

class _MyRecipeDetailsState extends State<MyRecipeDetails> {
  final String recipeId = Get.arguments;
  final RecipeController recipeController = Get.find<RecipeController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      recipeController.getRecipeSingle(recipeId: recipeId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
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
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveHelper.spacing(20), // ✅
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomMenuAppbar(
                  title: AppStrings.recipeDetails.tr,
                  onBack: () => Get.back(),
                  isEdit: true,
                  onTap: () {
                    final data = recipeController.recipeSingleData.value;
                    if (data.url == "url" || data.file == "pdf") {
                      Get.snackbar(
                        "Cannot Edit",
                        "URL and PDF recipes cannot be edited",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }
                    Get.toNamed(AppRoutes.addNewRecipe, arguments: {
                      "IsEdit": "true",
                      "recipeId": recipeId,
                      "recipeName": data.recipeName,
                      "cookingTime": data.cookingTime,
                      "description": data.description,
                      "ingredients": data.ingredients,
                      "step": data.steps,
                      "tag": data.tags,
                    });
                  },
                ),
                SizedBox(height: ResponsiveHelper.spacing(15)), // ✅
                Obx(() {
                  switch (recipeController.rxRequestStatus.value) {
                    case Status.loading:
                      return const CustomLoader();

                    case Status.internetError:
                      return NoInternetScreen(
                        onTap: () => recipeController.getRecipeSingle(
                            recipeId: recipeId),
                      );

                    case Status.error:
                      return GeneralErrorScreen(
                        onTap: () => recipeController.getRecipeSingle(
                            recipeId: recipeId),
                      );

                    case Status.completed:
                      var data = recipeController.recipeSingleData.value;

                      print("========== RECIPE DEBUG INFO ==========");
                      print("Recipe ID: ${data.id}");
                      print("Recipe Name: ${data.recipeName}");
                      print("Source: ${data.source}");
                      print("URL: ${data.url}");
                      print("File Path: ${data.file}");
                      print("======================================");

                      final bool isPdfRecipe = data.source == "file" &&
                          data.file != null &&
                          data.file!.isNotEmpty;
                      final bool isWebsiteRecipe = data.source == "website" &&
                          data.url != null &&
                          data.url!.isNotEmpty;

                      // ============ PDF RECIPE ============
                      if (isPdfRecipe) {
                        print("✅ Detected PDF Recipe (Server Upload)");
                        final pdfUrl =
                            "${ApiUrl.networkUrl}${data.file!.replaceAll('\\', '/')}";

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.padding(20), // ✅
                          ),
                          child: Column(
                            children: [
                              CustomNetworkImage(
                                imageUrl:
                                "${ApiUrl.networkUrl}${data.recipeImage ?? ""}",
                                height: ResponsiveHelper.height(191), // ✅
                                width: ResponsiveHelper.width(375),   // ✅
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(25)), // ✅
                              RecipeInfoRow(
                                label: "${AppStrings.recipeName.tr}:",
                                value: "${data.recipeName ?? " "}",
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(20)), // ✅
                              Text(
                                "PDF URL: $pdfUrl",
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.fontSize(12), // ✅
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(10)), // ✅
                              ElevatedButton.icon(
                                onPressed: () {
                                  print("🔴 PDF Button Pressed!");
                                  print("🔴 PDF URL: $pdfUrl");
                                  print(
                                      "🔴 Route: ${AppRoutes.pdfViewerScreen}");
                                  Get.toNamed(
                                    AppRoutes.pdfViewerScreen,
                                    arguments: {
                                      "pdfUrl": pdfUrl,
                                      "title": data.recipeName,
                                    },
                                  );
                                },
                                icon: const Icon(Icons.picture_as_pdf),
                                label: const Text("Open PDF"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.blue900,
                                  foregroundColor: Colors.white,
                                  padding: ResponsiveHelper.symmetric(
                                    horizontal: 30,
                                    vertical: 15,
                                  ), // ✅
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // ============ WEBSITE RECIPE ============
                      if (isWebsiteRecipe) {
                        print("✅ Detected URL Recipe");

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.padding(20), // ✅
                          ),
                          child: Column(
                            children: [
                              CustomNetworkImage(
                                imageUrl:
                                "${ApiUrl.networkUrl}${data.recipeImage ?? ""}",
                                height: ResponsiveHelper.height(191), // ✅
                                width: ResponsiveHelper.width(375),   // ✅
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(25)), // ✅
                              RecipeInfoRow(
                                label: "${AppStrings.recipeName.tr}:",
                                value: "${data.recipeName ?? " "}",
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(20)), // ✅
                              ElevatedButton.icon(
                                onPressed: () {
                                  print("🔵 URL Button Pressed!");
                                  print("🔵 URL: ${data.url}");
                                  Get.toNamed(
                                    AppRoutes.webViewScreen,
                                    arguments: {
                                      "url": data.url,
                                      "title": data.recipeName,
                                    },
                                  );
                                },
                                icon: const Icon(Icons.open_in_browser),
                                label: const Text("Open URL Content"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.blue900,
                                  foregroundColor: Colors.white,
                                  padding: ResponsiveHelper.symmetric(
                                    horizontal: 30,
                                    vertical: 15,
                                  ), // ✅
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // ============ NORMAL RECIPE ============
                      print("✅ Detected Normal Recipe");

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.padding(20), // ✅
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomNetworkImage(
                              imageUrl:
                              "${ApiUrl.networkUrl}${data.recipeImage ?? ""}",
                              height: ResponsiveHelper.height(191), // ✅
                              width: ResponsiveHelper.width(375),   // ✅
                            ),
                            SizedBox(height: ResponsiveHelper.spacing(25)), // ✅
                            RecipeInfoRow(
                              label: "${AppStrings.recipeName.tr}:",
                              value: "${data.recipeName ?? " "}",
                            ),
                            SizedBox(height: ResponsiveHelper.spacing(8)),  // ✅
                            RecipeInfoRow(
                              label: AppStrings.cookingTimes.tr,
                              value: "${data.cookingTime ?? " "} minutes",
                            ),
                            SizedBox(height: ResponsiveHelper.spacing(8)),  // ✅
                            CustomText(
                              text: AppStrings.tag.tr,
                              fontWeight: FontWeight.w500,
                              fontSize: ResponsiveHelper.fontSize(20), // ✅
                              color: AppColors.dark400,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                data.tags?.length ?? 0,
                                    (index) {
                                  final tag = data.tags?[index] ?? "";
                                  final displayTag =
                                  recipeController.getTagLabel(tag);
                                  return CustomText(
                                    textAlign: TextAlign.start,
                                    maxLines: 10,
                                    text: "${index + 1}. $displayTag",
                                    fontWeight: FontWeight.w500,
                                    fontSize: ResponsiveHelper.fontSize(16), // ✅
                                    color: AppColors.dark300,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: ResponsiveHelper.spacing(32)), // ✅
                            RecipeSectionTitle(
                                title: "${AppStrings.description.tr}:"),
                            SizedBox(height: ResponsiveHelper.spacing(8)),  // ✅
                            RecipeDescription(
                                description: data.description ?? ""),
                            SizedBox(height: ResponsiveHelper.spacing(16)), // ✅
                            RecipeSectionTitle(
                                title: AppStrings.ingredients.tr),
                            SizedBox(height: ResponsiveHelper.spacing(8)),  // ✅
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                data.ingredients?.length ?? 0,
                                    (index) {
                                  final ingredients =
                                  data.ingredients?[index];
                                  return CustomText(
                                    textAlign: TextAlign.start,
                                    maxLines: 10,
                                    text:
                                    "${index + 1}. ${ingredients ?? " "}",
                                    fontWeight: FontWeight.w500,
                                    fontSize: ResponsiveHelper.fontSize(16), // ✅
                                    color: AppColors.dark300,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: ResponsiveHelper.spacing(16)), // ✅
                            RecipeSectionTitle(
                                title: "${AppStrings.describeSteps.tr}:"),
                            SizedBox(height: ResponsiveHelper.spacing(8)),  // ✅
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                data.steps?.length ?? 0,
                                    (index) {
                                  final steps = data.steps?[index];
                                  return CustomText(
                                    textAlign: TextAlign.start,
                                    maxLines: 10,
                                    text: "${index + 1}. ${steps ?? " "}",
                                    fontWeight: FontWeight.w500,
                                    fontSize: ResponsiveHelper.fontSize(16), // ✅
                                    color: AppColors.dark300,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============ Sub Widgets ============

class RecipeInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const RecipeInfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context); // ✅
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          textAlign: TextAlign.start,
          text: '$label ',
          fontSize: ResponsiveHelper.fontSize(16), // ✅
          fontWeight: FontWeight.w400,
          color: AppColors.dark300,
          right: ResponsiveHelper.spacing(30),     // ✅
        ),
        Expanded(
          child: CustomText(
            textAlign: TextAlign.start,
            maxLines: 10,
            text: '$value ',
            fontSize: ResponsiveHelper.fontSize(16), // ✅
            fontWeight: FontWeight.w400,
            color: AppColors.dark300,
            right: ResponsiveHelper.spacing(30),     // ✅
          ),
        ),
      ],
    );
  }
}

class RecipeSectionTitle extends StatelessWidget {
  final String title;

  const RecipeSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context); // ✅
    return CustomText(
      text: '$title ',
      fontSize: ResponsiveHelper.fontSize(20), // ✅
      fontWeight: FontWeight.w400,
      color: Colors.black,
      right: ResponsiveHelper.spacing(30),     // ✅
    );
  }
}

class RecipeDescription extends StatelessWidget {
  final String description;

  const RecipeDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context); // ✅
    return CustomText(
      text: '$description ',
      fontSize: ResponsiveHelper.fontSize(16), // ✅
      maxLines: 8,
      textAlign: TextAlign.start,
      fontWeight: FontWeight.w400,
      color: AppColors.dark300,
      right: ResponsiveHelper.spacing(30), // ✅
    );
  }
}