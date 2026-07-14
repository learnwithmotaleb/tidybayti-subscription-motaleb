import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../controller/owner_controller/task_controller/task_controller.dart';
import '../../../../../../../core/dependency/path.dart';
import '../../../../../../../data/service/api_check.dart';
import '../../../../../../../data/service/api_client.dart';
import '../../../../../../../data/service/api_url.dart';
import '../../../../../../../utils/ToastMsg/toast_message.dart';
import '../../../../../../../utils/app_const/app_const.dart';
import '../models/recurrence_data.dart';

import 'package:tidybayte/app/controller/owner_controller/home_controller/home_controller.dart';

class CreateTaskController extends GetxController {
  ApiClient apiClient = serviceLocator();

  final taskTitleController = TextEditingController();
  final startDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final endTimeController = TextEditingController();
  final recurrenceController = TextEditingController();
  final newRecurrenceController = TextEditingController();
  final taskDetailsController = TextEditingController();
  final additionalController = TextEditingController();

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  final rxRequestStatus = Status.loading.obs;
  RxString selectedEmployeeId = RxString('');
  RxString selectedRoomId = RxString('');
  RxString selectedRoomName = ''.obs;
  RxList<String> selectedRoomIdList = <String>[].obs;

  // Add preset rrule property
  RxString presetRrule = RxString('');

  // Initialize with a default one-time task instead of null
  Rx<RecurrenceData> customRecurrenceData =
      Rx<RecurrenceData>(const RecurrenceData.oneTime());

  String selectedUnit = "Days";
  int selectedNumber = 1;
  List<String> selectedDays = [];
  List<String> weekValues = ["1st", "2nd", "3rd", "4th", "Last"];
  List<String> selectedMonths = [];
  List<String> monthNames = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  // clearField() {
  //   taskTitleController.clear();
  //   startDateController.clear();
  //   startTimeController.clear();
  //   recurrenceController.clear();
  //   taskDetailsController.clear();
  //   additionalController.clear();
  //
  //   // Clear preset rrule
  //   presetRrule.value = '';
  //
  //   // Reset to default one-time task instead of null
  //   customRecurrenceData.value = const RecurrenceData.oneTime();
  // }



  clearField() {
    taskTitleController.clear();
    startDateController.clear();
    startTimeController.clear();
    recurrenceController.clear();
    taskDetailsController.clear();
    additionalController.clear();

    presetRrule.value = '';
    customRecurrenceData.value = const RecurrenceData.oneTime();

    // ✅ যোগ করুন
    refreshRoomDetails = false;
    roomIdForRefresh = '';
  }

  // Add this method to CreateTaskController
  void setRecurrenceFromPreset(String recurrenceText) {
    print('Setting recurrence from preset: $recurrenceText');

    // Parse the preset recurrence string into RecurrenceData
    RecurrenceData newData;

    switch (recurrenceText.trim().toLowerCase()) {
      case 'daily':
        newData = RecurrenceData(
          isOneTime: false,
          unit: "Days",
          number: 1,
          weekDays: [],
          days: [],
          months: [],
        );
        break;
      case 'weekly':
        // Get today's day of week
        final now = DateTime.now();
        final dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
        final todayDay = dayNames[now.weekday % 7];

        newData = RecurrenceData(
          isOneTime: false,
          unit: "Weeks",
          number: 1,
          weekDays: [todayDay],
          days: [],
          months: [],
        );
        break;
      case 'every 2 weeks':
        final now = DateTime.now();
        final dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
        final todayDay = dayNames[now.weekday % 7];

        newData = RecurrenceData(
          isOneTime: false,
          unit: "Weeks",
          number: 2,
          weekDays: [todayDay],
          days: [],
          months: [],
        );
        break;
      case 'monthly':
        final now = DateTime.now();
        final dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
        final todayDay = dayNames[now.weekday % 7];
        final weekOfMonth = ((now.day - 1) ~/ 7) + 1;
        final weekNames = ["1st", "2nd", "3rd", "4th", "Last"];
        final week = weekOfMonth > 4 ? "Last" : weekNames[weekOfMonth - 1];

        newData = RecurrenceData(
          isOneTime: false,
          unit: "Months",
          number: 1,
          weekDays: [todayDay],
          days: [week],
          months: [],
        );
        break;
      case 'yearly':
        final now = DateTime.now();
        final dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
        final todayDay = dayNames[now.weekday % 7];
        final monthNames = [
          "Jan",
          "Feb",
          "Mar",
          "Apr",
          "May",
          "Jun",
          "Jul",
          "Aug",
          "Sep",
          "Oct",
          "Nov",
          "Dec"
        ];
        final currentMonth = monthNames[now.month - 1];
        final weekOfMonth = ((now.day - 1) ~/ 7) + 1;
        final weekNames = ["1st", "2nd", "3rd", "4th", "Last"];
        final week = weekOfMonth > 4 ? "Last" : weekNames[weekOfMonth - 1];

        newData = RecurrenceData(
          isOneTime: false,
          unit: "Years",
          number: 1,
          weekDays: [todayDay],
          days: [week],
          months: [currentMonth],
        );
        break;
      default:
        newData = const RecurrenceData.oneTime();
    }

    customRecurrenceData.value = newData;
    print('RecurrenceData set to: $newData');
  }

  RxBool isTaskLoading = false.obs;

  bool refreshRoomDetails = false;
  String roomIdForRefresh = '';
  addTask() async {
    isTaskLoading.value = true;

    List<String> roomIdList = selectedRoomIdList.toList();

    var body = {
      "assignedTo": selectedEmployeeId.value,
      "roomIds": roomIdList,
      "taskName": taskTitleController.text,
      "startDateStr": dateController.text,
      "startTimeStr": timeController.text,
      "endTimeStr": endTimeController.text,
      "taskDetails": taskDetailsController.text,
      "additionalMessage": additionalController.text,
    };

    // Check if we have a preset rrule
    if (presetRrule.value.isNotEmpty) {
      body["recurrence"] = "recurrent";
      body["rrule"] = presetRrule.value;
      print('✅ Using preset rrule: ${presetRrule.value}');
    } else {
      // For standard/custom recurrence, use buildRecurrenceData
      var recurrenceData = buildRecurrenceData();
      body["recurrence"] = recurrenceData['recurrence'];

      if (recurrenceData['recurrence'] != 'one_time') {
        body.addAll({
          "freq": recurrenceData['freq'],
          "interval": recurrenceData['interval'],
          "days": recurrenceData['days'],
          "months": recurrenceData['months'],
        });
      }
      print('✅ Using standard recurrence: ${recurrenceData['recurrence']}');
    }

    print('📤 Final task body: $body');

    var response =
        await apiClient.post(body: body, url: ApiUrl.addTask, isBasic: false);

    if (response.statusCode == 200) {

      print("presetRrule =>================================ ${presetRrule.value}");
      print("customRecurrenceData =>============================ ${customRecurrenceData.value}");





     // toastMessage(message: response.body["message"]);

     // ✅ আগে refresh
     //  if (refreshRoomDetails && roomIdForRefresh.isNotEmpty) {
     //    try {
     //      final homeController = Get.find<HomeController>();
     //      await homeController.getSingleRoomTask(
     //        roomId: roomIdForRefresh,
     //      );
     //    } catch (e) {
     //      print(e);
     //    }
     //  }




      if (refreshRoomDetails && roomIdForRefresh.isNotEmpty) {
        try {
          final homeController = Get.find<HomeController>();
          homeController.getSingleRoomTask(roomId: roomIdForRefresh); // await ছাড়া
        } catch (e) {
          print(e);
        }
      }


      toastMessage(message: response.body["message"]);
      clearField();

      Get.back();


    } else if (response.statusCode == 400) {
      toastMessage(message: response.body["message"]);
    } else {
      ApiChecker.checkApi(response);
    }

    isTaskLoading.value = false;
    isTaskLoading.refresh();
  }

  // Enhanced buildRecurrenceData method
  Map<String, dynamic> buildRecurrenceData() {
    final data = customRecurrenceData.value;

    print("=== Building Recurrence Data ===");
    print("RecurrenceData: $data");
    print("IsOneTime: ${data.isOneTime}");
    print("Unit: ${data.unit}");

    // Check if it's a one-time task
    if (data.isOneTime || data.unit == "OneTime") {
      print("Returning one_time configuration");
      return {
        'recurrence': 'one_time',
        'freq': null,
        'interval': null,
        'days': [],
        'months': [],
      };
    }

    // Handle recurring tasks
    String freq;
    switch (data.unit) {
      case "Days":
        freq = "DAILY";
        break;
      case "Weeks":
        freq = "WEEKLY";
        break;
      case "Months":
        freq = "MONTHLY";
        break;
      case "Years":
        freq = "YEARLY";
        break;
      default:
        print("Unknown unit: ${data.unit}, defaulting to DAILY");
        freq = "DAILY";
    }

    print("Mapped unit '${data.unit}' to freq '$freq'");

    List<String> days = [];
    if (freq == "WEEKLY") {
      days = data.weekDays.map((day) {
        switch (day) {
          case "Sun":
            return "SU";
          case "Mon":
            return "MO";
          case "Tue":
            return "TU";
          case "Wed":
            return "WE";
          case "Thu":
            return "TH";
          case "Fri":
            return "FR";
          case "Sat":
            return "SA";
          default:
            return "";
        }
      }).toList();
    } else if (freq == "MONTHLY" || freq == "YEARLY") {
      for (var week in data.days) {
        for (var day in data.weekDays) {
          String dayCode;
          switch (day) {
            case "Sun":
              dayCode = "SU";
              break;
            case "Mon":
              dayCode = "MO";
              break;
            case "Tue":
              dayCode = "TU";
              break;
            case "Wed":
              dayCode = "WE";
              break;
            case "Thu":
              dayCode = "TH";
              break;
            case "Fri":
              dayCode = "FR";
              break;
            case "Sat":
              dayCode = "SA";
              break;
            default:
              dayCode = "";
          }
          days.add(week == "Last" ? "5$dayCode" : "${week[0]}$dayCode");
        }
      }
    }

    List<int> months = [];
    if (data.months.isNotEmpty) {
      months = data.months.map((m) => monthNames.indexOf(m) + 1).toList();
    }

    final result = {
      'recurrence': 'recurrent',
      'freq': freq,
      'interval': data.number,
      'days': days,
      'months': months,
    };

    print("Final recurrence result: $result");
    print("=== End Building Recurrence Data ===");

    return result;
  }

  var selectedDayIndex = Rxn<int>();
}
