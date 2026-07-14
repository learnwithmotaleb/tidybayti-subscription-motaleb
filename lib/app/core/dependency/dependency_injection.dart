import 'package:get/get.dart';
import 'package:tidybayte/app/controller/employee_controller/employee_grocery_controller.dart';
import 'package:tidybayte/app/controller/employee_controller/employee_home_controller.dart';
import 'package:tidybayte/app/controller/language_controller/langauge_controller.dart';
import 'package:tidybayte/app/controller/notification_controller/notification_controller.dart';
import 'package:tidybayte/app/controller/owner_controller/add_employee_controller/add_employee_controller.dart';
import 'package:tidybayte/app/controller/owner_controller/download_controller/download_controller.dart';
import 'package:tidybayte/app/controller/owner_controller/grocery_controller/grocery_controller.dart';
import 'package:tidybayte/app/controller/owner_controller/home_controller/home_controller.dart';
import 'package:tidybayte/app/controller/owner_controller/info_controller/info_controller.dart';
import 'package:tidybayte/app/controller/owner_controller/profile_controller/profile_controller.dart';
import 'package:tidybayte/app/controller/owner_controller/recipe_controller/recipe_controller.dart';
import 'package:tidybayte/app/controller/owner_controller/setting_controller/setting_controller.dart';
import 'package:tidybayte/app/controller/owner_controller/task_controller/task_controller.dart';
import 'package:tidybayte/app/controller/owner_controller/wallet_controller/wallet_controller.dart';
import 'package:tidybayte/app/controller/owner_controller/work_schedule_controller/work_schedule_controller.dart';
import 'package:tidybayte/app/data/subscription/subscription_controller.dart';
import 'package:tidybayte/app/global/controller/auth_controller.dart';

import '../../controller/owner_controller/select_room_controller/select_room_controller.dart';
import '../../view/screens/home_owner_screen/home_screen/room_details_screen/room_controller.dart';
import '../../view/screens/home_owner_screen/schedule_screen/task_schedule/create_task/controller/create_task_controller.dart';
import '../../view/screens/home_owner_screen/schedule_screen/task_schedule/create_task/controller/task_preset_controller.dart';
import '../../view/screens/home_owner_screen/schedule_screen/task_schedule/grocery_task/grocery_task_controller.dart';
import '../../view/screens/home_owner_screen/schedule_screen/task_schedule/grocery_task/select_grocery_dialog/grocery_item_list_controller.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    ///==========================Owner section==================
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => SettingController(), fenix: true);
    Get.lazyPut(() => RecipeController(), fenix: true);
    Get.lazyPut(() => WalletController(), fenix: true);
    Get.lazyPut(() => NotificationController(), fenix: true);
    Get.lazyPut(() => AddEmployeeController(), fenix: true);
    Get.lazyPut(() => TaskController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => InfoController(), fenix: true);
    Get.lazyPut(() => WorkScheduleController(), fenix: true);
    //Get.lazyPut(() => GroceryController(), fenix: true);
    Get.lazyPut(() => EmployeeGroceryController(), fenix: true);
    Get.lazyPut(() => DownloadController(), fenix: true);
    Get.lazyPut(() => GroceryTaskController(), fenix: true);
    Get.lazyPut(() => RoomController(), fenix: true);
    Get.lazyPut(() => GroceryItemListController(), fenix: true);
    Get.lazyPut(() => SubscriptionController(), fenix: true);

    Get.put<GroceryController>(
      GroceryController(),
      permanent: true,
    );
    Get.put<AddEmployeeController>(AddEmployeeController());

    ///==========================Employee Section==================
    Get.lazyPut(() => EmployeeHomeController(), fenix: true);
    Get.lazyPut(() => LanguageController(), fenix: true);
    Get.lazyPut(() => CreateTaskController(), fenix: true);
    Get.lazyPut(() => SelectRoomController(), fenix: true);
    Get.lazyPut(() => TaskPresetController(), fenix: true);
  }
}
