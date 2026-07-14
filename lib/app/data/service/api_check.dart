
import 'package:get/get.dart';
import 'package:tidybayte/app/utils/ToastMsg/toast_message.dart';


class ApiChecker {
  static void checkApi(Response response, {bool getXSnackBar = false}) async {
    if (response.statusCode == 401) {

    } else {
      showCustomSnackBar(response.statusText!, getXSnackBar: getXSnackBar);
    }
  }
}
