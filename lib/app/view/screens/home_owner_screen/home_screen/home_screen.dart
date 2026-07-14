import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/add_employee_controller/add_employee_controller.dart';
import 'package:tidybayte/app/controller/owner_controller/home_controller/home_controller.dart';
import 'package:tidybayte/app/controller/owner_controller/home_controller/house_add.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/components/custom_text_field/custom_text_field.dart';
import 'package:tidybayte/app/view/components/nav_bar/nav_bar.dart';
import '../../../../data/service/api_url.dart';
import '../../../components/custom_netwrok_image/custom_network_image.dart';
import 'home_screen_inner_widgets/employee_show.dart';
import 'home_screen_inner_widgets/seel_all.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HouseTypeScreenState();
}

class _HouseTypeScreenState extends State<HomeScreen> {
  final AddEmployeeController employeeController =
  Get.find<AddEmployeeController>();

  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      employeeController.getEmployee();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        bottomNavigationBar: const NavBar(currentIndex: 0),
        backgroundColor: AppColors.freeServiceColor,
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.light50,
                    Color(0xFFB5D8EE),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Column(
              children: [
                /// ✅ Fixed House Selection Section
                Obx(
                      () => Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBg,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                            ResponsiveHelper.borderRadius(25)),
                        bottomRight: Radius.circular(
                            ResponsiveHelper.borderRadius(25)),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                          spreadRadius: 2,
                        ),
                      ],
                    ),

                        padding: EdgeInsets.only(
                          left: ResponsiveHelper.padding(20),
                          right: ResponsiveHelper.padding(20),
                          top: ResponsiveHelper.padding(60),
                          bottom: ResponsiveHelper.padding(30),

                        ),




                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ///add house bottom sheet
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: AppStrings.chooseYourHouse,
                                  fontWeight: FontWeight.w500,
                                  fontSize: ResponsiveHelper.fontSize(20),
                                  color: AppColors.black,
                                ),



                                GestureDetector(
                                onTap: (){
                                  _showHousesBottomSheet(context);
                                },
                                  child: Row(
                                    children: [
                                      CustomText(
                                        text: homeController.selectedHouseName.value,
                                        fontWeight: FontWeight.w500,
                                        fontSize: ResponsiveHelper.fontSize(20),
                                        color: AppColors.black,
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: AppColors.black,
                                        size: ResponsiveHelper.iconSize(24),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),


                            GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                    AppRoutes.employeeNotificationScreen);
                              },
                              child: Icon(
                                Icons.notifications,
                                color: AppColors.black,
                                size: ResponsiveHelper.iconSize(28),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                /// ✅ Scrollable Section
                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async {
                      await employeeController.getEmployee();
                      await homeController.myAllHouse();

                      if (homeController.selectedHouseId.value.isNotEmpty) {
                        await homeController.getHouseRoom(
                          houseId: homeController.selectedHouseId.value,
                        );
                      }
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: ResponsiveHelper.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /// ✅ All Room Section
                          SizedBox(
                            height: ResponsiveHelper.height(320),
                            child: Obx(() {
                              switch (homeController.rxRequestStatus.value) {
                                case Status.loading:
                                  return const CustomLoader();

                                case Status.internetError:
                                case Status.error:
                                  return GestureDetector(
                                    onTap: () {
                                      homeController.getHouseRoom(
                                        houseId: homeController
                                            .selectedHouseId.value,
                                      );
                                    },
                                    child: CustomText(
                                      textAlign: TextAlign.center,
                                      top: ResponsiveHelper.height(25),
                                      fontWeight: FontWeight.w500,
                                      fontSize: ResponsiveHelper.fontSize(16),
                                      text: AppStrings.noInternet.tr,
                                      color: Colors.black,
                                    ),
                                  );

                                case Status.completed:
                                  final List<dynamic> rooms =
                                      homeController.houseRoomData.value.rooms ??
                                          [];

                                  return GridView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing:
                                      ResponsiveHelper.spacing(12),
                                      mainAxisSpacing:
                                      ResponsiveHelper.spacing(10),
                                      mainAxisExtent:
                                      ResponsiveHelper.width(110),
                                    ),
                                    itemCount: rooms.length + 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      const int rows = 3;
                                      final int totalItems = rooms.length + 1;
                                      final int columns =
                                      (totalItems / rows).ceil();

                                      final int column = index ~/ rows;
                                      final int row = index % rows;
                                      final int mappedIndex =
                                          row * columns + column;

                                      if (mappedIndex >= totalItems) {
                                        return const SizedBox();
                                      }

                                      // ➕ ADD ROOM CARD
                                      if (mappedIndex == 0) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (homeController
                                                .selectedHouseId.value
                                                .isEmpty) {
                                              Get.snackbar(
                                                AppStrings.noHouseSelected.tr,
                                                AppStrings.pleaseSelectAHouse
                                                    .tr,
                                                snackPosition:
                                                SnackPosition.BOTTOM,
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                              );
                                              return;
                                            }
                                            showDialoge(context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                              AppColors.employeeCardColor,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  ResponsiveHelper
                                                      .borderRadius(10)),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0x14000000),
                                                  blurRadius: 3,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                const CustomImage(
                                                  imageSrc: AppIcons.add,
                                                  imageType: ImageType.svg,
                                                ),
                                                SizedBox(
                                                    height: ResponsiveHelper
                                                        .spacing(6)),
                                                CustomText(
                                                  text:
                                                  AppStrings.addRoom.tr,
                                                  color: AppColors.dark400,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize:
                                                  ResponsiveHelper.fontSize(
                                                      14),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }

                                      // 🏠 ROOM CARD
                                      final data = rooms[mappedIndex - 1];
                                      return GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                            AppRoutes.roomDetailsScreen,
                                            arguments: [
                                              data.id ?? "",
                                              data.name ?? "",
                                              data.roomImage ?? "",
                                            ],
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              ResponsiveHelper.padding(6)),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(
                                                ResponsiveHelper
                                                    .borderRadius(8)),
                                            color: Colors.white,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color(0x14000000),
                                                blurRadius: 2,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              CustomNetworkImage(
                                                imageUrl:
                                                "${ApiUrl.networkUrl}${data.roomImage ?? ""}",
                                                height:
                                                ResponsiveHelper.iconSize(
                                                    40),
                                                width:
                                                ResponsiveHelper.iconSize(
                                                    40),
                                              ),
                                              SizedBox(
                                                  height: ResponsiveHelper
                                                      .spacing(6)),
                                              Text(
                                                data.name ?? "",
                                                style: TextStyle(
                                                  fontSize:
                                                  ResponsiveHelper.fontSize(
                                                      14),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.center,
                                                overflow:
                                                TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                              }
                            }),
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(20)),

                          /// ✅ See All Section
                          const SeeAll(),
                          SizedBox(height: ResponsiveHelper.spacing(30)),

                          /// ✅ Employee Section
                          EmployeeShow(employeeController: employeeController),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Draggable Bottom Sheet for House Selection
  void _showHousesBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft:
                  Radius.circular(ResponsiveHelper.borderRadius(20)),
                  topRight:
                  Radius.circular(ResponsiveHelper.borderRadius(20)),
                ),
              ),
              child: Column(
                children: [
                  /// ✅ Drag Handle
                  Padding(
                    padding: ResponsiveHelper.symmetric(vertical: 12),
                    child: Container(
                      height: ResponsiveHelper.height(4),
                      width: ResponsiveHelper.width(40),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(2)),
                      ),
                    ),
                  ),

                  /// ✅ Title
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.padding(20)),
                    child: CustomText(
                      text: AppStrings.selectHouse.tr,
                      fontSize: ResponsiveHelper.fontSize(20),
                      fontWeight: FontWeight.w500,
                      color: AppColors.dark400,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(16)),

                  /// ✅ Scrollable House List
                  Expanded(
                    child: Obx(
            () =>
   ListView(
                          controller: scrollController,
                          padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveHelper.padding(20)),
                          children: [
                            /// ✅ Add House Option
                            GestureDetector(
                              onTap: () {
                                Get.back();
                                Future.delayed(
                                    const Duration(milliseconds: 300), () {
                                  Get.toNamed(AppRoutes.houseTypeScreen);
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    bottom: ResponsiveHelper.spacing(12)),
                                padding: EdgeInsets.symmetric(
                                  vertical: ResponsiveHelper.padding(16),
                                  horizontal: ResponsiveHelper.padding(16),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(
                                      ResponsiveHelper.borderRadius(12)),
                                  border: Border.all(
                                      color: Colors.blue.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color:AppColors.black,
                                      size: ResponsiveHelper.iconSize(24),
                                    ),
                                    SizedBox(
                                        width: ResponsiveHelper.spacing(12)),
                                    CustomText(
                                      text: AppStrings.addHouse.tr,
                                      fontSize: ResponsiveHelper.fontSize(16),
                                      fontWeight: FontWeight.w500,
                                      color:AppColors.black
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: ResponsiveHelper.spacing(8)),

                            /// ✅ House List
                            if (homeController.myHouseData.value.houses != null &&
                                homeController
                                    .myHouseData.value.houses!.isNotEmpty) ...[
                              ...homeController.myHouseData.value.houses!.map(
                                    (house) {
                                  return GestureDetector(
                                    onTap: () {
                                      homeController.selectHouseFromUI(house);
                                      Get.back();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          bottom: ResponsiveHelper.spacing(10)),
                                      padding: EdgeInsets.symmetric(
                                        vertical: ResponsiveHelper.padding(14),
                                        horizontal: ResponsiveHelper.padding(16),
                                      ),
                                      decoration: BoxDecoration(
                                        color: homeController
                                            .selectedHouseId.value ==
                                            house.id
                                            ?  Colors.blue.shade50
                                            : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(
                                            ResponsiveHelper.borderRadius(10)),
                                        border: Border.all(
                                          color: homeController
                                              .selectedHouseId.value ==
                                              house.id
                                              ? AppColors.black
                                              : Colors.grey.shade300,
                                          width: homeController
                                              .selectedHouseId.value ==
                                              house.id
                                              ? ResponsiveHelper.borderWidth(1)
                                              : ResponsiveHelper.borderWidth(1),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomText(
                                            text: house.name ?? "No Name",
                                            fontSize:
                                            ResponsiveHelper.fontSize(16),
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.dark400,
                                          ),
                                          if (homeController
                                              .selectedHouseId.value ==
                                              house.id)
                                            Icon(
                                              Icons.check_circle,
                                              color: AppColors.black,
                                              size: ResponsiveHelper.iconSize(24),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            ] else
                              Center(
                                child: CustomText(
                                  text: AppStrings.noHouses.tr,
                                  fontSize: ResponsiveHelper.fontSize(16),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        )

                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// ✅ Show Dialog to Add Room
  void showDialoge(BuildContext context) {
    String selectedIconPath = AppIcons.livingRoom;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              AppStrings.addRoom.tr,
              style: TextStyle(fontSize: ResponsiveHelper.fontSize(18)),
            ),
            content: StatefulBuilder(
              builder: (context, setStateDialog) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// ✅ Room Name Input
                    CustomTextField(
                      textEditingController:
                      homeController.roomNameController,
                      hintText: AppStrings.roomName.tr,
                      fillColor: AppColors.blue100,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(10)),

                    /// ✅ Select Icon
                    GestureDetector(
                      onTap: () {
                        showIconSelection(context, (iconPath) {
                          setStateDialog(() {
                            selectedIconPath = iconPath;
                          });
                        });
                      },
                      child: Container(
                        padding:
                        EdgeInsets.all(ResponsiveHelper.padding(10)),
                        color: AppColors.blue100,
                        child: Row(
                          children: [
                            CustomImage(
                              imageSrc: selectedIconPath,
                              sizeHeight: ResponsiveHelper.iconSize(40),
                            ),
                            SizedBox(width: ResponsiveHelper.spacing(10)),
                            Text(
                              AppStrings.selectIcon.tr,
                              style: TextStyle(
                                color: AppColors.dark500,
                                fontSize: ResponsiveHelper.fontSize(14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(25)),

                    /// ✅ Save Button
                    GestureDetector(
                      onTap: () async {
                        if (homeController
                            .roomNameController.text.isNotEmpty) {
                          if (homeController.rooms.isEmpty) {
                            File roomImageFile =
                            await HouseAdd.getFileFromAsset(
                                selectedIconPath);
                            HouseAdd.roomAdd(
                              context: context,
                              houseId: homeController.selectedHouseId
                                  .toString(),
                              roomName:
                              homeController.roomNameController.text,
                              roomImage: roomImageFile,
                            );
                            Get.back();
                          }
                        }
                      },
                      child: Container(
                        padding:
                        EdgeInsets.all(ResponsiveHelper.padding(10)),
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
            title: Text(
              AppStrings.selectIcon.tr,
              style: TextStyle(fontSize: ResponsiveHelper.fontSize(18)),
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.maxFinite,
              child: GridView.builder(
                itemCount: homeController.images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: ResponsiveHelper.spacing(12),
                  mainAxisSpacing: ResponsiveHelper.spacing(12),
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
                        border:
                        Border.all(color: Colors.grey.shade300),
                      ),
                      padding:
                      EdgeInsets.all(ResponsiveHelper.padding(12)),
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
}