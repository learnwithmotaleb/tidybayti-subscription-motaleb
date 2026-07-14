import 'package:tidybayte/app/data/service/api_url.dart';
import '../../../utils/app_const/app_const.dart';

class ImageHandler {
  static String imagesHandle(String? url, {bool isProfile = false}) {
    if (url == null || url.isEmpty) {
      if (isProfile) {
        return AppConstants.employee;
      }
      return AppConstants.breakfast;
    }

    if (url.startsWith('http')) {
      return url; // If the URL starts with 'http', return as is
    } else {
      return '${ApiUrl.networkUrl}$url';
      //  return ApiUrl.imageUrl + url;
    }
  }
}