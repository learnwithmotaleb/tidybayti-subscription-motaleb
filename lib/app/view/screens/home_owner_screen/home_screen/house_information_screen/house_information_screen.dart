import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/home_controller/house_add.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/ToastMsg/toast_message.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tidybayte/app/controller/owner_controller/home_controller/home_controller.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/components/custom_text_field/custom_text_field.dart';

class HouseInformationScreen extends StatelessWidget {
  HouseInformationScreen({super.key});

  final HomeController homeController = Get.find<HomeController>();
  final String houseType = Get.arguments ?? "Unknown";
  @override
  Widget build(BuildContext context) {
    print(houseType);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: const HouseInformationBody(),
        floatingActionButton: Obx(() {
          /// ✅ Fix: Wrap `isLoading` check inside `Obx`
          if (homeController.isLoading.value) {
            return const CustomLoader(); // Show loader when loading
          }

          return CustomButton(
            width: MediaQuery.of(context).size.width / 1.1,
            onTap: () async {
              /// ✅ Ensure a room is added before saving
              if (homeController.rooms.isEmpty) {
                toastMessage(message: AppStrings.pleaseAddARoomBeforeSaving.tr);
                return;
              }

              /// ✅ Get the first room
              var room = homeController.rooms[0];

              File roomImageFile = await HouseAdd.getFileFromAsset(
                  homeController.selectedIconPath);

              /// ✅ Send data to API
              homeController.setLoading(true); // Start loading
              await HouseAdd.houseRoomAdd(
                context: context,
                houseName: homeController.houseNameController.text,
                roomName: room['name'],
                roomImage: roomImageFile, // ✅ Send File
              );
              homeController.setLoading(false); // Stop loading
            },
            fillColor: Colors.white,
            title: AppStrings.save.tr,
          );
        }),
      ),
    );
  }
}

class HouseInformationBody extends StatefulWidget {
  const HouseInformationBody({super.key});

  @override
  _HouseInformationBodyState createState() => _HouseInformationBodyState();
}

class _HouseInformationBodyState extends State<HouseInformationBody> {
  final HomeController homeController = Get.find<HomeController>();

  /// ✅ Show Dialog to Add Room
  void showDialoge(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: AlertDialog(
            title: Text(AppStrings.addRoom.tr),
            content: StatefulBuilder(
              builder: (context, setStateDialog) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// ✅ Room Name Input
                    CustomTextField(
                      textEditingController: homeController.roomNameController,
                      hintText: AppStrings.roomName.tr,
                      fillColor: AppColors.blue100,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    /// ✅ Select Icon
                    GestureDetector(
                      onTap: () {
                        showIconSelection(context, (icon) {
                          setStateDialog(() {
                            homeController.selectedIconPath = icon;
                          });
                        });
                      },
                      child: Container(
                        padding:  ResponsiveHelper.all(10),
                        color: AppColors.blue100,
                        child: Row(
                          children: [
                            CustomImage(
                                imageSrc: homeController.selectedIconPath,
                                sizeHeight: ResponsiveHelper.iconSize(40)),
                             SizedBox(width: ResponsiveHelper.spacing(10)),
                            const Text('Select Icon',
                                style: TextStyle(color: AppColors.dark500)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(25)),

                    /// ✅ Save Button (Only One Room Allowed)
                    GestureDetector(
                      onTap: () {
                        if (homeController.roomNameController.text.isNotEmpty) {
                          if (homeController.rooms.isEmpty) {
                            homeController.addRoom(
                                homeController.roomNameController.text,
                                homeController.selectedIconPath);
                            Get.back();
                          }
                        }
                      },
                      child: Container(
                        padding:  ResponsiveHelper.all(10),
                        color: AppColors.blue300,
                        child: CustomText(
                          text: AppStrings.save.tr,
                          fontSize: ResponsiveHelper.fontSize(18),
                          fontWeight: FontWeight.w400,
                          color: AppColors.dark500,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// ✅ Select Icon Dialog
  void showIconSelection(
      BuildContext context, Function(String) onIconSelected) {
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
                  crossAxisCount: 3, // 3 items per row
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
                        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: ResponsiveHelper.all(12),
                      child: Center(
                        child: CustomImage(
                          imageColor: AppColors.black,
                          imageSrc: image,
                          sizeHeight: ResponsiveHelper.iconSize(40),
                        ),
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

  @override
  void initState() {
    super.initState();

    String houseType = Get.arguments ?? "";
    homeController.houseNameController.text = houseType;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xCCF5F5F5),
            Color(0xFFB5D8EE),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            CustomMenuAppbar(
              title: AppStrings.houseInformation.tr,
              onBack: () {
                Get.back();
              },
            ),
            Padding(
              padding:  ResponsiveHelper.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ✅ House Name Input
                  CustomTextField(
                    hintText: AppStrings.houseName,
                    textEditingController: homeController.houseNameController,
                  ),
                  SizedBox(height:ResponsiveHelper.spacing(30)),

                  /// ✅ Add Room Button (Disappears after adding a room)
                  Obx(() {
                    return homeController.rooms.isEmpty
                        ? GestureDetector(
                            onTap: () {
                              showDialoge(context);
                            },
                            child: Row(
                              children: [
                                const CustomImage(imageSrc: AppIcons.addRoom),
                                CustomText(
                                  left: ResponsiveHelper.width(10),
                                  text: AppStrings.addRoom.tr,
                                  fontWeight: FontWeight.w400,
                                  fontSize: ResponsiveHelper.fontSize(20),
                                  color: AppColors.dark500,
                                ),
                              ],
                            ),
                          )
                        : Container(); // Hide button after adding a room
                  }),
                  SizedBox(height: 10.h),

                  /// ✅ Display Room (Only One Room Allowed)
                  Obx(() => homeController.rooms.isEmpty
                      ? const Center(
                          child: Text("No room added",
                              style: TextStyle(color: Colors.grey)))
                      : Column(
                          children: [
                            Row(
                              children: [
                                // CustomImage(
                                //     imageSrc: homeController.rooms[0]['icon'],
                                //   imageType: ImageType.png,),

                                CustomText(
                                  left: ResponsiveHelper.width(10),
                                  text:
                                      "Room Name: ${homeController.rooms[0]['name']}",
                                  fontSize: ResponsiveHelper.fontSize(18),
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.dark500,
                                ),
                              ],
                            ),
                          ],
                        )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
