import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tidybayte/app/controller/owner_controller/recipe_controller/recipeApi.dart';
import 'package:tidybayte/app/controller/owner_controller/recipe_controller/recipe_controller.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/ToastMsg/toast_message.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/utils/app_images/app_images.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/components/custom_text_field/custom_text_field.dart';
import '../../../../components/recipe_button/recipe_button.dart';

class AddRecipeScreen extends StatelessWidget {
  const AddRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {


    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                AppImages.recipeBacground,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// Menu Title
                      CustomMenuAppbar(
                        title: AppStrings.addRecipe.tr,
                        onBack: () {
                          Get.back();
                        },
                      ),
                      SizedBox(height: ResponsiveHelper.spacing(200)), // ✅

                      RecipeButton(
                        text: AppStrings.newBlackRecipe.tr,
                        onPressed: () {
                          Get.toNamed(AppRoutes.addNewRecipe, arguments: {
                            "IsEdit": "false",
                          });
                        },
                      ),
                      RecipeButton(
                        text: AppStrings.importFromWebsite.tr,
                        onPressed: () {
                          importDialog(context);
                        },
                      ),
                      RecipeButton(
                        text: AppStrings.uploadFile.tr,
                        onPressed: () {
                          uploadFileDialog(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================= Import from Website Dialog =============================
void importDialog(BuildContext context) {
  final RecipeController recipeController = Get.find<RecipeController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController urlController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(ResponsiveHelper.borderRadius(5.0)), // ✅
            ),
          ),
          title: Row(
            children: [
              CustomText(
                text: AppStrings.importFromWebsite,
                color: AppColors.dark400,
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveHelper.fontSize(20), // ✅
                right: ResponsiveHelper.spacing(10),     // ✅
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Get.back(),
                child: const CustomImage(imageSrc: AppIcons.x),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  fillColor: AppColors.blue300,
                  hintText: AppStrings.recipeName,
                  textEditingController: nameController,
                ),
                SizedBox(height: ResponsiveHelper.spacing(15)), // ✅
                Obx(() => CustomTextField(
                  onTap: () => recipeController.pickImage(),
                  readOnly: true,
                  fillColor: AppColors.blue300,
                  hintText: recipeController.profileImage.value == null
                      ? AppStrings.addPhoto
                      : 'Image Selected',
                  prefixIcon: recipeController.profileImage.value != null
                      ? Padding(
                    padding: ResponsiveHelper.all(8.0), // ✅
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(8.0), // ✅
                      ),
                      child: Image.file(
                        recipeController.profileImage.value!,
                        width: ResponsiveHelper.width(40),   // ✅
                        height: ResponsiveHelper.height(40), // ✅
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                      : null,
                  suffixIcon: const Icon(Icons.photo_camera_back),
                )),
                SizedBox(height: ResponsiveHelper.spacing(15)), // ✅
                CustomTextField(
                  fillColor: AppColors.blue300,
                  hintText: AppStrings.urlHere,
                  textEditingController: urlController,
                ),
                SizedBox(height: ResponsiveHelper.spacing(25)), // ✅
                Obx(() => recipeController.isLoading.value
                    ? const CustomLoader()
                    : CustomButton(
                  onTap: () async {
                    if (nameController.text.isEmpty) {
                      toastMessage(message: "Please enter recipe name");
                      return;
                    }
                    if (urlController.text.isEmpty) {
                      toastMessage(message: "Please enter URL");
                      return;
                    }
                    if (recipeController.profileImage.value == null) {
                      toastMessage(message: "Please select an image");
                      return;
                    }
                    await RecipeApi.addUrlRecipe(
                      context: context,
                      recipeName: nameController.text,
                      recipeImage: recipeController.profileImage.value!,
                      fileType: "url",
                      fileUrl: urlController.text,
                    );
                    Get.back();
                  },
                  fillColor: AppColors.blue300,
                  title: AppStrings.save,
                )),
              ],
            ),
          ),
        ),
      );
    },
  );
}

// ============================= Upload File Dialog =============================
void uploadFileDialog(BuildContext context) {
  final RecipeController recipeController = Get.find<RecipeController>();
  final TextEditingController nameController = TextEditingController();
  final RxString selectedFileName = ''.obs;
  File? selectedPdfFile;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(ResponsiveHelper.borderRadius(5.0)), // ✅
            ),
          ),
          title: Row(
            children: [
              SizedBox(width: ResponsiveHelper.width(35)), // ✅
              CustomText(
                text: AppStrings.uploadFile,
                color: AppColors.dark400,
                fontWeight: FontWeight.w500,
                fontSize: ResponsiveHelper.fontSize(20), // ✅
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Get.back(),
                child: const CustomImage(imageSrc: AppIcons.x),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  fillColor: AppColors.blue300,
                  hintText: AppStrings.recipeName.tr,
                  textEditingController: nameController,
                ),
                SizedBox(height: ResponsiveHelper.spacing(15)), // ✅
                Obx(() => CustomTextField(
                  onTap: () => recipeController.pickImage(),
                  readOnly: true,
                  fillColor: AppColors.blue300,
                  hintText: recipeController.profileImage.value == null
                      ? AppStrings.addPhoto.tr
                      : 'Image Selected',
                  prefixIcon: recipeController.profileImage.value != null
                      ? Padding(
                    padding: ResponsiveHelper.all(8.0), // ✅
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.borderRadius(8.0), // ✅
                      ),
                      child: Image.file(
                        recipeController.profileImage.value!,
                        width: ResponsiveHelper.width(40),   // ✅
                        height: ResponsiveHelper.height(40), // ✅
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                      : null,
                  suffixIcon: const Icon(Icons.photo_camera_back),
                )),
                SizedBox(height: ResponsiveHelper.spacing(15)), // ✅
                Obx(() => CustomTextField(
                  onTap: () async {
                    FilePickerResult? result =
                    await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );
                    if (result != null) {
                      selectedPdfFile =
                          File(result.files.single.path!);
                      selectedFileName.value = result.files.single.name;
                    }
                  },
                  readOnly: true,
                  fillColor: AppColors.blue300,
                  hintText: selectedFileName.value.isEmpty
                      ? AppStrings.uploadFilePdf.tr
                      : selectedFileName.value,
                  suffixIcon: const Icon(Icons.picture_as_pdf),
                )),
                SizedBox(height: ResponsiveHelper.spacing(25)), // ✅
                Obx(() => recipeController.isLoading.value
                    ? const CustomLoader()
                    : CustomButton(
                  onTap: () async {
                    if (nameController.text.isEmpty) {
                      toastMessage(message: "Please enter recipe name");
                      return;
                    }
                    if (selectedPdfFile == null) {
                      toastMessage(message: "Please select a PDF file");
                      return;
                    }
                    if (recipeController.profileImage.value == null) {
                      toastMessage(message: "Please select an image");
                      return;
                    }
                    final directory =
                    await getApplicationDocumentsDirectory();
                    final fileName =
                        '${DateTime.now().millisecondsSinceEpoch}.pdf';
                    final savedPath = '${directory.path}/$fileName';
                    await selectedPdfFile!.copy(savedPath);
                    await RecipeApi.addPdfRecipe(
                      context: context,
                      recipeName: nameController.text,
                      recipeImage: recipeController.profileImage.value!,
                      fileType: "pdf",
                      localFilePath: savedPath,
                    );
                    Get.back();
                  },
                  fillColor: AppColors.blue300,
                  title: AppStrings.save,
                )),
              ],
            ),
          ),
        ),
      );
    },
  );
}