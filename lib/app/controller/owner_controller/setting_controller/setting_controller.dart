import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/dependency/path.dart';
import 'package:tidybayte/app/data/service/api_check.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/local_db/local_db.dart';
import 'package:tidybayte/app/utils/ToastMsg/toast_message.dart';

class SettingController extends GetxController{
  ApiClient apiClient = serviceLocator();
  DBHelper dbHelper = serviceLocator();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  ///==================================✅✅Change Password✅✅=======================

  RxBool isChangeLoading = false.obs;

  changePassword() async {
    try {
      isChangeLoading.value = true;

      var body = {
        "oldPassword": oldPasswordController.text.trim(),
        "newPassword": newPasswordController.text.trim(),
        "confirmPassword": confirmPasswordController.text.trim(),
      };

      print("Request Body => $body");

      var response = await apiClient.patch(
        body: body,
        url: ApiUrl.changePassword,
      );

      print("Status Code => ${response.statusCode}");
      print("Response Body => ${response.body}");

      if (response.statusCode == 200) {
        clearField();
        toastMessage(message: response.body["message"]);
        Get.back();
      } else if (response.statusCode == 400) {
        toastMessage(message: response.body["message"]);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print("Change Password Error => $e");
    } finally {
      isChangeLoading.value = false;
    }
  }


  clearField(){
    oldPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

}