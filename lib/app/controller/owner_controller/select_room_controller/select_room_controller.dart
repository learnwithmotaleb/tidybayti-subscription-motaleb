import 'package:get/get.dart';
import 'package:tidybayte/app/core/dependency/path.dart';
import 'package:tidybayte/app/data/service/api_check.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/local_db/local_db.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';

import '../../../data/model/owner_model/select_room_model.dart';

class SelectRoomController extends GetxController {
  ApiClient apiClient = serviceLocator();
  DBHelper dbHelper = serviceLocator();
  final RxBool isCprOpen = false.obs;
  final RxBool isPassportOpen = true.obs;
  final RxString selectedJobType = ''.obs;
  var isLoading = false.obs;

  void setLoading(bool value) {
    isLoading.value = value;
  }

  var isEditLoading = false.obs;

  void editLoading(bool value) {
    isEditLoading.value = value;
  }

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  final rxRequestStatus = Status.loading.obs;

  ///==================================✅✅Get Room ✅✅=======================

  RxList<Room> roomList = <Room>[].obs;
  RxString selectedRoomId = ''.obs;
  RxList<String> selectedRoomIdList = <String>[].obs;

  Future<void> getRooms({required String houseId}) async {
    setRxRequestStatus(Status.loading);
    try {
      final response = await apiClient.get(
        url:
            ApiUrl.getRoom(houseId), // 🔁 Replace with the actual rooms API URL
        showResult: true,
      );

      if (response.statusCode == 200) {
        final model = SelectRoomModel.fromJson(response.body);
        roomList.value = model.data?.rooms ?? [];

        print('Room count: ${model.data?.count}');
        print('Fetched Rooms: ${roomList.length}');

        setRxRequestStatus(Status.completed);
      } else {
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print("Error fetching rooms: $e");
      setRxRequestStatus(Status.error);
    }
  }

  @override
  void onInit() {
    // getEmployee();
    super.onInit();
  }
}
