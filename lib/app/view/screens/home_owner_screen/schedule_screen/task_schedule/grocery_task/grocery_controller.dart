import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/dependency/path.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/data/service/api_check.dart';
import 'package:tidybayte/app/utils/ToastMsg/toast_message.dart';
import 'package:tidybayte/app/data/model/owner_model/grocery_model/grocery_model.dart';

class GroceryController extends GetxController {
  ApiClient apiClient = serviceLocator();

  // Form controllers
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  // Selected data
  RxList<String> groceryItems = <String>[].obs;
  String assignedId = "";

  // Loading states
  RxBool isAddGroceryLoading = false.obs;
  RxBool isLoading = false.obs;

  // Tab selection
  RxInt selectedTabIndex = 0.obs;

  // Grocery data
  RxList<GroceryModel> groceryData = <GroceryModel>[].obs;

  /// ============================ ✅ Fetch Grocery Data ============================
  Future<void> fetchGroceryData() async {
    await getMyGrocery(apiUrl: ApiUrl.getGroceryOngoing);
  }

  /// ============================ ✅ Get My Grocery ============================
  Future<void> getMyGrocery({required String apiUrl}) async {
    isLoading.value = true;

    try {
      final response = await apiClient.get(url: apiUrl, showResult: true);

      if (response.statusCode == 200) {
        var responseBody = response.body;
        var data = responseBody["data"];
        var result = data["result"];

        List<GroceryModel> groceries = [];

        if (result != null) {
          for (var item in result) {
            try {
              groceries.add(GroceryModel.fromJson(item));
            } catch (e) {
              print('Error parsing grocery item: $e');
            }
          }
        }

        groceryData.value = groceries;
        print("✅ Loaded ${groceries.length} grocery items");
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print('❌ Error fetching grocery data: $e');
      groceryData.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// ============================ ✅ Add Grocery Task ============================
  Future<void> addGrocery() async {
    if (groceryItems.isEmpty) {
      toastMessage(message: "Please select at least one grocery item");
      return;
    }
    if (assignedId.isEmpty) {
      toastMessage(message: "Please select an employee");
      return;
    }
    if (startDateController.text.isEmpty) {
      toastMessage(message: "Please select a date");
      return;
    }
    if (startTimeController.text.isEmpty) {
      toastMessage(message: "Please select start time");
      return;
    }
    if (endTimeController.text.isEmpty) {
      toastMessage(message: "Please select end time");
      return;
    }

    isAddGroceryLoading.value = true;

    try {
      final startDate = startDateController.text;
      final startTime = startTimeController.text;
      final endTime = endTimeController.text;

      String startDateTime = _convertToDateTime(startDate, startTime);
      String endDateTime = _convertToDateTime(startDate, endTime);

      var body = {
        "assignedTo": {"_id": assignedId},
        "groceryList": groceryItems.toList(),
        "startDateStr": startDate,
        "startTimeStr": startTime,
        "endDateStr": startDate,
        "endTimeStr": endTime,
        "recurrence": "",
        "startDateTime": startDateTime,
        "endDateTime": endDateTime,
      };

      final response = await apiClient.post(
        url: ApiUrl.addGrocery,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Grocery added successfully to backend");

        toastMessage(
          message: response.body["message"] ?? "Grocery task added successfully",
        );

        // ✅ Clear form first
        clearForm();

        // ✅ Set to Pending tab
        selectedTabIndex.value = 0;

        // ✅ Wait a bit to ensure backend updates
        await Future.delayed(const Duration(milliseconds: 500));

        // ✅ Force immediate refresh of the pending list
        print("🔄 Forcing immediate refresh of pending list...");
        await getMyGrocery(apiUrl: ApiUrl.getGroceryOngoing);
        print("✅ Pending list updated with ${groceryData.length} items");

        // ✅ Close the add grocery screen
        Get.back(result: true);
      } else {
        toastMessage(
          message: response.body["message"] ?? "Failed to add grocery task",
        );
      }
    } catch (e) {
      print('❌ Error adding grocery: $e');
      toastMessage(message: "Something went wrong");
    } finally {
      isAddGroceryLoading.value = false;
    }
  }

  /// ============================ ✅ Convert Date & Time to DateTime String ============================
  String _convertToDateTime(String dateStr, String timeStr) {
    try {
      // Parse date (MM/dd/yyyy)
      final dateParts = dateStr.split('/');
      final month = int.parse(dateParts[0]);
      final day = int.parse(dateParts[1]);
      final year = int.parse(dateParts[2]);

      // Parse time (hh:mm a)
      final timeParts = timeStr.split(' ');
      final hourMinute = timeParts[0].split(':');
      int hour = int.parse(hourMinute[0]);
      final minute = int.parse(hourMinute[1]);
      final period = timeParts[1].toUpperCase();

      // Convert to 24-hour format
      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }

      // Create DateTime object
      final dateTime = DateTime(year, month, day, hour, minute);

      // Return in ISO 8601 format
      return dateTime.toIso8601String();
    } catch (e) {
      print('Error converting date/time: $e');
      return DateTime.now().toIso8601String();
    }
  }

  /// ============================ ✅ Remove Grocery ============================
  Future<void> removeGrocery({required String groceryId}) async {
    try {
      var body = {"groceryId": groceryId};
      var response = await apiClient.delete(
        body: body,
        url: ApiUrl.groceryDelete,
      );

      if (response.statusCode == 200) {
        toastMessage(message: response.body["message"] ?? "Grocery deleted successfully");

        // ✅ Refresh the current grocery list instantly
        print("🔄 Refreshing after delete...");
        await refreshCurrentGroceryList();
        print("✅ Grocery deleted and list refreshed");
      } else {
        toastMessage(message: response.body["message"] ?? "Failed to delete grocery");
      }
    } catch (e) {
      print('❌ Error removing grocery: $e');
      toastMessage(message: "Something went wrong");
    }
  }

  /// ============================ ✅ Refresh Current Grocery List ============================
  Future<void> refreshCurrentGroceryList() async {
    print("🔄 Refreshing grocery list for tab: ${selectedTabIndex.value}");

    String apiUrl;

    if (selectedTabIndex.value == 0) {
      // Pending grocery - use getGroceryOngoing
      apiUrl = ApiUrl.getGroceryOngoing;
    } else if (selectedTabIndex.value == 1) {
      // Completed grocery
      apiUrl = ApiUrl.groceryComplete;
    } else {
      // Default to pending
      apiUrl = ApiUrl.getGroceryOngoing;
    }

    await getMyGrocery(apiUrl: apiUrl);
  }

  /// ============================ ✅ Clear Form ============================
  void clearForm() {
    groceryItems.clear();
    assignedId = "";
    startDateController.clear();
    startTimeController.clear();
    endTimeController.clear();
  }

  @override
  void onClose() {
    startDateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.onClose();
  }
}