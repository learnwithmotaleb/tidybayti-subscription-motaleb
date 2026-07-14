import 'package:flutter/foundation.dart';

@immutable
class RecurrenceData {
  final int number;
  final String unit;
  final List<String> days;
  final List<String> weekDays;
  final List<String> months;
  final bool isOneTime; // New field to explicitly handle one-time tasks

  const RecurrenceData({
    required this.number,
    required this.unit,
    this.days = const [],
    this.weekDays = const [],
    this.months = const [],
    this.isOneTime = false, // Default to false for recurring tasks
  });

  // Factory constructor for one-time tasks
  const RecurrenceData.oneTime()
      : number = 0,
        unit = "OneTime",
        days = const [],
        weekDays = const [],
        months = const [],
        isOneTime = true;

  // Factory constructors for common recurrence patterns
  const RecurrenceData.daily()
      : number = 1,
        unit = "Days",
        days = const [],
        weekDays = const [],
        months = const [],
        isOneTime = false;

  const RecurrenceData.weekly({List<String> weekDays = const []})
      : number = 1,
        unit = "Weeks",
        days = const [],
        weekDays = weekDays,
        months = const [],
        isOneTime = false;

  const RecurrenceData.monthly({
    List<String> days = const [],
    List<String> weekDays = const [],
  })  : number = 1,
        unit = "Months",
        days = days,
        weekDays = weekDays,
        months = const [],
        isOneTime = false;

  const RecurrenceData.yearly({
    List<String> months = const [],
    List<String> days = const [],
    List<String> weekDays = const [],
  })  : number = 1,
        unit = "Years",
        days = days,
        weekDays = weekDays,
        months = months,
        isOneTime = false;

  @override
  String toString() {
    if (isOneTime) {
      return "One Time";
    }

    String formattedString = "";
    String baseUnit =
        unit.substring(0, unit.length - 1); // "Day", "Week", "Month", "Year"

    // Handle different recurrence units and numbers
    if (number == 1) {
      formattedString = "Every $baseUnit";
    } else if (unit == "Weeks") {
      String numberString;
      switch (number) {
        case 1:
          numberString = "1st";
          break;
        case 2:
          numberString = "2nd";
          break;
        case 3:
          numberString = "3rd";
          break;
        case 4:
          numberString = "4th";
          break;
        case 5:
          numberString = "5th";
          break;
        case 6:
          numberString = "6th";
          break;
        case 7:
          numberString = "7th";
          break;
        default:
          numberString = "$number";
          break;
      }
      formattedString = "Every $numberString $unit";
    } else {
      formattedString = "Every $number $unit";
    }

    // Handle specific day/month selections
    if (unit == "Weeks" && weekDays.isNotEmpty) {
      formattedString += " on ${weekDays.join(", ")}";
    }

    if (unit == "Months" || unit == "Years") {
      if (months.isNotEmpty) {
        formattedString += " in ${months.join(", ")}";
      }
      if (weekDays.isNotEmpty && days.isNotEmpty) {
        formattedString += " on the ${days.join(", ")} ${weekDays.join(", ")}";
      } else if (days.isNotEmpty) {
        formattedString += " on the ${days.join(", ")}";
      }
    }

    return formattedString;
  }

  // Method to check if this is a one-time task
  bool get isRecurrent => !isOneTime;

  // Copy with method for immutable updates
  RecurrenceData copyWith({
    int? number,
    String? unit,
    List<String>? days,
    List<String>? weekDays,
    List<String>? months,
    bool? isOneTime,
  }) {
    return RecurrenceData(
      number: number ?? this.number,
      unit: unit ?? this.unit,
      days: days ?? this.days,
      weekDays: weekDays ?? this.weekDays,
      months: months ?? this.months,
      isOneTime: isOneTime ?? this.isOneTime,
    );
  }
}
