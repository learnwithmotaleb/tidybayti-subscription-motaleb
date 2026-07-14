import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';

class DBHelper {


  Future<String> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(AppConstants.token)??"";
  }

  Future<void> saveToken({required String token}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(AppConstants.token, token);
  }
}
