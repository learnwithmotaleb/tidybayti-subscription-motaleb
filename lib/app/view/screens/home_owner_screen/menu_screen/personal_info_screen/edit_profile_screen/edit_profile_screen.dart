import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/profile_controller/profile_controller.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_images/app_images.dart';

import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';

import 'package:tidybayte/app/view/components/custom_text_field/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void initState() {
    final args = Get.arguments ?? {};
    profileController.firstNameController.text = args["firstName"] ?? '';
    profileController.lastNameController.text = args["lastName"] ?? '';
    profileController.phoneNumberController.text = args["phoneNumber"] ?? '';
    profileController.image.value = args["profileImage"] ?? '';
    print("Received Image: =============${args["profileImage"]}");

    super.initState();
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
                Color(0xCCE8F3FA), // First color (with opacity)
                Color(0xFFB5D8EE),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Obx(() {
                return Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///=============================== editProfile ========================
                    CustomMenuAppbar(
                      title: AppStrings.editProfile.tr,
                      onBack: () {
                        Get.back();
                      },
                    ),

                    Padding(
                      padding: ResponsiveHelper.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              profileController.selectImage();
                            },
                            child: Obx(() {
                              String imagePath = profileController.image.value;

                              if (imagePath.isNotEmpty) {
                                if (imagePath.startsWith('/data') ||
                                    imagePath.startsWith('/storage')) {
                                  // This is a locally selected image
                                  return ClipOval(
                                    child: Image.file(
                                      File(imagePath),
                                      height:  ResponsiveHelper.iconSize(128),
                                      width:  ResponsiveHelper.iconSize(128),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                } else {
                                  // If the image is from the server, append base URL
                                  String fullImageUrl =
                                      imagePath.startsWith('http')
                                          ? imagePath
                                          : "${ApiUrl.baseUrl}/$imagePath";

                                  return ClipOval(
                                    child: Image.network(
                                      fullImageUrl,
                                      height:  ResponsiveHelper.iconSize(128),
                                      width:  ResponsiveHelper.iconSize(128),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return  Icon(Icons.error,
                                            size:  ResponsiveHelper.iconSize(128),
                                        );
                                      },
                                    ),
                                  );
                                }
                              } else {
                                return  Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    ClipOval(
                                      child: CustomImage(
                                        imageSrc: AppImages.avatar,
                                        imageType: ImageType.png,
                                        sizeHeight:  ResponsiveHelper.iconSize(100),
                                      ),
                                    ),
                                    Positioned(
                                      right:  ResponsiveHelper.spacing(5),
                                      bottom: ResponsiveHelper.spacing(5),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.camera_alt,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }),
                          ),

                          SizedBox(
                            height:ResponsiveHelper.spacing(20),
                          ),

                          ///============================FirstName================
                          CustomTextField(
                            hintText: AppStrings.firstName.tr,
                            textEditingController:
                                profileController.firstNameController,
                          ),
                          SizedBox(
                            height:ResponsiveHelper.spacing(10),
                          ),

                          ///============================LastName================
                          CustomTextField(
                            hintText: AppStrings.lastName.tr,
                            textEditingController:
                                profileController.lastNameController,
                          ),
                          SizedBox(
                            height: ResponsiveHelper.spacing(10),
                          ),

                          ///==========================Contact Number============
                          CustomTextField(
                            hintText: AppStrings.contactNo.tr,
                            textEditingController:
                                profileController.phoneNumberController,
                          ),

                          SizedBox(
                            height: ResponsiveHelper.spacing(200),
                          ),

                          ///============================Button Here=================

                          profileController.updateProfileLoading.value
                              ? const CustomLoader()
                              : CustomButton(
                                  onTap: () {
                                    profileController.updateProfile();
                                  },
                                  fillColor: AppColors.employeeCardColor,
                                  title: AppStrings.saveAndChange.tr,
                                ),
                          SizedBox(
                            height: ResponsiveHelper.spacing(40),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
