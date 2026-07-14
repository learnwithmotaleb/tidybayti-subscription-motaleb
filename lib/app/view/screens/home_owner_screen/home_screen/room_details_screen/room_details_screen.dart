import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tidybayte/app/controller/owner_controller/home_controller/home_controller.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/GenerelError/general_error.dart';
import 'package:tidybayte/app/global/helper/global_alart/global_alart.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_room_card/custom_room_card.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/components/custom_text_field/custom_text_field.dart';
import 'package:tidybayte/app/view/components/no_internet_screen/no_internet_screen.dart';
import 'package:tidybayte/app/view/screens/home_owner_screen/schedule_screen/task_schedule/create_task/controller/create_task_controller.dart';
import '../../../../../data/service/api_url.dart';
import '../../../../components/custom_button/custom_button.dart';
import '../../../../components/custom_image/custom_image.dart';
import '../../../../components/custom_netwrok_image/custom_network_image.dart';
import 'room_controller.dart';

class RoomDetailsScreen extends StatefulWidget {
  const RoomDetailsScreen({super.key});

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  final HomeController homeController = Get.find<HomeController>();
  final RoomController roomController = Get.put(RoomController());
  final String roomId = Get.arguments[0];
  final String roomName = Get.arguments[1];
  final String roomImage = Get.arguments[2];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.getSingleRoomTask(roomId: roomId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xCCE8F3FA),
                Color(0xFFB5D8EE),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                ///=============================== roomName Title ========================
                CustomMenuAppbar(
                  isEdit: true,
                  title: roomName,
                  onBack: () {
                    Get.back();
                  },
                  isRemove: true,
                  removeColor: AppColors.blue900,
                  onRemove: () {
                    showDeleteRoomDialog(context, roomId);
                  },
                  onTap: () {
                    showEditRoomDialog(context, roomId, roomName, roomImage);
                  },
                ),

                ///=============================== Menu Items ========================
                Expanded(
                  child: Obx(() {
                    switch (homeController.rxSingleRoomStatus.value) {
                      case Status.loading:
                        return const CustomLoader();
                      case Status.internetError:
                        return NoInternetScreen(
                          onTap: () {
                            homeController.getSingleRoomTask(roomId: roomId);
                          },
                        );
                      case Status.error:
                        return GeneralErrorScreen(
                          onTap: () {
                            homeController.getSingleRoomTask(roomId: roomId);
                          },
                        );
                      case Status.completed:
                        final taskList = homeController.singleRoomModels;

                        if (taskList.isEmpty) {
                          return RefreshIndicator(
                            onRefresh: () async {
                              await homeController.getSingleRoomTask(
                                  roomId: roomId);
                            },
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(height: Get.height * 0.4),
                                Center(
                                  child: CustomText(
                                    text: AppStrings.noTasks.tr,
                                    fontSize: ResponsiveHelper.fontSize(18),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () async {
                            await homeController.getSingleRoomTask(
                                roomId: roomId);
                          },
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: ResponsiveHelper.all(16),
                            itemCount: taskList.length,
                            itemBuilder: (context, index) {
                              final task = taskList[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: ResponsiveHelper.height(12)),
                                child: CustomRoomCard(
                                  taskName: task.taskName ??
                                      AppStrings.noTaskName.tr,
                                  assignedTo:
                                  task.assignedTo?.firstName != null
                                      ? "${task.assignedTo?.firstName} ${task.assignedTo?.lastName ?? ''}"
                                      : " ",
                                  time:
                                  "${task.startTimeStr?.toString().split('.').first ?? ""} - ${task.endTimeStr?.toString().split('.').first ?? ""}",
                                  onInfoPressed: () {
                                    GlobalAlert.singleTaskDialog(
                                      context,
                                      task.taskName ?? AppStrings.noTask.tr,
                                      "${task.assignedTo?.firstName ?? ''} ${task.assignedTo?.lastName ?? ''}",
                                      task.recurrenceStr ??
                                          AppStrings.oneTime.tr,
                                      task.startDateStr ?? "",
                                      task.startTimeStr ?? "",
                                      task.endDateStr ?? "",
                                      task.endTimeStr ?? "",
                                    );
                                  },
                                  onDeletePressed: () {
                                    GlobalAlert.showDeleteDialog(context, () {
                                      homeController.removeTask(
                                        taskId: task.id ?? "",
                                        roomId: roomId,
                                      );
                                    }, AppStrings.removeTask.tr);
                                  },
                                ),
                              );
                            },
                          ),
                        );
                    }
                  }),
                ),
                // CustomButton(
                //   height: ResponsiveHelper.height(64),
                //   width: ResponsiveHelper.height(335),
                //   onTap: () {
                //     final createTaskController =
                //     Get.find<CreateTaskController>();
                //     createTaskController.refreshRoomDetails = true;
                //     createTaskController.roomIdForRefresh = roomId;
                //
                //     Get.toNamed(
                //       AppRoutes.createTask,
                //       arguments: {
                //         'roomId': roomId,
                //         'roomName': roomName,
                //       },
                //     );
                //   },
                //   fillColor: Colors.white,
                //   title: AppStrings.assignTask.tr,
                // ),


                CustomButton(
                  height: ResponsiveHelper.height(64),
                  width: ResponsiveHelper.height(335),
                  onTap: () {
                    final createTaskController = Get.find<CreateTaskController>();
                    createTaskController.refreshRoomDetails = true;
                    createTaskController.roomIdForRefresh = roomId;

                    Get.toNamed(
                      AppRoutes.createTask,
                      arguments: {
                        'roomId': roomId,
                        'roomName': roomName,
                      },
                    )?.then((_) {
                      // CreateTask screen থেকে ফিরলে refresh
                      homeController.getSingleRoomTask(roomId: roomId);
                    });
                  },
                  fillColor: Colors.white,
                  title: AppStrings.assignTask.tr,
                ),

                SizedBox(height: ResponsiveHelper.height(16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///=============================== Delete Room Dialog ========================
Future<void> showDeleteRoomDialog(
    BuildContext context,
    String roomId,
    ) {
  final RoomController roomController = Get.find<RoomController>();
  return showDialog(
      context: context,
      builder: (context) {
        return Directionality(
            textDirection: TextDirection.ltr,
            child: AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(ResponsiveHelper.borderRadius(5))),
                ),
                title: CustomText(
                  text: AppStrings.deleteRoom.tr,
                  color: AppColors.dark500,
                  fontSize: ResponsiveHelper.fontSize(20),
                  fontWeight: FontWeight.w400,
                ),
                content: CustomText(
                  text: AppStrings.deleteRoomMessage.tr,
                  color: AppColors.dark500,
                  maxLines: 3,
                  fontSize: ResponsiveHelper.fontSize(18),
                  fontWeight: FontWeight.w400,
                ),
                actions: [
                  Obx(() {
                    return GestureDetector(
                      onTap: roomController.isDeletingRoom.value
                          ? null
                          : () async {
                        try {
                          await roomController.deleteSingleRoom(
                              roomId: roomId);
                          Get.back();
                        } catch (e) {
                          Get.snackbar(AppStrings.error.tr,
                              AppStrings.somethingWentWrong.tr);
                          print("Error: $e");
                        }
                      },
                      child: Container(
                        padding: ResponsiveHelper.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(4)),
                        ),
                        child: Center(
                          child: CustomText(
                            text: AppStrings.deleteRoom.tr,
                            fontSize: ResponsiveHelper.fontSize(18),
                            fontWeight: FontWeight.w400,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    );
                  }),
                ]));
      });
}

///=============================== Edit Room Dialog ========================
Future<void> showEditRoomDialog(
    BuildContext context,
    String roomId,
    String currentRoomName,
    String currentRoomImage,
    ) {
  final TextEditingController roomNameController =
  TextEditingController(text: currentRoomName);
  final RoomController roomController = Get.find<RoomController>();
  String selectedIconPath = currentRoomImage;
  bool isIconChanged = false;

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(ResponsiveHelper.borderRadius(5))),
              ),
              title: CustomText(
                text: AppStrings.editRoom.tr,
                color: AppColors.dark500,
                fontSize: ResponsiveHelper.fontSize(20),
                fontWeight: FontWeight.w400,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: ResponsiveHelper.height(20)),

                    CustomTextField(
                      fillColor: AppColors.blue100,
                      hintText: AppStrings.roomName.tr,
                      textEditingController: roomNameController,
                    ),
                    SizedBox(height: ResponsiveHelper.height(10)),

                    GestureDetector(
                      onTap: () {
                        showIconSelection(context, (String iconPath) {
                          setState(() {
                            selectedIconPath = iconPath;
                            isIconChanged = (iconPath != currentRoomImage);
                          });
                        });
                      },
                      child: Container(
                        padding: ResponsiveHelper.symmetric(
                            horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.blue100,
                          borderRadius: BorderRadius.circular(
                              ResponsiveHelper.borderRadius(8)),
                        ),
                        child: Row(
                          children: [
                            buildAdaptiveImage(selectedIconPath,
                                size: ResponsiveHelper.iconSize(40)),
                            SizedBox(width: ResponsiveHelper.width(12)),
                            Expanded(
                              child: Text(
                                AppStrings.changeIcon.tr,
                                style: TextStyle(
                                    color: AppColors.dark500,
                                    fontSize: ResponsiveHelper.fontSize(16)),
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down_outlined,
                                color: AppColors.dark500),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.height(40)),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              padding: ResponsiveHelper.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.light300,
                                borderRadius: BorderRadius.circular(
                                    ResponsiveHelper.borderRadius(4)),
                              ),
                              child: Center(
                                child: CustomText(
                                  text: AppStrings.cancel.tr,
                                  fontSize: ResponsiveHelper.fontSize(18),
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.dark500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.width(16)),
                        Expanded(
                          child: Obx(() {
                            return GestureDetector(
                              onTap: roomController.isUpdatingRoom.value
                                  ? null
                                  : () async {
                                if (roomNameController.text
                                    .trim()
                                    .isEmpty) {
                                  Get.snackbar(AppStrings.error.tr,
                                      AppStrings.pleaseEnterRoomName.tr);
                                  return;
                                }

                                try {
                                  File iconFile;

                                  if (isIconChanged) {
                                    iconFile =
                                    await _convertAssetToFile(
                                        selectedIconPath);

                                    if (!iconFile.existsSync()) {
                                      Get.snackbar(AppStrings.error.tr,
                                          'Invalid image file');
                                      return;
                                    }
                                  } else {
                                    iconFile = File(currentRoomImage);
                                  }

                                  await roomController.editSingleRoom(
                                    roomId: roomId,
                                    name:
                                    roomNameController.text.trim(),
                                    roomImage: iconFile,
                                  );
                                } catch (e) {
                                  Get.snackbar(AppStrings.error.tr,
                                      AppStrings.somethingWentWrong.tr);
                                  print("Error: $e");
                                }
                              },
                              child: Container(
                                padding: ResponsiveHelper.all(12),
                                decoration: BoxDecoration(
                                  color: roomController.isUpdatingRoom.value
                                      ? AppColors.blue300.withOpacity(0.6)
                                      : AppColors.blue300,
                                  borderRadius: BorderRadius.circular(
                                      ResponsiveHelper.borderRadius(4)),
                                ),
                                child: Center(
                                  child: roomController.isUpdatingRoom.value
                                      ? SizedBox(
                                    width: ResponsiveHelper.iconSize(20),
                                    height:
                                    ResponsiveHelper.iconSize(20),
                                    child:
                                    const CircularProgressIndicator(
                                      color: AppColors.dark500,
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : CustomText(
                                    text: AppStrings.update.tr,
                                    fontSize:
                                    ResponsiveHelper.fontSize(18),
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.dark500,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

/// ✅ Select Icon Dialog
void showIconSelection(BuildContext context, Function(String) onIconSelected) {
  final HomeController homeController = Get.find<HomeController>();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: AlertDialog(
          backgroundColor: Colors.white,
          title: Text(AppStrings.selectIcon.tr),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.maxFinite,
            child: GridView.builder(
              itemCount: homeController.images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final image = homeController.images[index];
                return GestureDetector(
                  onTap: () {
                    onIconSelected(image);
                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(
                          ResponsiveHelper.borderRadius(12)),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: ResponsiveHelper.all(12),
                    child: Center(
                      child: CustomImage(
                          imageColor: AppColors.black,
                          imageSrc: image,
                          sizeHeight: ResponsiveHelper.iconSize(40)),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

// Convert Asset to File
Future<File> _convertAssetToFile(String assetPath) async {
  try {
    final byteData =
    await DefaultAssetBundle.of(Get.context!).load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final fileName = assetPath.split('/').last;
    final file = File('${tempDir.path}/$fileName');

    if (await file.exists()) {
      await file.delete();
    }

    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  } catch (e) {
    print("Error converting asset to file: $e");
    throw Exception("Failed to convert asset to file");
  }
}

bool _isNetworkUrl(String path) {
  return path.startsWith('uploads');
}

Widget buildAdaptiveImage(String path, {double size = 40}) {
  if (_isNetworkUrl(path)) {
    return CustomNetworkImage(
        imageUrl: "${ApiUrl.networkUrl}$path", height: size.h, width: size.w);
  } else {
    return CustomImage(imageSrc: path, sizeHeight: size.w);
  }
}