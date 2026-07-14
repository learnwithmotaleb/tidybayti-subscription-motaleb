// import 'package:get/get.dart';
// import 'package:tidybayte/app/core/dependency/path.dart';
// import 'package:tidybayte/app/data/model/owner_model/all_room_model.dart';
// import 'package:tidybayte/app/data/service/api_check.dart';
// import 'package:tidybayte/app/data/service/api_client.dart';
// import 'package:tidybayte/app/data/service/api_url.dart';
// import 'package:tidybayte/app/utils/ToastMsg/toast_message.dart';
// import 'package:tidybayte/app/utils/app_const/app_const.dart';
// import '../../../view/screens/home_owner_screen/schedule_screen/task_schedule/task_schedule_models.dart';
//
// class TaskController extends GetxController {
//   ApiClient apiClient = serviceLocator();
//
//   /// Request status (loading, completed, error)
//   final rxRequestStatus = Status.loading.obs;
//   void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
//
//   var selectedDayIndex = Rxn<int>();
//
//   ///================================== ✅ Get All Room ============================
//   Rx<RoomList> roomModel = RoomList().obs;
//
//   getAllRoom() async {
//     setRxRequestStatus(Status.loading);
//     refresh();
//
//     try {
//       final response =
//           await apiClient.get(url: ApiUrl.allRoom, showResult: true);
//
//       if (response.statusCode == 200) {
//         roomModel.value = RoomList.fromJson(response.body["data"]);
//         setRxRequestStatus(Status.completed);
//         refresh();
//       } else {
//         setRxRequestStatus(Status.error);
//         ApiChecker.checkApi(response);
//       }
//     } catch (e) {
//       setRxRequestStatus(Status.error);
//     }
//   }
//
//   ///================================== ✅ Get All Task ============================
//   RxList<TaskScheduleModels> taskList = <TaskScheduleModels>[].obs;
//
//   Future<void> getTaskData({required String apiUrl}) async {
//     setRxRequestStatus(Status.loading);
//     refresh();
//
//     try {
//       final response = await apiClient.get(url: apiUrl, showResult: true);
//
//       if (response.statusCode == 200) {
//         final dynamic resultData = response.body["data"];
//
//         if (resultData != null) {
//           // Handle empty object case
//           if (resultData['result'] is Map &&
//               (resultData['result'] as Map).isEmpty) {
//             taskList.value = [];
//           } else if (resultData['result'] is List) {
//             taskList.value = (resultData['result'] as List)
//                 .map((e) => TaskScheduleModels.fromJson(e))
//                 .toList();
//           } else {
//             taskList.value = [];
//           }
//
//           setRxRequestStatus(Status.completed);
//         } else {
//           setRxRequestStatus(Status.error);
//           print('Error: Data field is null in the API response.');
//         }
//       } else {
//         setRxRequestStatus(Status.error);
//         ApiChecker.checkApi(response);
//       }
//     } catch (e) {
//       setRxRequestStatus(Status.error);
//       print('Error fetching and parsing data: $e');
//     } finally {
//       refresh();
//     }
//   }
//
//   ///================================== ✅ Remove Task ============================
//   RxBool isRemoveTask = false.obs;
//
//   removeTask({required String taskId}) async {
//     isRemoveTask.value = true;
//
//     var body = {
//       "taskId": taskId,
//     };
//
//     try {
//       final response =
//           await apiClient.delete(body: body, url: ApiUrl.taskDelete);
//
//       if (response.statusCode == 200 || response.statusCode == 400) {
//         toastMessage(message: response.body["message"]);
//       } else {
//         ApiChecker.checkApi(response);
//       }
//     } catch (e) {
//       print('Error while deleting task: $e');
//     }
//
//     isRemoveTask.value = false;
//     isRemoveTask.refresh();
//   }
//
//   ///================================== ✅ On Init ============================
//   @override
//   void onInit() {
//     getAllRoom();
//     super.onInit();
//   }
// }





import 'package:get/get.dart';
import 'package:tidybayte/app/core/dependency/path.dart';
import 'package:tidybayte/app/data/model/owner_model/all_room_model.dart';
import 'package:tidybayte/app/data/service/api_check.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/utils/ToastMsg/toast_message.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import '../../../view/screens/home_owner_screen/schedule_screen/task_schedule/task_schedule_models.dart';

class TaskController extends GetxController {
  ApiClient apiClient = serviceLocator();



  /// Room এর জন্য আলাদা status ✅
  final rxRoomRequestStatus = Status.loading.obs;
  void setRxRoomRequestStatus(Status value) => rxRoomRequestStatus.value = value;

  var selectedDayIndex = Rxn<int>();

  ///================================== ✅ Get All Room ============================
  Rx<RoomList> roomModel = RoomList().obs;

  getAllRoom() async {
    setRxRoomRequestStatus(Status.loading); // ✅ Room এর নিজের status
    refresh();

    try {
      final response =
      await apiClient.get(url: ApiUrl.allRoom, showResult: true);

      if (response.statusCode == 200) {
        roomModel.value = RoomList.fromJson(response.body["data"]);
        setRxRoomRequestStatus(Status.completed); // ✅ Room এর নিজের status
        refresh();
      } else {
        setRxRoomRequestStatus(Status.error); // ✅ Room এর নিজের status
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      setRxRoomRequestStatus(Status.error); // ✅ Room এর নিজের status
    }
  }

  ///================================== ✅ Get All Task ============================


  /// Task এর জন্য status
  final rxRequestStatus = Status.loading.obs;
  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;


  RxList<TaskScheduleModels> taskList = <TaskScheduleModels>[].obs;

  Future<void> getTaskData({required String apiUrl}) async {
    setRxRequestStatus(Status.loading); // ✅ Task এর নিজের status
    refresh();

    try {
      final response = await apiClient.get(url: apiUrl, showResult: true);

      if (response.statusCode == 200) {
        final dynamic resultData = response.body["data"];

        if (resultData != null) {
          if (resultData['result'] is Map &&
              (resultData['result'] as Map).isEmpty) {
            taskList.value = [];
          } else if (resultData['result'] is List) {
            taskList.value = (resultData['result'] as List)
                .map((e) => TaskScheduleModels.fromJson(e))
                .toList();
          } else {
            taskList.value = [];
          }

          setRxRequestStatus(Status.completed); // ✅ Task এর নিজের status
        } else {
          setRxRequestStatus(Status.error);
          print('Error: Data field is null in the API response.');
        }
      } else {
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      setRxRequestStatus(Status.error);
      print('Error fetching and parsing data: $e');
    } finally {
      refresh();
    }
  }

  ///================================== ✅ Remove Task ============================
  RxBool isRemoveTask = false.obs;

  removeTask({required String taskId}) async {
    isRemoveTask.value = true;

    var body = {
      "taskId": taskId,
    };

    try {
      final response =
      await apiClient.delete(body: body, url: ApiUrl.taskDelete);

      if (response.statusCode == 200 || response.statusCode == 400) {
        toastMessage(message: response.body["message"]);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print('Error while deleting task: $e');
    }

    isRemoveTask.value = false;
    isRemoveTask.refresh();
  }

  ///================================== ✅ On Init ============================
  @override
  void onInit() {
    getAllRoom();
    super.onInit();
  }
}
