import 'package:get/get.dart';
import 'package:tidybayte/app/core/dependency/path.dart';
import 'package:tidybayte/app/data/model/owner_model/work_schedule/user_task_model.dart';
import 'package:tidybayte/app/data/service/api_check.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';

class DownloadController extends GetxController {
  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  final rxRequestStatus = Status.loading.obs;
  ApiClient apiClient = serviceLocator();
  Rx<Data> userTaskData = Data().obs;

  Future<void> getUserTask({required String dayName}) async {
    setRxRequestStatus(Status.loading);

    try {
      String apiUrl = dayName == "All"
          ? ApiUrl.userAllTasks
          : ApiUrl.userDayOfTask(dayName);

      print("Fetching tasks from: $apiUrl");

      final response = await apiClient.get(url: apiUrl, showResult: true);

      if (response.statusCode == 200 && response.body["data"] != null) {
        userTaskData.value = Data.fromJson(response.body["data"]);

        print('✅ Status Code: ${response.statusCode}');
        print('✅ Task Count: ${userTaskData.value.result?.length ?? 0}');

        setRxRequestStatus(Status.completed);
      } else {
        print("⚠️ Error: Unexpected API Response");
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      setRxRequestStatus(Status.error);
      print('❌ Error fetching data: $e');
    }
  }
}
