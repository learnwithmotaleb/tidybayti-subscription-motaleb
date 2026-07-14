import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';

class DateConverter {
  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  ///=============== Calculate Time of Day ===============

  static String getTimePeriod() {
    // Get the current hour of the day
    int currentHour = DateTime.now().hour;

    // Define the boundaries for morning, noon, and evening
    int morningBoundary = 6;
    int noonBoundary = 12;
    int eveningBoundary = 18;

    // Determine the time period based on the current hour
    if (currentHour >= morningBoundary && currentHour < noonBoundary) {
      return AppStrings.goodMorning.tr;
    } else if (currentHour >= noonBoundary && currentHour < eveningBoundary) {
      return AppStrings.goodAfternoon.tr;
    } else {
      return AppStrings.goodEvening.tr;
    }
  }

  static DateTime? parseTimeString(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return null;
    try {
      final format = DateFormat("hh:mm a"); // Example: "10:00 AM"
      return format.parse(timeStr);
    } catch (e) {
      return null; // Return null if parsing fails
    }
  }
}
