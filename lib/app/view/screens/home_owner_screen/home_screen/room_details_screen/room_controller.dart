import 'dart:io';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/home_controller/home_controller.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/data/service/api_check.dart';
import 'package:tidybayte/app/global/helper/local_db/local_db.dart';
import 'package:tidybayte/app/utils/ToastMsg/toast_message.dart';
import '../../../../../core/dependency/path.dart';

class RoomController extends GetxController {
  final ApiClient apiClient = serviceLocator();
  final DBHelper dbHelper = serviceLocator();

  RxBool isUpdatingRoom = false.obs;
  RxBool isDeletingRoom = false.obs;

  /// ✅ PATCH: Update Room Name and Image (handle both together or separately)
  Future<void> editSingleRoom({
    required String roomId,
    required String name,
    required File roomImage,
  }) async {
    isUpdatingRoom.value = true;

    try {
      final form = {
        'roomId': roomId,
        'name': name,
      };

      // ✅ Only add image to multipart if it's a valid local file
      final files = <MultipartBody>[];

      if (roomImage.existsSync()) {
        files.add(MultipartBody('roomImage', roomImage));
      }

      final response = await apiClient.patchMultipart(
        url: ApiUrl.editSingleRoom,
        body: form,
        multipartBody: files,
      );

      if (response.statusCode == 200) {
        toastMessage(message: response.body["message"]);

        final homeController = Get.find<HomeController>();
        await homeController.getHouseRoom(
          houseId: homeController.selectedHouseId.value,
        );

        Get.back();
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      toastMessage(message: "Error: ${e.toString()}");
    }

    isUpdatingRoom.value = false;
  }

  // Future<void> deleteSingleRoom({
  //   required String roomId,
  // }) async
  // {
  //   isDeletingRoom.value = true;
  //
  //   try {
  //     final response = await apiClient.delete(
  //       url: ApiUrl.deleteSingleRoom,
  //       body: {
  //         'roomId': roomId,
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       toastMessage(message: response.body["message"]);
  //       Get.back();
  //     } else {
  //       ApiChecker.checkApi(response);
  //     }
  //   } catch (e) {
  //     toastMessage(message: "Error: ${e.toString()}");
  //   }
  //
  //   isDeletingRoom.value = false;
  // }
  //




  Future<void> deleteSingleRoom({
    required String roomId,
  }) async {
    isDeletingRoom.value = true;

    try {
      final response = await apiClient.delete(
        url: ApiUrl.deleteSingleRoom,
        body: {
          'roomId': roomId,
        },
      );

      if (response.statusCode == 200) {
        toastMessage(message: response.body["message"]);

        // ✅ Local list থেকে সাথে সাথে সরান
        final homeController = Get.find<HomeController>();
        homeController.houseRoomData.value.rooms
            ?.removeWhere((room) => room.id == roomId);
        homeController.houseRoomData.refresh();

        // ✅ Server থেকে fresh data
        await homeController.getHouseRoom(
          houseId: homeController.selectedHouseId.value,
        );

        Get.back(); // delete dialog close
        Get.back(); // room details screen থেকে বের
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      toastMessage(message: "Error: ${e.toString()}");
    }

    isDeletingRoom.value = false;
  }















}
