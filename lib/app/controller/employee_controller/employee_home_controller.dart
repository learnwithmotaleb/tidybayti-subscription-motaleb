import 'package:get/get.dart';
import 'package:tidybayte/app/core/dependency/path.dart';
import 'package:tidybayte/app/data/model/owner_model/work_schedule/user_task_model.dart';
import 'package:tidybayte/app/data/service/api_check.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/utils/ToastMsg/toast_message.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';

class EmployeeHomeController extends GetxController {
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

  ///==================================✅✅Get All Task✅✅=======================
  RxBool isLoadingAdditionalTask = false.obs;
  Rx<AssignedTo?> employee = Rx<AssignedTo?>(null);

  /// Store grouped tasks by day - THIS IS WHAT THE UI USES
  RxMap<String, List<Result>> groupedTasks = RxMap<String, List<Result>>({});

  /// SIMPLIFIED: Single method to fetch and group tasks
  Future<void> getAllTasksGrouped() async {
    isLoadingAdditionalTask.value = true;
    setRxRequestStatus(Status.loading);

    try {
      final response = await apiClient.get(
          url: ApiUrl.employeeAllTaskSorted, showResult: true);

      if (response.statusCode == 200 && response.body["data"] != null) {
        // Get the result from the response (which is a Map<String, dynamic>)
        var result = response.body["data"]["result"] as Map<String, dynamic>;

        // Transform the Map<String, dynamic> into the grouped tasks
        final groupedTasksResult = groupTasksByDay(result);

        // Update the observable groupedTasks
        groupedTasks.assignAll(groupedTasksResult);
// Set employee info from first task
        if (groupedTasksResult.isNotEmpty) {
          final firstTaskList = groupedTasksResult.values.first;
          if (firstTaskList.isNotEmpty) {
            employee.value = firstTaskList.first.assignedTo;
          }
        }

        print("✅ Grouped tasks updated successfully");
        print("✅ Dates available: ${groupedTasksResult.keys.toList()}");

        setRxRequestStatus(Status.completed);
      } else {
        print("⚠️ Error: Unexpected API Response");
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print('❌ Error fetching all tasks: $e');
      setRxRequestStatus(Status.error);
    } finally {
      isLoadingAdditionalTask.value = false;
    }
  }

  /// Group tasks by day
  Map<String, List<Result>> groupTasksByDay(Map<String, dynamic> result) {
    Map<String, List<Result>> groupedTasks = {};

    result.forEach((date, tasks) {
      if (tasks is List) {
        try {
          List<dynamic> tasksList = tasks;

          List<Result> taskList = tasksList.map<Result>((dynamic task) {
            if (task is Map<String, dynamic>) {
              return Result.fromJson(task);
            } else {
              throw Exception("Task is not a valid JSON object");
            }
          }).toList();

          groupedTasks[date] = taskList;
          print("✅ Processed $date: ${taskList.length} tasks");
        } catch (e) {
          print("❌ Error processing tasks for $date: $e");
        }
      } else {
        print("⚠️ Tasks for $date is not a List: ${tasks.runtimeType}");
      }
    });

    return groupedTasks;
  }




  ///==================================✅✅getOngoing✅✅=======================
  Rx<Data> ongoing = Data().obs;

  Future<void> getOngoing() async {
    try {
      final response = await apiClient.get(
          url: ApiUrl.getEmployeeOngoingTask, showResult: true);

      if (response.statusCode == 200 && response.body["data"] != null) {
        final data = response.body["data"];

        if (data["result"] != null) {
          // Handle the Map<String, List> structure (same as getPending)
          Map<String, dynamic> resultMap = data["result"];

          // Extract all tasks from all dates into a single list
          List<Result> allTasks = [];

          resultMap.forEach((date, tasks) {
            if (tasks is List) {
              for (var task in tasks) {
                if (task is Map<String, dynamic>) {
                  allTasks.add(Result.fromJson(task));
                }
              }
            }
          });

          // Update the ongoing tasks with all tasks
          ongoing.value = Data(
            meta: data["meta"] != null ? Meta.fromJson(data["meta"]) : null,
            result: allTasks,
          );
        } else {
          // Handle empty result case
          ongoing.value = Data(
            meta: data["meta"] != null ? Meta.fromJson(data["meta"]) : null,
            result: [],
          );
        }

        print('✅ Ongoing tasks: ${ongoing.value.result?.length ?? 0}');
      } else {
        print("⚠️ Error: Unexpected API Response for ongoing tasks");
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print('❌ Error fetching ongoing tasks: $e');
    }
  }

  ///==================================✅✅getPending✅✅=======================
  // Rx<Data> pendingTask = Data().obs;
  //
  // RxBool isLoadingPendingTask = false.obs;
  // Future<void> getPending() async {
  //   try {
  //     final response = await apiClient.get(
  //         url: ApiUrl.getEmployeePendingTask, showResult: true);
  //
  //     if (response.statusCode == 200 && response.body["data"] != null) {
  //       final data = response.body["data"];
  //
  //       if (data["result"] != null) {
  //         // Handle the Map<String, List> structure
  //         Map<String, dynamic> resultMap = data["result"];
  //
  //         // Extract all tasks from all dates into a single list
  //         List<Result> allTasks = [];
  //
  //         resultMap.forEach((date, tasks) {
  //           if (tasks is List) {
  //             for (var task in tasks) {
  //               if (task is Map<String, dynamic>) {
  //                 allTasks.add(Result.fromJson(task));
  //               }
  //             }
  //           }
  //         });
  //
  //         // Update the pendingTask with all tasks
  //         pendingTask.value = Data(
  //           meta: data["meta"] != null ? Meta.fromJson(data["meta"]) : null,
  //           result: allTasks,
  //         );
  //       }
  //
  //       print('✅ Pending tasks: ${pendingTask.value.result?.length ?? 0}');
  //     } else {
  //       print("⚠️ Error: Unexpected API Response for pending tasks");
  //       ApiChecker.checkApi(response);
  //     }
  //   } catch (e) {
  //     print('❌ Error fetching pending tasks: $e');
  //   }
  // }
  //


  ///==================================✅✅getPending✅✅=======================
  Rx<Data> pendingTask = Data().obs;
  RxBool isLoadingPendingTask = false.obs;

  Future<void> getPending() async {
    isLoadingPendingTask.value = true;

    try {
      final response = await apiClient.get(
        url: ApiUrl.getEmployeePendingTask,
        showResult: true,
      );

      if (response.statusCode == 200 && response.body["data"] != null) {
        final data = response.body["data"];

        if (data["result"] != null) {
          Map<String, dynamic> resultMap = data["result"];

          List<Result> allTasks = [];

          resultMap.forEach((date, tasks) {
            if (tasks is List) {
              for (var task in tasks) {
                if (task is Map<String, dynamic>) {
                  allTasks.add(Result.fromJson(task));
                }
              }
            }
          });

          pendingTask.value = Data(
            meta: data["meta"] != null
                ? Meta.fromJson(data["meta"])
                : null,
            result: allTasks,
          );
        }

        print('✅ Pending tasks: ${pendingTask.value.result?.length ?? 0}');
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print('❌ Error fetching pending tasks: $e');
    } finally {
      isLoadingPendingTask.value = false;
    }
  }


  ///==================================✅✅getComplete✅✅=======================
  // Rx<Data> completeTask = Data().obs;
  // RxBool isLoadingCompletedTask = false.obs;
  //
  // Future<void> getComplete() async {
  //   try {
  //     final response = await apiClient.get(
  //         url: ApiUrl.getEmployeeCompletedTask, showResult: true);
  //
  //     if (response.statusCode == 200 && response.body["data"] != null) {
  //       print("Complete API called");
  //       final data = response.body["data"];
  //
  //       if (data["result"] != null) {
  //         // Handle the Map<String, List> structure (same as getPending)
  //         Map<String, dynamic> resultMap = data["result"];
  //
  //         // Extract all tasks from all dates into a single list
  //         List<Result> allTasks = [];
  //
  //         resultMap.forEach((date, tasks) {
  //           if (tasks is List) {
  //             for (var task in tasks) {
  //               if (task is Map<String, dynamic>) {
  //                 allTasks.add(Result.fromJson(task));
  //               }
  //             }
  //           }
  //         });
  //
  //         // Update the complete tasks with all tasks
  //         completeTask.value = Data(
  //           meta: data["meta"] != null ? Meta.fromJson(data["meta"]) : null,
  //           result: allTasks,
  //         );
  //       } else {
  //         // Handle empty result case
  //         completeTask.value = Data(
  //           meta: data["meta"] != null ? Meta.fromJson(data["meta"]) : null,
  //           result: [],
  //         );
  //       }
  //
  //       print('✅ Complete tasks: ${completeTask.value.result?.length ?? 0}');
  //     } else {
  //       print("⚠️ Error: Unexpected API Response for complete tasks");
  //       ApiChecker.checkApi(response);
  //     }
  //   } catch (e) {
  //     print('❌ Error fetching complete tasks: $e');
  //   }
  // }








  ///==================================✅✅getComplete✅✅=======================
  Rx<Data> completeTask = Data().obs;
  RxBool isLoadingCompletedTask = false.obs;

  Future<void> getComplete() async {
    isLoadingCompletedTask.value = true;

    try {
      final response = await apiClient.get(
        url: ApiUrl.getEmployeeCompletedTask,
        showResult: true,
      );

      if (response.statusCode == 200 && response.body["data"] != null) {
        final data = response.body["data"];

        if (data["result"] != null) {
          Map<String, dynamic> resultMap = data["result"];

          List<Result> allTasks = [];

          resultMap.forEach((date, tasks) {
            if (tasks is List) {
              for (var task in tasks) {
                if (task is Map<String, dynamic>) {
                  allTasks.add(Result.fromJson(task));
                }
              }
            }
          });

          completeTask.value = Data(
            meta: data["meta"] != null
                ? Meta.fromJson(data["meta"])
                : null,
            result: allTasks,
          );
        } else {
          completeTask.value = Data(
            meta: data["meta"] != null
                ? Meta.fromJson(data["meta"])
                : null,
            result: [],
          );
        }

        print('✅ Complete tasks: ${completeTask.value.result?.length ?? 0}');
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print('❌ Error fetching complete tasks: $e');
    } finally {
      isLoadingCompletedTask.value = false;
    }
  }

  ///==================================✅✅PendingTask✅✅=======================
  RxBool isPendingTask = false.obs;
  RxString pendingTaskId = "".obs;

  employeePendingTask({required String taskId, required String status}) async {
    isPendingTask.value = true;
    pendingTaskId.value = taskId;

    var body = {"taskId": taskId, "status": status};

    try {
      var response =
          await apiClient.patch(body: body, url: ApiUrl.updateStatus);

      if (response.statusCode == 200) {
        print(response.body);
        toastMessage(message: response.body["message"]);

        // Refresh all relevant data after status update
        await getPending();
        await getOngoing();
        await getAllTasksGrouped(); // Refresh the grouped tasks too
      } else if (response.statusCode == 400) {
        toastMessage(message: response.body["message"]);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print("❌ Error updating task status: $e");
    } finally {
      isPendingTask.value = false;
      pendingTaskId.value = "";
    }
  }

  @override
  void onInit() {
    // Only call the methods you actually need
    getPending();
    getOngoing();
    getAllTasksGrouped(); // This is what the home screen uses
    super.onInit();
  }
}
