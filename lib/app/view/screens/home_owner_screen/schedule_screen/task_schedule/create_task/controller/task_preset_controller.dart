import 'package:get/get.dart';
import 'package:tidybayte/app/core/dependency/path.dart';
import 'package:tidybayte/app/data/service/api_check.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/local_db/local_db.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import '../models/task_name_model.dart';
import '../models/task_name_room_model.dart';

class TaskPresetController extends GetxController {
  /// Dependencies
  final ApiClient apiClient = serviceLocator();
  final DBHelper dbHelper = serviceLocator();

  /// State
  final rxRequestStatus = Status.loading.obs;
  final isLoading = false.obs;

  /// Data Models
  Rx<TaskNameModel> taskPreset = TaskNameModel().obs;
  Rx<TaskNameRoomModel> taskPresetRoom = TaskNameRoomModel().obs;

  /// Parameters
  RxString selectedRoom = ''.obs;

  /// ============================ ✅ Helpers ============================
  void setLoading(bool value) => isLoading.value = value;
  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;

  /// ============================ ✅ Fetch Task Presets ============================
  Future<void> getTaskPresets() async {
    setRxRequestStatus(Status.loading);
    setLoading(true);

    try {
      final url = ApiUrl.taskPresets;

      final response = await apiClient.get(url: url, showResult: true);

      if (response.statusCode == 200) {
        final body = response.body;

        // ✅ Room-specific (returns list)
        if (body['data'] is Map) {
          final Map<String, dynamic> mapData =
              Map<String, dynamic>.from(body['data']);

          // Flatten all room lists into one big list
          final allTasks = <TaskNameData>[];
          mapData.forEach((roomName, taskList) {
            for (var item in taskList) {
              allTasks.add(TaskNameData.fromJson(item));
            }
          });

          taskPreset.value = TaskNameModel(
            statusCode: body['statusCode'],
            success: body['success'],
            message: body['message'],
            data: allTasks,
          );
          print(
              "🧩 General presets loaded successfully (merged ${allTasks.length} tasks)");
        }

        setRxRequestStatus(Status.completed);
      } else {
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print("❌ Error fetching task presets: $e");
      setRxRequestStatus(Status.error);
    } finally {
      setLoading(false);
    }
  }

  /// ============================ ✅ Lifecycle ============================
  @override
  void onInit() {
    super.onInit();
    // Optionally auto-load general presets
    getTaskPresets();
  }
}
