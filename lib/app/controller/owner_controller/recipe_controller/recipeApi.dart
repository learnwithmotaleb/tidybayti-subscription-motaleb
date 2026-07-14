import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:tidybayte/app/controller/owner_controller/recipe_controller/recipe_controller.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/shared_prefe/shared_prefe.dart';
import 'package:tidybayte/app/utils/ToastMsg/toast_message.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';

class RecipeApi {
  ///==================================✅✅addRecipe✅✅=======================

  static Future<void> addRecipe({
    required BuildContext context,
    required String recipeName,
    required File recipeImage,
    required String cookingTime,
    required String description,
    required List ingredients,
    required List steps,
    required List tags,
  }) async
  {
    RecipeController recipeController = Get.find();
    recipeController.setLoading(true);

    var url = Uri.parse(ApiUrl.addRecipe);

    var request = http.MultipartRequest("POST", url);

    request.fields["recipeName"] = recipeName;
    request.fields["cookingTime"] = cookingTime;
    request.fields["description"] = description;
    request.fields["ingredients"] = jsonEncode(ingredients);
    request.fields["steps"] = jsonEncode(steps);
    request.fields["tags"] = jsonEncode(tags);
    //request.fields["source"] = "website";       // ✅ যোগ করো
   // request.fields["url"] = "http://recipe.com"; // ✅ যোগ করো
    request.fields["fileType"] = "normal"; // ✅ Mark as normal recipe

    request.files.add(await http.MultipartFile.fromPath(
      "recipeImage",
      recipeImage.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    String? savedToken = await SharePrefsHelper.getString(AppConstants.token);
    var token = savedToken;

    request.headers.addAll({
      "Authorization": "Bearer $token",
     "Content-Type": "multipart/form-data",
    });

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      recipeController.setLoading(false);

      if (response.statusCode == 201) {
        recipeController.getMyRecipe();
        Get.back();
        recipeController.clearRecipeField();
        toastMessage(message: "✅Recipe added successfully");
        print("✅ Recipe added successfully");
        print(responseData);
      } else {
        print("❌ Failed: ${response.statusCode}");
        print("❌ Error Response: $responseData");

        String errorMessage = "Something went wrong!";
        try {
          var decodedData = json.decode(responseData);
          if (decodedData["message"] != null) {
            errorMessage = decodedData["message"];
          }
        } catch (e) {
          print("❌ JSON Parsing Error: $e");
        }

        toastMessage(message: "❌ $errorMessage");
      }
    } catch (e) {
      recipeController.setLoading(false);
      toastMessage(
          message: "❌ An error occurred. Please check your connection.");
      print("❌ Error: $e");
    }
  }

  ///==================================✅✅Edit recipe✅✅=======================

  static Future<void> editRecipe({
    required BuildContext context,
    required String recipeName,
    required File recipeImage,
    required String cookingTime,
    required String description,
    required String recipeId,
    required List ingredients,
    required List steps,
    required List tags,
  }) async {
    RecipeController recipeController = Get.find();
    recipeController.setEditLoading(true);

    var url = Uri.parse(ApiUrl.updateRecipe);

    var request = http.MultipartRequest("PATCH", url);

    request.fields["recipeName"] = recipeName;
    request.fields["cookingTime"] = cookingTime;
    request.fields["description"] = description;
    request.fields["recipeId"] = recipeId;
    request.fields["ingredients"] = jsonEncode(ingredients);
    request.fields["steps"] = jsonEncode(steps);
    request.fields["tags"] = jsonEncode(tags);


    // এখন হবে:
    final mimeType = lookupMimeType(recipeImage.path) ?? 'image/jpeg';
    final mimeTypeSplit = mimeType.split('/');

    request.files.add(await http.MultipartFile.fromPath(
      "recipeImage",
      recipeImage.path,
      contentType: MediaType(mimeTypeSplit[0], mimeTypeSplit[1]), // ✅ actual mime type
    ));

    // request.files.add(await http.MultipartFile.fromPath(
    //   "recipeImage",
    //   recipeImage.path,
    //   contentType: MediaType('image', 'jpeg'),
    // ));

    String? savedToken = await SharePrefsHelper.getString(AppConstants.token);
    var token = savedToken;

    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Content-Type": "multipart/form-data",
    });

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      recipeController.setEditLoading(false);

      if (response.statusCode == 200) {
        recipeController.getRecipeSingle(recipeId: recipeId);
        Get.back();

        toastMessage(message: "✅Recipe Update successfully");
        print("✅ Recipe Update successfully");
        print(responseData);
      } else {
        print("❌ Failed: ${response.statusCode}");
        print("❌ Error Response: $responseData");

        String errorMessage = "Something went wrong!";
        try {
          var decodedData = json.decode(responseData);
          if (decodedData["message"] != null) {
            errorMessage = decodedData["message"];
          }
        } catch (e) {
          print("❌ JSON Parsing Error: $e");
        }

        toastMessage(message: "❌ $errorMessage");
      }
    } catch (e) {
      recipeController.setLoading(false);
      toastMessage(
          message: "❌ An error occurred. Please check your connection.");
      print("❌ Error: $e");
    }
  }

  ///==================================✅✅NEW: Add URL Recipe✅✅=======================

  static Future<void> addUrlRecipe({
    required BuildContext context,
    required String recipeName,
    required File recipeImage,
    required String fileType,
    required String fileUrl,
  }) async {
    RecipeController recipeController = Get.find();
    recipeController.setLoading(true);

    var url = Uri.parse(ApiUrl.addRecipe);

    var request = http.MultipartRequest("POST", url);

    request.fields["recipeName"] = recipeName;
    request.fields["source"] = "website"; // ✅ Backend uses "website"
    request.fields["url"] = fileUrl;  // ✅ Backend uses "url"

    // ✅ Add dummy data to satisfy backend validation
    request.fields["cookingTime"] = "0";
    request.fields["description"] = "URL Recipe";
    request.fields["ingredients"] = jsonEncode(["N/A"]);
    request.fields["steps"] = jsonEncode(["Open URL to view"]);
    request.fields["tags"] = jsonEncode([]);

    request.files.add(await http.MultipartFile.fromPath(
      "recipeImage",
      recipeImage.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    String? savedToken = await SharePrefsHelper.getString(AppConstants.token);
    var token = savedToken;

    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Content-Type": "multipart/form-data",
    });

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      recipeController.setLoading(false);

      if (response.statusCode == 201 || response.statusCode == 200) {
        recipeController.getMyRecipe();
        recipeController.profileImage.value = null; // Clear image
        Get.back(); // Close dialog

        toastMessage(message: "✅ URL recipe imported successfully");
        print("✅ URL recipe imported successfully");
        print(responseData);
      } else {
        print("❌ Failed: ${response.statusCode}");
        print("❌ Error Response: $responseData");

        String errorMessage = "Something went wrong!";
        try {
          var decodedData = json.decode(responseData);
          if (decodedData["message"] != null) {
            errorMessage = decodedData["message"];
          }
        } catch (e) {
          print("❌ JSON Parsing Error: $e");
        }

        toastMessage(message: "❌ $errorMessage");
      }
    } catch (e) {
      recipeController.setLoading(false);
      toastMessage(
          message: "❌ An error occurred. Please check your connection.");
      print("❌ Error: $e");
    }
  }

  ///==================================✅✅NEW: Add PDF Recipe✅✅=======================

  static Future<void> addPdfRecipe({
    required BuildContext context,
    required String recipeName,
    required File recipeImage,
    required String fileType,
    required String localFilePath,
  }) async {
    RecipeController recipeController = Get.find();
    recipeController.setLoading(true);

    var url = Uri.parse(ApiUrl.addRecipe);

    var request = http.MultipartRequest("POST", url);

    request.fields["recipeName"] = recipeName;
    request.fields["source"] = "file"; // ✅ Backend uses "source"

    // ✅ Add dummy data to satisfy backend validation
    request.fields["cookingTime"] = "0";
    request.fields["description"] = "PDF Recipe";
    request.fields["ingredients"] = jsonEncode(["N/A"]);
    request.fields["steps"] = jsonEncode(["Open PDF to view"]);
    request.fields["tags"] = jsonEncode([]);

    // Add recipe image
    request.files.add(await http.MultipartFile.fromPath(
      "recipeImage",
      recipeImage.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    // ✅ Upload the ACTUAL PDF file (not just the path)
    // Backend will save it and generate server path
    request.files.add(await http.MultipartFile.fromPath(
      //"recipeFile", // ✅ Upload PDF with this field name
      "recipe",   // ✅ Upload PDF with this field name
      localFilePath,
      contentType: MediaType('application', 'pdf'),
    ));

    print("📄 Uploading PDF from: $localFilePath");

    String? savedToken = await SharePrefsHelper.getString(AppConstants.token);
    var token = savedToken;

    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Content-Type": "multipart/form-data",
    });

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      recipeController.setLoading(false);

      if (response.statusCode == 201 || response.statusCode == 200) {
        recipeController.getMyRecipe();
        recipeController.profileImage.value = null; // Clear image
        Get.back(); // Close dialog

        toastMessage(message: "✅ PDF uploaded successfully");
        print("✅ PDF uploaded successfully");
        print(responseData);
      } else {
        print("❌ Failed: ${response.statusCode}");
        print("❌ Error Response: $responseData");

        String errorMessage = "Something went wrong!";
        try {
          var decodedData = json.decode(responseData);
          if (decodedData["message"] != null) {
            errorMessage = decodedData["message"];
          }
        } catch (e) {
          print("❌ JSON Parsing Error: $e");
        }

        toastMessage(message: "❌ $errorMessage");
      }
    } catch (e) {
      recipeController.setLoading(false);
      toastMessage(
          message: "❌ An error occurred. Please check your connection.");
      print("❌ Error: $e");
    }
  }
}