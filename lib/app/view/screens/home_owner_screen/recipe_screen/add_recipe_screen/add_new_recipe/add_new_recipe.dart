import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/recipe_controller/recipeApi.dart';
import 'package:tidybayte/app/controller/owner_controller/recipe_controller/recipe_controller.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/ToastMsg/toast_message.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_text_field/custom_text_field.dart';

class AddNewRecipe extends StatefulWidget {
  const AddNewRecipe({super.key});

  @override
  _AddNewRecipeState createState() => _AddNewRecipeState();
}

class _AddNewRecipeState extends State<AddNewRecipe> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    recipeController.selectedCategories =
        List.generate(recipeController.categories.length, (index) => false);
    recipeController.selectedCategoryNames = [];

    final arguments = Get.arguments ?? {};
    isEdit = arguments["IsEdit"] == "true";
    recipeId = arguments["recipeId"];

    final args = Get.arguments ?? {};
    recipeController.recipeNameController.text = args["recipeName"] ?? '';
    recipeController.cookingTimeController.text = args["cookingTime"] ?? '';
    recipeController.descriptionController.text = args["description"] ?? '';

    List<String> ingredients =
    List<String>.from(arguments["ingredients"] ?? []);
    print(ingredients);
    recipeController.ingredientsList.assignAll(ingredients);

    List<String> steps = List<String>.from(arguments["step"] ?? []);
    print(steps);
    recipeController.stepsList.assignAll(steps);

    tag = List<String>.from(arguments["tag"] ?? []);

    for (int i = 0; i < recipeController.categories.length; i++) {
      if (tag.contains(recipeController.categories[i])) {
        recipeController.selectedCategories[i] = true;
      }
    }

    recipeController.selectedCategoryNames = recipeController.categories
        .asMap()
        .entries
        .where((entry) => recipeController.selectedCategories[entry.key])
        .map((entry) => entry.value['label']!)
        .toList();
  }

  late List<String> tag;
  late bool isEdit;
  String? recipeId;
  final RecipeController recipeController = Get.find<RecipeController>();

  @override
  Widget build(BuildContext context) {

    print(isEdit);

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
          child: SafeArea(
            child: Column(
              children: [
                ///=============================== addNewRecipe AppBar ========================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomMenuAppbar(
                      title: AppStrings.addNewRecipe.tr,
                      onBack: () {
                        Get.back();
                      },
                    ),
                  ],
                ),

                ///=============================== Form and Grid Content ========================
                Expanded(
                  child: Obx(() {
                    return ListView(
                      padding: ResponsiveHelper.all(16.0), // ✅
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///=============================== recipeName ========================
                              CustomTextField(
                                textEditingController:
                                recipeController.recipeNameController,
                                hintText: AppStrings.recipeName.tr,
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(16)), // ✅

                              ///=============================== Image ========================
                              Obx(() => CustomTextField(
                                onTap: () {
                                  recipeController.pickImage();
                                },
                                readOnly: true,
                                hintText:
                                recipeController.profileImage.value ==
                                    null
                                    ? AppStrings.addPhoto.tr
                                    : '',
                                prefixIcon: recipeController
                                    .profileImage.value !=
                                    null
                                    ? Padding(
                                  padding:
                                  ResponsiveHelper.all(8.0), // ✅
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(
                                      ResponsiveHelper.borderRadius(8.0), // ✅
                                    ),
                                    child: Image.file(
                                      recipeController
                                          .profileImage.value!,
                                      width: ResponsiveHelper.width(60),   // ✅
                                      height: ResponsiveHelper.height(60), // ✅
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                                    : null,
                                suffixIcon: Padding(
                                  padding: EdgeInsets.only(
                                    right: ResponsiveHelper.spacing(10), // ✅
                                  ),
                                  child: Icon(
                                    Icons.photo,
                                    size: ResponsiveHelper.iconSize(50), // ✅
                                    color: Colors.grey,
                                  ),
                                ),
                              )),
                              SizedBox(height: ResponsiveHelper.spacing(16)), // ✅

                              ///=============================== cookingTime ========================
                              CustomTextField(
                                hintText: AppStrings.cookingTime.tr,
                                textEditingController:
                                recipeController.cookingTimeController,
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(16)), // ✅

                              ///=============================== description ========================
                              CustomTextField(
                                hintText: AppStrings.description.tr,
                                textEditingController:
                                recipeController.descriptionController,
                                maxLines: 5,
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(16)), // ✅

                              ///=============================== Ingredients ========================
                              Column(
                                children: [
                                  IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: CustomTextField(
                                            hintText:
                                            AppStrings.typeIngredient.tr,
                                            textEditingController: recipeController
                                                .ingredientsController,
                                          ),
                                        ),
                                        SizedBox(
                                            width: ResponsiveHelper.spacing(20)), // ✅
                                        Expanded(
                                          flex: 1,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor:
                                              AppColors.employeeCardColor,
                                              minimumSize:
                                              const Size(double.infinity, 0),
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                  ResponsiveHelper.borderRadius(8), // ✅
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (recipeController
                                                  .ingredientsController
                                                  .text
                                                  .isNotEmpty) {
                                                setState(() {
                                                  recipeController
                                                      .ingredientsList
                                                      .add(recipeController
                                                      .ingredientsController
                                                      .text);
                                                  recipeController
                                                      .ingredientsController
                                                      .clear();
                                                  print(
                                                      'ingredients=======${jsonEncode(recipeController.ingredientsList)}');
                                                });
                                              }
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              color: AppColors.blue900,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveHelper.spacing(10)), // ✅

                                  Column(
                                    children: recipeController.ingredientsList
                                        .map((ingredient) {
                                      return Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding:
                                              EdgeInsets.symmetric(
                                                vertical:
                                                ResponsiveHelper.spacing(10), // ✅
                                              ),
                                              child: Container(
                                                height:
                                                ResponsiveHelper.height(64), // ✅
                                                padding:
                                                ResponsiveHelper.all(12), // ✅
                                                decoration: BoxDecoration(
                                                  color: AppColors
                                                      .employeeCardColor,
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                    ResponsiveHelper.borderRadius(8), // ✅
                                                  ),
                                                ),
                                                child: Text(
                                                  ingredient,
                                                  style: TextStyle(
                                                    fontSize:
                                                    ResponsiveHelper.fontSize(14), // ✅
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width:
                                              ResponsiveHelper.spacing(18)), // ✅
                                          Expanded(
                                            flex: 1,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: AppColors.red,
                                                padding:
                                                ResponsiveHelper.symmetric(
                                                  horizontal: 20,
                                                  vertical: 15,
                                                ), // ✅
                                                textStyle: TextStyle(
                                                  fontSize:
                                                  ResponsiveHelper.fontSize(18), // ✅
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                    ResponsiveHelper.borderRadius(8), // ✅
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  recipeController
                                                      .ingredientsList
                                                      .remove(ingredient);
                                                  print(
                                                      'ingredients=======${jsonEncode(recipeController.ingredientsList)}');
                                                });
                                              },
                                              child: const Icon(
                                                Icons.delete,
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(height: ResponsiveHelper.spacing(20)), // ✅
                                ],
                              ),

                              ///=============================== Steps ========================
                              Column(
                                children: [
                                  IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: CustomTextField(
                                            hintText:
                                            AppStrings.describeSteps.tr,
                                            textEditingController: recipeController
                                                .describeStepsController,
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                            ResponsiveHelper.spacing(20)), // ✅
                                        Expanded(
                                          flex: 1,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor:
                                              AppColors.employeeCardColor,
                                              minimumSize:
                                              const Size(double.infinity, 0),
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                  ResponsiveHelper.borderRadius(8), // ✅
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (recipeController
                                                  .describeStepsController
                                                  .text
                                                  .isNotEmpty) {
                                                setState(() {
                                                  recipeController.stepsList
                                                      .add(recipeController
                                                      .describeStepsController
                                                      .text);
                                                  recipeController
                                                      .describeStepsController
                                                      .clear();
                                                });
                                              }
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              color: AppColors.blue900,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveHelper.spacing(10)), // ✅

                                  Column(
                                    children: recipeController.stepsList
                                        .map((step) {
                                      return Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              height:
                                              ResponsiveHelper.height(64), // ✅
                                              padding:
                                              ResponsiveHelper.all(12), // ✅
                                              margin: EdgeInsets.symmetric(
                                                vertical:
                                                ResponsiveHelper.spacing(5), // ✅
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                AppColors.employeeCardColor,
                                                borderRadius:
                                                BorderRadius.circular(
                                                  ResponsiveHelper.borderRadius(8), // ✅
                                                ),
                                              ),
                                              child: Text(
                                                step,
                                                style: TextStyle(
                                                  fontSize:
                                                  ResponsiveHelper.fontSize(14), // ✅
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width:
                                              ResponsiveHelper.spacing(18)), // ✅
                                          Expanded(
                                            flex: 1,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                backgroundColor: AppColors.red,
                                                padding:
                                                ResponsiveHelper.symmetric(
                                                  horizontal: 20,
                                                  vertical: 15,
                                                ), // ✅
                                                textStyle: TextStyle(
                                                  fontSize:
                                                  ResponsiveHelper.fontSize(18), // ✅
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                    ResponsiveHelper.borderRadius(8), // ✅
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  recipeController.stepsList
                                                      .remove(step);
                                                  print(
                                                      'StepList=======${jsonEncode(recipeController.stepsList)}');
                                                });
                                              },
                                              child: const Icon(
                                                Icons.delete,
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(height: ResponsiveHelper.spacing(20)), // ✅
                                ],
                              ),

                              ///=============================== Select Tags ========================
                              TagSection(),
                              SizedBox(height: ResponsiveHelper.spacing(20)), // ✅

                              ///=============================== Save Button ========================
                              recipeController.isLoading.value
                                  ? const CustomLoader()
                                  : CustomButton(
                                width: MediaQuery.of(context).size.width /
                                    1.1,
                                onTap: () {
                                  if (recipeController
                                      .profileImage.value ==
                                      null) {
                                    toastMessage(
                                        message: AppStrings
                                            .pleaseSelectARecipeImage.tr);
                                    print(
                                        "❌ Please select a Recipe image.");
                                    return;
                                  }
                                  isEdit == false
                                      ? RecipeApi.addRecipe(
                                      context: context,
                                      recipeName: recipeController
                                          .recipeNameController.text,
                                      recipeImage: recipeController
                                          .profileImage.value!,
                                      cookingTime: recipeController
                                          .cookingTimeController.text,
                                      description: recipeController
                                          .descriptionController.text,
                                      ingredients: recipeController
                                          .ingredientsList,
                                      steps: recipeController.stepsList,
                                      tags: recipeController
                                          .selectedCategoryNames)
                                      : RecipeApi.editRecipe(
                                      context: context,
                                      recipeName: recipeController
                                          .recipeNameController.text,
                                      recipeImage: recipeController
                                          .profileImage.value!,
                                      cookingTime: recipeController
                                          .cookingTimeController.text,
                                      description: recipeController
                                          .descriptionController.text,
                                      ingredients: recipeController
                                          .ingredientsList,
                                      steps: recipeController.stepsList,
                                      tags: recipeController
                                          .selectedCategoryNames,
                                      recipeId: recipeId.toString());
                                },
                                fillColor: Colors.white,
                                title: AppStrings.saveAndChange.tr,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///Tag Section
  Column TagSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.selectTags.tr,
          style: TextStyle(
            fontSize: ResponsiveHelper.fontSize(20),       // ✅
            fontWeight: FontWeight.w300,
            color: AppColors.dark300,
          ),
        ),
        SizedBox(height: ResponsiveHelper.spacing(10)),    // ✅
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 2.5,
          ),
          itemCount: recipeController.categories.length,
          itemBuilder: (context, index) {
            final category = recipeController.categories[index];
            final label = category['label']!;
            return GestureDetector(
              onTap: () {
                setState(() {
                  recipeController.selectedCategories[index] =
                  !recipeController.selectedCategories[index];
                  recipeController.selectedCategoryNames = recipeController
                      .categories
                      .asMap()
                      .entries
                      .where((entry) =>
                  recipeController.selectedCategories[entry.key])
                      .map((entry) => entry.value['value']!)
                      .toList();
                  print(
                      'Selected Categories: "${recipeController.selectedCategoryNames}"');
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: recipeController.selectedCategories[index]
                      ? AppColors.blue900
                      : AppColors.employeeCardColor,
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(8), // ✅
                  ),
                  border: Border.all(color: Colors.black12),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: recipeController.selectedCategories[index]
                        ? AppColors.light200
                        : AppColors.dark300,
                    fontSize: ResponsiveHelper.fontSize(16), // ✅
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}