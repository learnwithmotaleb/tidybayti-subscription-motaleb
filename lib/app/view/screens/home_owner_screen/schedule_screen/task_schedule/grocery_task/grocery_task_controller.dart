import 'package:get/get.dart';
import 'package:tidybayte/app/core/dependency/path.dart';
import 'package:tidybayte/app/data/service/api_check.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/utils/ToastMsg/toast_message.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';

import '../../../../../../data/model/owner_model/grocery_task_model.dart';

class GroceryTaskController extends GetxController {
  ApiClient apiClient = serviceLocator();

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  final rxRequestStatus = Status.loading.obs;

  var selectedDayIndex = 0.obs; // ✅ Changed from Rxn<int> to 0.obs for better default

  ///==================================✅✅Get All Task✅✅=======================
  RxList<GroceryTaskModel> taskList = <GroceryTaskModel>[].obs;

  Future<void> getTaskData({required String apiUrl}) async {
    setRxRequestStatus(Status.loading);
    refresh();

    try {
      final response = await apiClient.get(url: apiUrl, showResult: true);

      if (response.statusCode == 200) {
        var responseBody = response.body;
        var data = responseBody["data"];
        var result = data["result"];

        List<GroceryTaskModel> groceryTasks = [];

        if (result != null) {
          for (var item in result) {
            try {
              groceryTasks.add(GroceryTaskModel.fromJson(item));
            } catch (e) {
              print('Error parsing individual item: $e');
            }
          }
        }

        taskList.value = groceryTasks;
        print("✅ Loaded ${groceryTasks.length} grocery tasks");
        setRxRequestStatus(Status.completed);
      } else {
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      setRxRequestStatus(Status.error);
      print('Error fetching data: $e');
      taskList.value = [];
    } finally {
      refresh();
    }
  }

  ///==================================✅✅Remove Task✅✅=======================
  RxBool isRemoveTask = false.obs;

  Future<void> removeTask({required String taskId}) async {
    isRemoveTask.value = true;
    var body = {"taskId": taskId.toString()};

    try {
      var response = await apiClient.delete(body: body, url: ApiUrl.taskDelete);

      if (response.statusCode == 200) {
        toastMessage(message: response.body["message"]);

        // ✅ Instantly refresh the task list after successful deletion
        await refreshCurrentTaskList();
        print("✅ Task deleted and list refreshed");
      } else if (response.statusCode == 400) {
        toastMessage(message: response.body["message"]);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print('Error removing task: $e');
      toastMessage(message: "Failed to remove task");
    } finally {
      isRemoveTask.value = false;
      isRemoveTask.refresh();
    }
  }

  ///==================================✅✅Refresh Current Task List✅✅=======================
  Future<void> refreshCurrentTaskList() async {
    print("🔄 Refreshing task list for index: ${selectedDayIndex.value}");

    final selectedIndex = selectedDayIndex.value;

    if (selectedIndex == 0) {
      // Refresh One time tasks
      await getTaskData(apiUrl: ApiUrl.getPendingTask);
    } else if (selectedIndex == 1) {
      // Refresh Recurrence tasks
      await getTaskData(apiUrl: ApiUrl.getCompleteTask); // ⚠️ Replace with actual recurrence API
    } else {
      // Default: refresh pending tasks
      await getTaskData(apiUrl: ApiUrl.getPendingTask);
    }
  }

  ///==================================✅✅Lifecycle✅✅=======================
  @override
  void onInit() {
    super.onInit();
    // Load initial data
    selectedDayIndex.value = 0;
    getTaskData(apiUrl: ApiUrl.getPendingTask);
  }
}


/*
import 'package:get/get.dart';
import 'package:tidybayte/app/core/dependency/path.dart';
import 'package:tidybayte/app/data/service/api_check.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/utils/ToastMsg/toast_message.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';

import '../../../../../../data/model/owner_model/grocery_task_model.dart';

class GroceryTaskController extends GetxController {
  ApiClient apiClient = serviceLocator();

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  final rxRequestStatus = Status.loading.obs;

  var selectedDayIndex = Rxn<int>();

  ///==================================✅✅Get All Task✅✅=======================
  RxList<GroceryTaskModel> taskList = <GroceryTaskModel>[].obs;

  Future<void> getTaskData({required String apiUrl}) async {
    setRxRequestStatus(Status.loading);
    refresh();

    try {
      final response = await apiClient.get(url: apiUrl, showResult: true);

      if (response.statusCode == 200) {
        // Don't cast anything - just access the data step by step
        var responseBody = response.body;
        var data = responseBody["data"];
        var result = data["result"];

        // Convert each item manually without casting the entire list at once
        List<GroceryTaskModel> groceryTasks = [];

        if (result != null) {
          for (var item in result) {
            try {
              groceryTasks.add(GroceryTaskModel.fromJson(item));
            } catch (e) {
              print('Error parsing individual item: $e');
            }
          }
        }

        taskList.value = groceryTasks;
        setRxRequestStatus(Status.completed);
      } else {
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      setRxRequestStatus(Status.error);
      print('Error fetching data: $e');
      taskList.value = [];
    } finally {
      refresh();
    }
  }

  ///==================================✅✅Remove Task✅✅=======================
  RxBool isRemoveTask = false.obs;

  removeTask({required String taskId}) async {
    isRemoveTask.value = true;
    var body = {"taskId": taskId.toString()};

    var response = await apiClient.delete(body: body, url: ApiUrl.taskDelete);
    if (response.statusCode == 200) {
      toastMessage(message: response.body["message"]);
    } else if (response.statusCode == 400) {
      toastMessage(message: response.body["message"]);
    } else {
      ApiChecker.checkApi(response);
    }
    isRemoveTask.value = false;
    isRemoveTask.refresh();
  }
}
*/
