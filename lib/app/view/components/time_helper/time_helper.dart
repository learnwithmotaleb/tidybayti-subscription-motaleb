import 'package:get/get.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';

class TimeHelper {
  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} ${AppStrings.yearsAgo.tr} ';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} ${AppStrings.monthsAgo.tr} ';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${AppStrings.daysAgo.tr} ';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${AppStrings.hoursAgo.tr} ';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${AppStrings.minutesAgo.tr} ';
    } else {
      return AppStrings.justNow.tr;
    }
  }
}
