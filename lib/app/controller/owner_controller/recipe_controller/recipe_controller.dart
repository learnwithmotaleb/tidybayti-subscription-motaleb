import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tidybayte/app/core/dependency/path.dart';
import 'package:tidybayte/app/data/model/owner_model/recipe/my_recipe.dart';
import 'package:tidybayte/app/data/model/owner_model/recipe/recipe_single.dart';
import 'package:tidybayte/app/data/service/api_check.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/utils/ToastMsg/toast_message.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';


class RecipeController extends GetxController {
  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  final rxRequestStatus = Status.loading.obs;
  ApiClient apiClient = serviceLocator();

  ///==================================✅✅get House Room✅✅=======================

  Rx<MyRecipeData> myRecipeData = MyRecipeData().obs;

  getMyRecipe() async {
    setRxRequestStatus(Status.loading);
    refresh();
    try {
      final response =
      await apiClient.get(url: ApiUrl.myRecipe, showResult: true);

      if (response.statusCode == 200) {
        myRecipeData.value = MyRecipeData.fromJson(response.body["data"]);

        print('otp==================${response.statusCode}');
        print(
            'myRecipeData Length==================${myRecipeData.value.recipeWithFavorite?.length}');
        setRxRequestStatus(Status.completed);
        refresh();
      } else {
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      setRxRequestStatus(Status.error);
    }
  }

  ///==================================✅✅Add New Recipe✅✅=======================

  final ingredientsController = TextEditingController();
  final describeStepsController = TextEditingController();
  final recipeNameController = TextEditingController();
  final cookingTimeController = TextEditingController();
  final descriptionController = TextEditingController();

  ////Tag
  final List<Map<String, String>> categories = [
    {'label': AppStrings.appetizers.tr, 'value': 'Appetizers'},
    {'label': AppStrings.asian.tr, 'value': 'Asian'},
    {'label': AppStrings.breakfast.tr, 'value': 'Breakfast'},
    {'label': AppStrings.dessert.tr, 'value': 'Dessert'},
    {'label': AppStrings.drinks.tr, 'value': 'Drinks'},
    {'label': AppStrings.salads.tr, 'value': 'Salads'},
    {'label': AppStrings.healthy.tr, 'value': 'Healthy'},
    {'label': AppStrings.indian.tr, 'value': 'Indian'},
    {'label': AppStrings.snacks.tr, 'value': 'Snacks'},
    {'label': AppStrings.lunch.tr, 'value': 'Lunch'},
    {'label': AppStrings.meal.tr, 'value': 'Meal'},
    {
      'label': AppStrings.southIndian.tr,
      'value': 'South_Indian'
    }, // ✅ label vs value
  ];

  List<bool> selectedCategories = [];
  List<String> selectedCategoryNames = [];

  //ingeredients and step
  final List<String> ingredientsList = [];
  final List<String> stepsList = [];
  var isLoading = false.obs;

  void setLoading(bool value) {
    isLoading.value = value;
  }

  var isEditLoading = false.obs;

  void setEditLoading(bool value) {
    isEditLoading.value = value;
  }

  Rx<File?> profileImage = Rx<File?>(null);

  Future<void> pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
      print("✅ Selected Image:===== ${profileImage.value!.path}");
    } else {
      print("❌ No Image Selected");
    }
  }

  // ✅ NEW: Clear all fields including profile image
  clearFields() {
    recipeNameController.clear();
    cookingTimeController.clear();
    descriptionController.clear();
    ingredientsController.clear();
    describeStepsController.clear();
    stepsList.clear();
    ingredientsList.clear();
    selectedCategoryNames.clear();
    profileImage.value = null; // ✅ Clear selected image

    // Reset selected categories
    selectedCategories = List.generate(categories.length, (index) => false);
  }

  clearRecipeField() {
    recipeNameController.clear();
    cookingTimeController.clear();
    descriptionController.clear();
    stepsList.clear();
    ingredientsList.clear();
    selectedCategoryNames.clear();
  }

  ///==================================✅✅Search✅✅=======================
  TextEditingController searchController = TextEditingController();

  searchRecipe({required String recipeName}) async {
    setRxRequestStatus(Status.loading);
    myRecipeData.refresh();
    var response =
    await apiClient.get(url: "${ApiUrl.searchRecipe}=$recipeName");
    myRecipeData.refresh();
    if (response.statusCode == 200) {
      myRecipeData.value = MyRecipeData.fromJson(response.body["data"]);

      setRxRequestStatus(Status.completed);
      myRecipeData.refresh();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  ///==================================✅✅Remove Recipe✅✅=======================
  RxBool isRemoveRecipe = false.obs;

  removeRecipe({required String recipeId}) async {
    isRemoveRecipe.value = true;
    var body = {"recipeId": recipeId};

    var response = await apiClient.delete(body: body, url: ApiUrl.deleteRecipe);
    if (response.statusCode == 200) {
      getMyRecipe();
      toastMessage(message: response.body["message"]);
    } else if (response.statusCode == 400) {
      toastMessage(message: response.body["message"]);
    } else {
      ApiChecker.checkApi(response);
    }
    isRemoveRecipe.value = false;
    isRemoveRecipe.refresh();
  }

  ///==================================✅✅Recipe Details✅✅=======================

  Rx<RecipeSingleData> recipeSingleData = RecipeSingleData().obs;

  getRecipeSingle({required String recipeId}) async {
    setRxRequestStatus(Status.loading);
    refresh();
    try {
      final response = await apiClient.get(
          url: ApiUrl.singleRecipe(recipeId), showResult: true);

      if (response.statusCode == 200) {
        recipeSingleData.value =
            RecipeSingleData.fromJson(response.body["data"]);

        print('otp==================${response.statusCode}');
        print(
            'ingredients Length==================${recipeSingleData.value.ingredients?.length}');
        setRxRequestStatus(Status.completed);
        refresh();
      } else {
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      setRxRequestStatus(Status.error);
    }
  }

//Tags
  final List<Map<String, String>> tags = [
    {
      'key': 'Appetizers',
      'title': AppStrings.appetizers.tr,
      'imageUrl': AppConstants.appetizers, // Replace with actual image URL
    },
    {
      'key': 'Asian',
      'title': AppStrings.asian.tr,
      'imageUrl': AppConstants.asian, // Replace with actual image URL
    },
    {
      'key': 'Breakfast',
      'title': AppStrings.breakfast.tr,
      'imageUrl': AppConstants.breakfast, // Replace with actual image URL
    },
    {
      'key': 'Dessert',
      'title': AppStrings.dessert.tr,
      'imageUrl': AppConstants.dessert, // Replace with actual image URL
    },
    {
      'key': 'Dinner',
      'title': AppStrings.drinks.tr,
      'imageUrl': AppConstants.drinks, // Replace with actual image URL
    },
    {
      'key': 'Italian',
      'title': AppStrings.salads.tr,
      'imageUrl': AppConstants.salads, // Replace with actual image URL
    },
    {
      'key': 'Healthy',
      'title': AppStrings.healthy.tr,
      'imageUrl': AppConstants.healthy, // Replace with actual image URL
    },
    {
      'key': 'Indian',
      'title': AppStrings.indian.tr,
      'imageUrl': AppConstants.indian, // Replace with actual image URL
    },
    {
      'key': 'Snacks',
      'title': AppStrings.snacks.tr,
      'imageUrl': AppConstants.snacks, // Replace with actual image URL
    },
    {
      'key': 'Lunch',
      'title': AppStrings.lunch.tr,
      'imageUrl': AppConstants.lunch, // Replace with actual image URL
    },
    {
      'key': 'Dinner',
      'title': AppStrings.meal.tr,
      'imageUrl': AppConstants.meal, // Replace with actual image URL
    },
    {
      'key': 'South_Indian',
      'title': AppStrings.southIndian.tr,
      'imageUrl': AppConstants.southIndian, // Replace with actual image URL
    },
  ];

  final Map<String, String> tagDisplayMap = {
    'Appetizers': AppStrings.appetizers.tr,
    'Asian': AppStrings.asian.tr,
    'Breakfast': AppStrings.breakfast.tr,
    'Dessert': AppStrings.dessert.tr,
    'Drinks': AppStrings.drinks.tr,
    'Salads': AppStrings.salads.tr,
    'Healthy': AppStrings.healthy.tr,
    'Indian': AppStrings.indian.tr,
    'Snacks': AppStrings.snacks.tr,
    'Lunch': AppStrings.lunch.tr,
    'Meal': AppStrings.meal.tr,
    'South_Indian': AppStrings.southIndian.tr,
  };

  /// Method to get UI label from backend value
  String getTagLabel(String value) {
    return tagDisplayMap[value] ?? value;
  }

  ///==================================✅✅get Single Tags✅✅=======================

  Rx<MyRecipeData> singleTags = MyRecipeData().obs;

  getSingleTags({required String tagText}) async {
    setRxRequestStatus(Status.loading);
    refresh();
    try {
      final response =
      await apiClient.get(url: ApiUrl.tagFilter(tagText), showResult: true);

      if (response.statusCode == 200) {
        singleTags.value = MyRecipeData.fromJson(response.body["data"]);

        print('otp==================${response.statusCode}');
        print(
            'myRecipeData Length==================${singleTags.value.recipeWithFavorite?.length}');
        setRxRequestStatus(Status.completed);
        refresh();
      } else {
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      setRxRequestStatus(Status.error);
    }
  }

  ///==================================✅✅addFavorite✅✅=======================
  // Controller:
  var favoriteStatus = <String, RxBool>{}; // Remove .obs

  void loadFavoriteStatus(List<RecipeWithFavorite> recipes) {
    for (var recipe in recipes) {
      favoriteStatus[recipe.id ?? ""] = RxBool(recipe.isFavorite ?? false);
    }
    update(); // Optional: call update() if using GetBuilder, but not needed for Obx on RxBool
  }

  void toggleFavorite(String recipeId) async {
    // Ensure the favorite status exists
    if (!favoriteStatus.containsKey(recipeId)) {
      favoriteStatus[recipeId] = RxBool(false);
    }

    // Store the current state for rollback
    bool currentState = favoriteStatus[recipeId]!.value;

    // Optimistically update UI
    favoriteStatus[recipeId]!.value = !currentState;

    try {
      var response =
      await apiClient.patch(body: {}, url: ApiUrl.favoriteRecipe(recipeId));

      if (response.statusCode == 200) {
        // Success - keep the UI state as is
        toastMessage(message: response.body["message"]);

        // Also update the main recipe data if needed
        _updateRecipeInMainList(recipeId, favoriteStatus[recipeId]!.value);
      } else {
        // Failed - rollback UI state
        favoriteStatus[recipeId]!.value = currentState;
        toastMessage(message: "Failed to update favorite status.");
      }
    } catch (e) {
      // Error - rollback UI state
      favoriteStatus[recipeId]!.value = currentState;
      toastMessage(message: "Something went wrong.");
      debugPrint("Favorite toggle error: $e");
    }
  }

  /// Get Favorite Status for a Recipe
  void clearFavoriteStatus() {
    favoriteStatus.clear();
  }

  void _updateRecipeInMainList(String recipeId, bool isFavorite) {
    final recipes = myRecipeData.value.recipeWithFavorite ?? [];
    final recipeIndex = recipes.indexWhere((recipe) => recipe.id == recipeId);

    if (recipeIndex != -1) {
      recipes[recipeIndex].isFavorite = isFavorite;
      // Trigger update if needed
      update();
    }
  }

  /// Get Favorite Status for a Recipe (Initialize if not exists)
  RxBool getFavoriteStatus(String recipeId, bool isFavoriteFromApi) {
    if (!favoriteStatus.containsKey(recipeId)) {
      favoriteStatus[recipeId] = RxBool(isFavoriteFromApi);
    }
    return favoriteStatus[recipeId]!;
  }

  @override
  void onInit() {
    getMyRecipe();
    super.onInit();
  }
}