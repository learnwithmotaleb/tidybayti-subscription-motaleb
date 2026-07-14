import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tidybayte/app/core/dependency/path.dart';
import 'package:tidybayte/app/data/service/api_check.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/utils/ToastMsg/toast_message.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import '../../../data/model/owner_model/grocery_model/grocery_model.dart';

class GroceryController extends GetxController {
  ApiClient apiClient = serviceLocator();

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  final rxRequestStatus = Status.loading.obs;
  final RxList<String> groceryItems = <String>[].obs;

  final groceryNameController = TextEditingController();
  final startDateController = TextEditingController();
  final startTimeController = TextEditingController();
  final endDateController = TextEditingController();
  final endTimeController = TextEditingController();

  late String assignedId = "";
  void setGroceryItems(Map<String, String> map) {
    groceryItems.value = map.values.toList(); // only values matter
  }

  clearGroceryField() {
    groceryNameController.clear();

    startDateController.clear();
    startTimeController.clear();
    endTimeController.clear();
    endDateController.clear();
    groceryItems.clear();
    assignedId = "";
  }

  ///==================================✅✅addGrocery Method✅✅=======================

  RxBool isAddGroceryLoading = false.obs;

  addGrocery() async {
    isAddGroceryLoading.value = true;

    if (groceryItems.isEmpty) {
      toastMessage(message: "Please add at least one grocery item.");
      isAddGroceryLoading.value = false;
      return;
    }

    try {
      final inputFormat = DateFormat('MM/dd/yyyy hh:mm a');

      final startDateTime = inputFormat
          .parse("${startDateController.text} ${startTimeController.text}");
      final endDateTime = inputFormat
          .parse("${startDateController.text} ${endTimeController.text}");

      var body = {
        "assignedTo": {"_id": assignedId},
        "groceryList": groceryItems,
        "startDateStr": startDateController.text,
        "startTimeStr": startTimeController.text,
        "endDateStr": startDateController.text,
        "endTimeStr": endTimeController.text,
        "recurrence": "",
        "startDateTime": startDateTime.toIso8601String(),
        "endDateTime": endDateTime.toIso8601String(),
      };

      var response = await apiClient.post(body: body, url: ApiUrl.addGrocery);
      if (response.statusCode == 201) {
        fetchGroceryData();
        clearGroceryField();
        toastMessage(message: response.body["message"]);
        Get.back(result: {"refresh": true});


      } else if (response.statusCode == 400) {
        toastMessage(message: response.body["message"]);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print('Error in addGrocery: $e');
      toastMessage(message: 'Invalid date or time format');
    } finally {
      isAddGroceryLoading.value = false;
      isAddGroceryLoading.refresh();
    }
  }

  ///==================================✅✅remove Grocery✅✅=======================

  RxBool isRemoveGrocery = false.obs;

  removeGrocery({required String groceryId}) async {
    isRemoveGrocery.value = true;
    var body = {"groceryId": groceryId};

    var response =
        await apiClient.delete(body: body, url: ApiUrl.groceryDelete);
    if (response.statusCode == 200) {
      fetchGroceryData();
      toastMessage(message: response.body["message"]);
    } else if (response.statusCode == 400) {
      toastMessage(message: response.body["message"]);
    } else {
      ApiChecker.checkApi(response);
    }
    isRemoveGrocery.value = false;
    isRemoveGrocery.refresh();
  }

  ///==================================✅✅getMyGrocery✅✅=======================

  RxList<GroceryModel> groceryData = <GroceryModel>[].obs;
  RxInt selectedTabIndex = 0.obs;
  RxBool isLoading = false.obs;
  var selectedDayIndex = 0.obs;

  Future<void> getMyGrocery({required String apiUrl}) async {
    isLoading.value = true;
    setRxRequestStatus(Status.loading);
    refresh();

    try {
      final response = await apiClient.get(url: apiUrl, showResult: true);

      if (response.statusCode == 200) {
        // FIXED: Access the nested structure correctly
        var responseBody = response.body;
        var data = responseBody["data"];
        var result = data["result"]; // This is the actual array

        // Convert each item manually to handle any parsing issues
        List<GroceryModel> groceryList = [];

        if (result != null && result is List) {
          for (var item in result) {
            try {
              groceryList.add(GroceryModel.fromJson(item));
            } catch (e) {
              print('Error parsing individual grocery item: $e');
              // Continue with other items even if one fails
            }
          }
        }

        groceryData.value = groceryList;
        print('StatusCode==================${response.statusCode}');
        print('Parsed ${groceryList.length} grocery items successfully');

        setRxRequestStatus(Status.completed);
        refresh();
      } else {
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      setRxRequestStatus(Status.error);
      print('Error fetching data: $e');
      groceryData.value = []; // Clear the list on error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchGroceryData() async {
    await getMyGrocery(apiUrl: ApiUrl.getGroceryOngoing);
  }
}
