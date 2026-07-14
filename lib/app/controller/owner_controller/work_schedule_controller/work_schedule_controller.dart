import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tidybayte/app/core/dependency/path.dart';
import 'package:tidybayte/app/data/model/owner_model/work_schedule/user_task_model.dart';
import 'package:tidybayte/app/data/service/api_check.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';

class WorkScheduleController extends GetxController {
  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;

  final rxRequestStatus = Status.loading.obs;

  ApiClient apiClient = serviceLocator();

  var selectedDayIndex = 0.obs;

  List<String> dayName = [
    'All',
    'Sunday',
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    'Friday',
    'Saturday'
  ];

  RxBool isLoading = false.obs;

  Rx<Data> userTaskData = Data().obs;

  // Use a different approach - create a private variable and public getter
  final RxList _allTasks = <Result>[].obs;

  // Public getter that ensures proper type
  List<Result> get allTasks => List<Result>.from(_allTasks);

  // Method to safely update the tasks
  void setAllTasks(List<Result> tasks) {
    _allTasks.clear();
    _allTasks.addAll(tasks);
  }

  /// Get ordered list of days starting from today
  List<String> getOrderedDays() {
    final List<String> allDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    // Get current day
    final DateTime now = DateTime.now();
    final String currentDay = _getDayName(now.weekday);

    // Find the index of current day
    final int currentIndex = allDays.indexOf(currentDay);

    if (currentIndex == -1) return allDays; // Fallback

    // Reorder: current day first, then subsequent days, then previous days
    final List<String> orderedDays = [];

    // Add from current day to end of week
    for (int i = currentIndex; i < allDays.length; i++) {
      orderedDays.add(allDays[i]);
    }

    // Add from start of week to current day (previous days)
    for (int i = 0; i < currentIndex; i++) {
      orderedDays.add(allDays[i]);
    }

    return orderedDays;
  }

  /// Convert DateTime weekday to day name
  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Monday';
    }
  }

  /// Get current day name for highlighting
  String getCurrentDayName() {
    final DateTime now = DateTime.now();
    return _getDayName(now.weekday);
  }

  /// Group tasks by day and then by employee (original method - kept for compatibility)
  Map<String, Map<String, Map<String, dynamic>>> groupTasksByDayAndEmployee() {
    final Map<String, Map<String, Map<String, dynamic>>> groupedData = {};

    for (var task in allTasks) {
      final day = task.dayOfWeek ?? "Unknown Day";
      final date = task.startDateTime;

      // Format: "Monday (22 Sep, 2025)"
      final formattedDate = (date != null)
          ? DateFormat('dd MMM, yyyy').format(date)
          : "Unknown Date";
      final dayWithDate = "$day ($formattedDate)";

      final employeeId = task.assignedTo?.id ?? "Unknown Employee";

      if (!groupedData.containsKey(dayWithDate)) {
        groupedData[dayWithDate] = {};
      }

      if (!groupedData[dayWithDate]!.containsKey(employeeId)) {
        final isOffDay = task.assignedTo?.workingDay != null &&
            !task.assignedTo!.workingDay!.contains(day);

        final workingDayString =
            task.assignedTo?.workingDay?.join(', ') ?? "Not specified";

        groupedData[dayWithDate]![employeeId] = {
          'tasks': <Result>[],
          'isOffDay': isOffDay,
          'offDay': isOffDay ? day : null,
          'isWorkingDay': !isOffDay,
          'workingDay': workingDayString,
        };
      }

      groupedData[dayWithDate]![employeeId]!['tasks'].add(task);
    }

    return groupedData;
  }

  /// Group tasks by day and then by employee with ordered days (NEW METHOD)
  Map<String, Map<String, Map<String, dynamic>>>
      groupTasksByDayAndEmployeeOrdered() {
    final Map<String, Map<String, Map<String, dynamic>>> groupedData = {};

    // First, group all tasks (same as before)
    for (var task in allTasks) {
      final day = task.dayOfWeek ?? "Unknown Day";
      final employeeId = task.assignedTo?.id ?? "Unknown Employee";

      if (!groupedData.containsKey(day)) {
        groupedData[day] = {};
      }

      if (!groupedData[day]!.containsKey(employeeId)) {
        final isOffDay = task.assignedTo?.workingDay != null &&
            !task.assignedTo!.workingDay!.contains(day);

        final workingDayString =
            task.assignedTo?.workingDay?.join(', ') ?? "Not specified";

        groupedData[day]![employeeId] = {
          'tasks': <Result>[],
          'isOffDay': isOffDay,
          'offDay': isOffDay ? day : null,
          'isWorkingDay': !isOffDay,
          'workingDay': workingDayString,
        };
      }

      groupedData[day]![employeeId]!['tasks'].add(task);
    }

    // Create ordered map
    final Map<String, Map<String, Map<String, dynamic>>> orderedGroupedData =
        {};
    final List<String> orderedDays = getOrderedDays();

    // Add days in order, but only if they have data
    for (String day in orderedDays) {
      if (groupedData.containsKey(day)) {
        orderedGroupedData[day] = groupedData[day]!;
      }
    }

    // Add any remaining days that weren't in the standard list (like "Unknown Day")
    for (String day in groupedData.keys) {
      if (!orderedGroupedData.containsKey(day)) {
        orderedGroupedData[day] = groupedData[day]!;
      }
    }

    return orderedGroupedData;
  }

  ///==================================✅✅Get All Tasks✅✅=======================

  Future<void> getAllTasks() async {
    isLoading.value = true;

    try {
      final response =
          await apiClient.get(url: ApiUrl.getSortTask, showResult: true);

      if (response.statusCode == 200 && response.body["data"] != null) {
        final dynamic resultData = response.body["data"]['result'];

        // Create a temporary list to hold parsed results
        final List<Result> parsedTasks = <Result>[];

        // Handle different response structures
        if (resultData is List) {
          // Case 1: When result is an empty array or array of tasks
          print('📋 Result is a List with ${resultData.length} items');

          for (var taskJson in resultData) {
            try {
              final Result task =
                  Result.fromJson(taskJson as Map<String, dynamic>);
              parsedTasks.add(task);
            } catch (e) {
              print('❌ Error parsing task from list: $e');
              print('Task data: $taskJson');
            }
          }
        } else if (resultData is Map<String, dynamic>) {
          // Case 2: When result is organized by days (Sunday, Monday, etc.)
          print(
              '📋 Result is a Map organized by days: ${resultData.keys.join(', ')}');

          // Iterate through each day and its tasks
          for (String day in resultData.keys) {
            final List<dynamic> dayTasks = resultData[day] as List<dynamic>;

            // Parse each task for this day
            for (var taskJson in dayTasks) {
              try {
                final Result task =
                    Result.fromJson(taskJson as Map<String, dynamic>);
                parsedTasks.add(task);
              } catch (e) {
                print('❌ Error parsing individual task for $day: $e');
                print('Task data: $taskJson');
              }
            }
          }
        } else {
          print('⚠️ Unknown result data structure: ${resultData.runtimeType}');
        }

        // Update tasks using our safe method
        setAllTasks(parsedTasks);

        print('✅ Status Code: ${response.statusCode}');
        print('✅ Task Count: ${allTasks.length}');

        if (resultData is Map<String, dynamic>) {
          print('✅ Days with tasks: ${resultData.keys.join(', ')}');
        }
      } else {
        print("⚠️ Error: Unexpected API Response");
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print('❌ Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
