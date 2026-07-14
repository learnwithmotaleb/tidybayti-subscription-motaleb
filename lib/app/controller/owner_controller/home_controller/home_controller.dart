import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tidybayte/app/core/dependency/path.dart';
import 'package:tidybayte/app/data/model/owner_model/get_room_model.dart';
import 'package:tidybayte/app/data/model/owner_model/my_house_model.dart'
as myHouse;
import 'package:tidybayte/app/data/model/owner_model/single_room_model.dart';
import 'package:tidybayte/app/data/service/api_check.dart';
import 'package:tidybayte/app/data/service/api_client.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/utils/ToastMsg/toast_message.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';

import '../../../global/helper/shared_prefe/shared_prefe.dart';

class HomeController extends GetxController {




  Future<void> refreshAfterHouseCreate() async {
    await myAllHouse();

    final houses = myHouseData.value.houses;

    if (houses != null && houses.isNotEmpty) {
      final latestHouse = houses.last;

      selectedHouse.value = latestHouse;
      selectedHouseId.value = latestHouse.id ?? '';
      selectedHouseName.value = latestHouse.name ?? '';

      await SharePrefsHelper.saveSelectedHouse(
        latestHouse.id ?? '',
        latestHouse.name ?? '',
      );

      await getHouseRoom(
        houseId: latestHouse.id ?? '',
      );
    }

    myHouseData.refresh();
    houseRoomData.refresh();
    refresh();
  }




  ApiClient apiClient = serviceLocator();
  final houseNameController = TextEditingController();
  final roomNameController = TextEditingController();

  String selectedIconPath = AppIcons.livingRoom;

  List<String> images = [
    AppIcons.livingRoom,
    AppIcons.gym,
    AppIcons.bedroom,
    AppIcons.bathroom,
    AppIcons.diningRoom,
    AppIcons.kitchen,
    AppIcons.pantry,
    AppIcons.guestRoom,
    AppIcons.storeRoom,
    AppIcons.laundryRoom,
    AppIcons.closet,
    AppIcons.garage,
    AppIcons.basement,
    AppIcons.attic,
    AppIcons.studyRoom,
    AppIcons.library,
    AppIcons.workshop,
    AppIcons.studio,
    AppIcons.familyRoom,
    AppIcons.homeTheater,
    AppIcons.gameRoom,
    AppIcons.bar,
    AppIcons.playroom,
    AppIcons.sauna,
    AppIcons.spa,
    AppIcons.garden,
    AppIcons.balcony,
    AppIcons.pool,
    AppIcons.dressingRoom,
  ];

  final RxBool isExpanded = false.obs;
  final RxString selectedHouseId = ''.obs;
  final RxString selectedHouseName = 'Add House'.obs;
  final RxString selectedRoomId = ''.obs;
  final RxString selectedRoomName = 'Add Room'.obs;

  RxList<Map<String, dynamic>> rooms = <Map<String, dynamic>>[].obs;

  Future<File> convertIconToFile(String assetPath) async {
    ByteData byteData = await rootBundle.load(assetPath);
    Uint8List uint8List = byteData.buffer.asUint8List();

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = "${tempDir.path}/icon.png";

    File file = File(tempPath);
    await file.writeAsBytes(uint8List);

    return file;
  }

  void addRoom(String roomName, String iconName) async {
    if (rooms.isEmpty) {
      File iconFile = await convertIconToFile(iconName);
      rooms.add({'name': roomName, 'icon': iconFile.path});
    }
  }

  var isLoading = false.obs;

  void setLoading(bool value) {
    isLoading.value = value;
  }

  var isRoomLoading = false.obs;

  void setRoomLoading(bool value) {
    isRoomLoading.value = value;
  }

  ///==================================✅✅Status Observables for different API calls✅✅=======================
  final rxRequestStatus = Status.loading.obs;
  final rxHouseRoomStatus = Status.loading.obs;
  final rxMyHouseStatus = Status.loading.obs;
  final rxSingleRoomStatus = Status.loading.obs;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;
  void setHouseRoomStatus(Status value) => rxHouseRoomStatus.value = value;
  void setMyHouseStatus(Status value) => rxMyHouseStatus.value = value;
  void setSingleRoomStatus(Status value) => rxSingleRoomStatus.value = value;

  ///==================================✅✅get House Room✅✅=======================
  Rx<HouseRoomData> houseRoomData = HouseRoomData().obs;

  getHouseRoom({required String houseId}) async {
    setHouseRoomStatus(Status.loading);
    setRxRequestStatus(Status.loading);
    refresh();
    try {
      final response =
      await apiClient.get(url: ApiUrl.getMyRoom(houseId), showResult: true);

      if (response.statusCode == 200) {
        houseRoomData.value = HouseRoomData.fromJson(response.body["data"]);

        // ✅ SORT ROOMS ALPHABETICALLY
        if (houseRoomData.value.rooms != null) {
          houseRoomData.value.rooms!.sort((a, b) {
            String nameA = (a.name ?? '').toLowerCase();
            String nameB = (b.name ?? '').toLowerCase();
            return nameA.compareTo(nameB);
          });
        }

        print('House Room API==================${response.statusCode}');
        print(
            'rooms Length==================${houseRoomData.value.rooms?.length}');
        setHouseRoomStatus(Status.completed);
        setRxRequestStatus(Status.completed);
        refresh();
      } else {
        setHouseRoomStatus(Status.error);
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } on SocketException {
      print('Socket Exception in getHouseRoom');
      setHouseRoomStatus(Status.internetError);
      setRxRequestStatus(Status.internetError);
    } catch (e) {
      print('Error in getHouseRoom: $e');
      setHouseRoomStatus(Status.error);
      setRxRequestStatus(Status.error);
    }
  }

  ///==================================✅✅MY house Data✅✅=======================
  Rx<myHouse.MyHouseData> myHouseData = myHouse.MyHouseData().obs;
  Rxn<myHouse.House> selectedHouse = Rxn<myHouse.House>();

  myAllHouse() async {
    setMyHouseStatus(Status.loading);
    setRxRequestStatus(Status.loading);
    refresh();

    try {
      final response = await apiClient.get(
        url: ApiUrl.myAllHouse,
        showResult: true,
      );

      if (response.statusCode == 200) {
        myHouseData.value =
            myHouse.MyHouseData.fromJson(response.body["data"]);

        myHouseData.refresh();

        setMyHouseStatus(Status.completed);
        setRxRequestStatus(Status.completed);


        // myHouseData.value = myHouse.MyHouseData.fromJson(response.body["data"]);
        //
        // setMyHouseStatus(Status.completed);
        // setRxRequestStatus(Status.completed);
        // refresh();
      } else {
        setMyHouseStatus(Status.error);
        setRxRequestStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } on SocketException {
      setMyHouseStatus(Status.internetError);
      setRxRequestStatus(Status.internetError);
    } catch (e) {
      setMyHouseStatus(Status.error);
      setRxRequestStatus(Status.error);
    }
  }

  // Initialize home data - fetch houses and auto-select/restore
  Future<void> _initializeHomeData() async {
    try {
      print('🔵 Starting _initializeHomeData');

      // First, fetch all houses
      await myAllHouse();
      print('🔵 Houses fetched: ${myHouseData.value.houses?.length}');

      // After houses are loaded, select house (either saved or first one)
      await _selectOrRestoreHouse();

      print('🔵 House selected: ${selectedHouseName.value}');
    } catch (e) {
      print('❌ Error in _initializeHomeData: $e');
    }
  }

  // Select or restore house based on SharedPreferences
  Future<void> _selectOrRestoreHouse() async {
    try {
      if (myHouseData.value.houses == null ||
          myHouseData.value.houses!.isEmpty) {
        print('⚠️ No houses available');
        return;
      }

      // Try to get saved house ID
      String? savedHouseId = await SharePrefsHelper.getSelectedHouseId();
      print('📱 Saved house ID: $savedHouseId');

      myHouse.House? savedHouse;

      if (savedHouseId != null && savedHouseId.isNotEmpty) {
        // Try to find the saved house in the current list
        try {
          savedHouse = myHouseData.value.houses?.firstWhere(
                (house) => house.id == savedHouseId,
          );
        } catch (e) {
          print('⚠️ Saved house not found in list, will select first house');
          savedHouse = null;
        }
      }

      if (savedHouse != null) {
        print('✅ Restoring saved house: ${savedHouse.name}');
        await _selectHouseAndLoadRooms(savedHouse);
      } else {
        print('⚠️ Selecting first house as default');
        await _selectHouseAndLoadRooms(myHouseData.value.houses![0]);
      }
    } catch (e) {
      print('❌ Error in _selectOrRestoreHouse: $e');
    }
  }

  // Select a house and load its rooms
  Future<void> _selectHouseAndLoadRooms(myHouse.House house) async {
    try {
      print('🏠 Selecting house: ${house.name} (${house.id})');

      // Update observables
      selectedHouse.value = house;
      selectedHouseId.value = house.id ?? '';
      selectedHouseName.value = house.name ?? 'Add House';

      // Save to SharedPreferences
      await SharePrefsHelper.saveSelectedHouse(
        house.id ?? '',
        house.name ?? '',
      );

      // Reset room selection
      selectedRoomId.value = '';
      selectedRoomName.value = 'Add Room';
      await SharePrefsHelper.saveSelectedRoom('', '');

      print('💾 House saved to SharedPreferences');

      // Fetch rooms for this house
      if ((house.id ?? '').isNotEmpty) {
        print('🔄 Fetching rooms for house: ${house.id}');
        await getHouseRoom(houseId: house.id ?? '');
      }

      refresh();
    } catch (e) {
      print('❌ Error in _selectHouseAndLoadRooms: $e');
    }
  }

  // When user manually selects a house from dropdown
  Future<void> selectHouseFromUI(myHouse.House house) async {
    try {
      print('👤 User selected house: ${house.name}');

      // Update observables
      selectedHouse.value = house;
      selectedHouseId.value = house.id ?? '';
      selectedHouseName.value = house.name ?? 'Add House';

      // Save to SharedPreferences
      await SharePrefsHelper.saveSelectedHouse(
        house.id ?? '',
        house.name ?? '',
      );

      // Reset room selection
      selectedRoomId.value = '';
      selectedRoomName.value = 'Add Room';
      await SharePrefsHelper.saveSelectedRoom('', '');

      // Collapse dropdown
      isExpanded.value = false;

      // Fetch rooms for selected house
      if ((house.id ?? '').isNotEmpty) {
        await getHouseRoom(houseId: house.id ?? '');
      }

      refresh();
    } catch (e) {
      print('❌ Error selecting house: $e');
    }
  }

  // When user manually selects a room
  Future<void> selectRoomFromUI(dynamic room) async {
    try {
      String roomId = room.id ?? '';
      String roomName = room.name ?? 'Add Room';

      print('🚪 User selected room: $roomName');

      // Update observables
      selectedRoomId.value = roomId;
      selectedRoomName.value = roomName;

      // Save to SharedPreferences
      await SharePrefsHelper.saveSelectedRoom(roomId, roomName);

      // Fetch tasks for this room
      if (roomId.isNotEmpty) {
        await getSingleRoomTask(roomId: roomId);
      }

      refresh();
    } catch (e) {
      print('❌ Error selecting room: $e');
    }
  }

  ///==================================✅✅SingleRoom Data✅✅=======================
  RxList<SingleRoomModel> singleRoomModels = <SingleRoomModel>[].obs;

  // getSingleRoomTask({required String roomId}) async {
  //   setSingleRoomStatus(Status.loading);
  //   refresh();
  //
  //   try {
  //     final response = await apiClient.get(
  //       url: ApiUrl.roomTaskSingle(roomId),
  //       showResult: true,
  //     );
  //
  //     if (response.statusCode == 200) {
  //       try {
  //         final data = response.body;
  //
  //         final tasks = data['data']?['result'];
  //         if (tasks != null && tasks is List && tasks.isNotEmpty) {
  //           singleRoomModels.value = tasks
  //               .map<SingleRoomModel>((task) => SingleRoomModel.fromJson(task))
  //               .toList();
  //           setSingleRoomStatus(Status.completed);
  //         } else {
  //           singleRoomModels.clear();
  //           setSingleRoomStatus(Status.completed);
  //         }
  //         refresh();
  //       } catch (parseError) {
  //         print('JSON Parse Error in getSingleRoomTask: $parseError');
  //         print('Response data: ${response.body}');
  //         setSingleRoomStatus(Status.error);
  //         singleRoomModels.clear();
  //       }
  //     } else {
  //       setSingleRoomStatus(Status.error);
  //       ApiChecker.checkApi(response);
  //     }
  //   } on SocketException {
  //     print('Socket Exception in getSingleRoomTask');
  //     setSingleRoomStatus(Status.internetError);
  //   } catch (e) {
  //     print('Error in getSingleRoomTask: $e');
  //     setSingleRoomStatus(Status.error);
  //   }
  // }


  getSingleRoomTask({required String roomId}) async {
    setSingleRoomStatus(Status.loading);
    refresh();

    try {
      final response = await apiClient.get(
        url: ApiUrl.roomTaskSingle(roomId),
        showResult: true,
      );

      if (response.statusCode == 200) {
        try {
          final data = response.body;

          final tasks = data['data']?['result'];
          if (tasks != null && tasks is List && tasks.isNotEmpty) {
            singleRoomModels.assignAll(
              tasks.map<SingleRoomModel>((task) => SingleRoomModel.fromJson(task)).toList(),
            );
          } else {
            singleRoomModels.clear();
          }
          setSingleRoomStatus(Status.completed);
          singleRoomModels.refresh();
          refresh();
        } catch (parseError) {
          print('JSON Parse Error in getSingleRoomTask: $parseError');
          print('Response data: ${response.body}');
          setSingleRoomStatus(Status.error);
          singleRoomModels.clear();
        }
      } else {
        setSingleRoomStatus(Status.error);
        ApiChecker.checkApi(response);
      }
    } on SocketException {
      print('Socket Exception in getSingleRoomTask');
      setSingleRoomStatus(Status.internetError);
    } catch (e) {
      print('Error in getSingleRoomTask: $e');
      setSingleRoomStatus(Status.error);
    }
  }


  ///==================================✅✅Remove task✅✅=======================
  RxBool isRemoveTask = false.obs;

  // removeTask({required String taskId, required String roomId}) async {
  //   isRemoveTask.value = true;
  //   var body = {"taskId": taskId};
  //
  //   try {
  //     var response = await apiClient.delete(body: body, url: ApiUrl.taskDelete);
  //     if (response.statusCode == 200) {
  //       getSingleRoomTask(roomId: roomId);
  //       toastMessage(message: response.body["message"]);
  //     } else if (response.statusCode == 400) {
  //       toastMessage(message: response.body["message"]);
  //     } else {
  //       ApiChecker.checkApi(response);
  //     }
  //   } catch (e) {
  //     print('Error in removeTask: $e');
  //     toastMessage(message: "Failed to remove task");
  //   } finally {
  //     isRemoveTask.value = false;
  //     isRemoveTask.refresh();
  //   }
  // }



  removeTask({required String taskId, required String roomId}) async {
    isRemoveTask.value = true;
    var body = {"taskId": taskId};

    try {
      var response = await apiClient.delete(body: body, url: ApiUrl.taskDelete);
      if (response.statusCode == 200) {
        toastMessage(message: response.body["message"]);

        // ✅ আগে list থেকে সরিয়ে দিন (instant UI update)
        singleRoomModels.removeWhere((task) => task.id == taskId);
        singleRoomModels.refresh();

        // ✅ তারপর server থেকে fresh data আনুন
        await getSingleRoomTask(roomId: roomId);

      } else if (response.statusCode == 400) {
        toastMessage(message: response.body["message"]);
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print('Error in removeTask: $e');
      toastMessage(message: "Failed to remove task");
    } finally {
      isRemoveTask.value = false;
      isRemoveTask.refresh();
    }
  }


  @override
  void onInit() {
    super.onInit();
    print('🚀 HomeController onInit called');
    _initializeHomeData();
  }
}