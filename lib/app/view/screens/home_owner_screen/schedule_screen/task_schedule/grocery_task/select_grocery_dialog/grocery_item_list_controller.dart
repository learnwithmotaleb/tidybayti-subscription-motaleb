import 'package:get/get.dart';
import 'package:tidybayte/app/core/dependency/path.dart';
import 'package:tidybayte/app/data/service/api_check.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/local_db/local_db.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'groceries_model.dart';

class GroceryItemListController extends GetxController {
  /// Dependencies
  final ApiClient apiClient = serviceLocator();
  final DBHelper dbHelper = serviceLocator();

  /// State
  final rxRequestStatus = Status.loading.obs;
  final isLoading = false.obs;

  /// Grocery data
  Rx<GroceriesModel> groceries = GroceriesModel().obs;

  /// Selected category and items
  RxString selectedCategory = ''.obs;
  RxList<String> selectedItems = <String>[].obs;

  /// Loading management
  void setLoading(bool value) => isLoading.value = value;
  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;

  /// ============================ ✅ Fetch Grocery Data ============================
  Future<void> getGroceries() async {
    setRxRequestStatus(Status.loading);

    try {
      final response = await apiClient.get(
        url: ApiUrl.getGroceries, // 🧩 Replace with actual API URL
        showResult: true,
      );

      if (response.statusCode == 200) {
        groceries.value = GroceriesModel.fromJson(response.body['data']);
        print('✅ Groceries loaded successfully.');
        print('🍎 Fruits count: ${groceries.value.fruits?.length ?? 0}');
        setRxRequestStatus(Status.completed);
      } else {
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print("❌ Error fetching groceries: $e");
      setRxRequestStatus(Status.error);
    }
  }

  /// ============================ ✅ Selection Logic ============================
  void toggleItemSelection(String item) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
    } else {
      selectedItems.add(item);
    }
  }

  void clearSelections() {
    selectedItems.clear();
    selectedCategory.value = '';
  }

  /// ============================ ✅ Lifecycle ============================
  @override
  void onInit() {
    super.onInit();
    getGroceries(); // automatically fetch groceries when controller is initialized
  }
}
