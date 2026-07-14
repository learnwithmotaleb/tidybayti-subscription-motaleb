import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tidybayte/app/controller/owner_controller/home_controller/home_controller.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/shared_prefe/shared_prefe.dart';
import 'package:tidybayte/app/utils/ToastMsg/toast_message.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';

class HouseAdd {
  /// ✅ House Room Create API
  static Future<void> houseRoomAdd({
    required BuildContext context,
    required String houseName,
    required String roomName,
    required File roomImage, // ✅ Now passing as File
  }) async {
    HomeController homeController = Get.find();
    homeController.setLoading(true);

    /// ✅ Ensure required fields are not empty
    if (houseName.isEmpty || roomName.isEmpty || !roomImage.existsSync()) {
      toastMessage(message: "❌ House Name, Room Name, and Icon are required!");
      homeController.setLoading(false);
      return;
    }

    /// ✅ Retrieve token
    String? savedToken = await SharePrefsHelper.getString(AppConstants.token);
    if (savedToken.isEmpty) {
      toastMessage(message: "❌ Authentication failed. Please log in again.");
      homeController.setLoading(false);
      return;
    }

    /// ✅ Prepare API Request
    var url = Uri.parse(ApiUrl.houseRomeCreate);
    var request = http.MultipartRequest("POST", url);

    request.fields["houseName"] = houseName;
    request.fields["roomName"] = roomName;

    /// ✅ Attach File (converted PNG)
    request.files.add(await http.MultipartFile.fromPath(
      "roomImage",
      roomImage.path,
      contentType: MediaType('image', 'png'),
    ));

    /// ✅ Add Authorization Header
    request.headers.addAll({
      "Authorization": "Bearer $savedToken",
      "Content-Type": "multipart/form-data",
    });

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      homeController.setLoading(false);

      if (response.statusCode == 200) {
        homeController.houseNameController.clear();
        homeController.roomNameController.clear();

        homeController.rooms.clear();



        await homeController.refreshAfterHouseCreate();

        toastMessage(message: "✅ Room created successfully!");
        Get.offAllNamed(AppRoutes.homeScreen);
       // toastMessage(message: "✅ Room created successfully!");
        print("✅ Room created successfully");
        print(responseData);
      } else {
        print("❌ Failed: ${response.statusCode}");
        print("❌ Error Response: $responseData");

        toastMessage(message: "❌ Error creating room.");
      }
    } catch (e) {
      homeController.setLoading(false);
      toastMessage(message: "❌ Error: Please check your internet connection.");
      print("❌ Error: $e");
    }
  }

  static Future<File> getFileFromAsset(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${assetPath.split('/').last}');

    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }

  static Future<void> roomAdd({
    required BuildContext context,
    required String houseId,
    required String roomName,
    required File roomImage, // ✅ Sending as File
  }) async {
    HomeController homeController = Get.find();
    homeController.setRoomLoading(true);

    /// ✅ Ensure required fields are not empty
    if (houseId.isEmpty || roomName.isEmpty || !roomImage.existsSync()) {
      toastMessage(message: "❌ House Name, Room Name, and Icon are required!");
      homeController.setRoomLoading(false);
      return;
    }

    /// ✅ Retrieve token
    String? savedToken = await SharePrefsHelper.getString(AppConstants.token);
    if (savedToken.isEmpty) {
      toastMessage(message: "❌ Authentication failed. Please log in again.");
      homeController.setRoomLoading(false);
      return;
    }

    /// ✅ Prepare API Request
    var url = Uri.parse(ApiUrl.houseRomeCreate);
    var request = http.MultipartRequest("POST", url);

    request.fields["houseId"] = houseId;
    request.fields["roomName"] = roomName;

    /// ✅ Attach File (converted from Asset)
    request.files.add(await http.MultipartFile.fromPath(
      "roomImage",
      roomImage.path,
      contentType: MediaType('image', 'png'),
    ));

    /// ✅ Add Authorization Header
    request.headers.addAll({
      "Authorization": "Bearer $savedToken",
      "Content-Type": "multipart/form-data",
    });

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      homeController.setLoading(false);

      if (response.statusCode == 200) {
        Get.offAllNamed(AppRoutes.homeScreen);
        homeController.getHouseRoom(houseId: houseId);
        toastMessage(message: "✅ Room created successfully!");
        print("✅ Room created successfully");
        print(responseData);
      } else {
        print("❌ Failed: ${response.statusCode}");
        print("❌ Error Response: $responseData");
        toastMessage(message: "❌ Error creating room.");
      }
    } catch (e) {
      homeController.setLoading(false);
      toastMessage(message: "❌ Error: Please check your internet connection.");
      print("❌ Error: $e");
    }
  }
}
