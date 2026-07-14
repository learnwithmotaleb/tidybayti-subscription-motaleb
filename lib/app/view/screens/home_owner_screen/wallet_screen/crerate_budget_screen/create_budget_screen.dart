import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/wallet_controller/wallet_controller.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_netwrok_image/custom_network_image.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/components/custom_text_field/custom_text_field.dart';

class CreateBudgetScreen extends StatelessWidget {
  CreateBudgetScreen({super.key});

  final WalletController controller = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

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
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveHelper.spacing(20),
            ),
            child: SingleChildScrollView(
              child: Obx(() {
                return Column(
                  children: [
                    ///=============================== Budget Appbar ========================
                    CustomMenuAppbar(
                      title: AppStrings.budget.tr,
                      onBack: () {
                        Get.back();
                      },
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(20)),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.padding(20),
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: ResponsiveHelper.maxContentWidth,
                          ),
                          child: Column(
                            children: [
                              ///=================== Form Section ===================
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: ResponsiveHelper.spacing(16)),

                                  ///======== Select Category with custom other ========
                                  Obx(() => Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      /// ================= MAIN FIELD =================
                                      CustomTextField(
                                        fillColor: Colors.white,
                                        textEditingController:
                                        controller
                                            .categoryNameController,
                                        hintText:
                                        AppStrings.selectCategory.tr,
                                        readOnly: true,
                                        suffixIcon: Icon(
                                          controller.isSelected.value
                                              ? Icons.keyboard_arrow_up
                                              : Icons
                                              .keyboard_arrow_down_rounded,
                                          size: ResponsiveHelper.iconSize(
                                              28),
                                          color: AppColors.blue900,
                                        ),
                                        onTap: () {
                                          controller.isSelected.toggle();
                                          controller.isCustomCategory
                                              .value = false;
                                        },
                                      ),

                                      SizedBox(
                                          height:
                                          ResponsiveHelper.spacing(10)),

                                      /// ================= DROPDOWN =================
                                      if (controller.isSelected.value)
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(
                                              ResponsiveHelper
                                                  .borderRadius(8),
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 6,
                                              )
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              /// NORMAL CATEGORY LIST
                                              ...List.generate(
                                                controller
                                                    .budgetCategoryList
                                                    .length,
                                                    (index) => GestureDetector(
                                                  onTap: () {
                                                    controller
                                                        .categoryNameController
                                                        .text =
                                                        controller
                                                            .budgetCategoryList[
                                                        index]
                                                            .name ??
                                                            "";
                                                    controller
                                                        .imageController
                                                        .text =
                                                        controller
                                                            .budgetCategoryList[
                                                        index]
                                                            .image ??
                                                            "";
                                                    controller.isSelected
                                                        .value = false;
                                                    controller
                                                        .isCustomCategory
                                                        .value =
                                                    false;
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                      horizontal:
                                                      ResponsiveHelper
                                                          .padding(12),
                                                      vertical:
                                                      ResponsiveHelper
                                                          .spacing(10),
                                                    ),
                                                    decoration:
                                                    const BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color:
                                                            Colors.grey,
                                                            width: 0.3),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        CustomNetworkImage(
                                                          imageUrl: controller
                                                              .budgetCategoryList[
                                                          index]
                                                              .image ??
                                                              "",
                                                          height: ResponsiveHelper
                                                              .iconSize(22),
                                                          width: ResponsiveHelper
                                                              .iconSize(22),
                                                        ),
                                                        CustomText(
                                                          left: ResponsiveHelper
                                                              .spacing(12),
                                                          text: controller
                                                              .budgetCategoryList[
                                                          index]
                                                              .name ??
                                                              "",
                                                          fontSize:
                                                          ResponsiveHelper
                                                              .fontSize(
                                                              15),
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
                                                          color: AppColors
                                                              .dark500,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              /// ================= OTHER OPTION =================
                                              GestureDetector(
                                                onTap: () {
                                                  controller
                                                      .categoryNameController
                                                      .text =
                                                  "Other";
                                                  controller
                                                      .imageController
                                                      .text =
                                                      controller
                                                          .defaultOtherImage;
                                                  controller.isSelected
                                                      .value = false;
                                                  controller
                                                      .isCustomCategory
                                                      .value = true;
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  padding:
                                                  EdgeInsets.symmetric(
                                                    horizontal:
                                                    ResponsiveHelper
                                                        .padding(12),
                                                    vertical:
                                                    ResponsiveHelper
                                                        .spacing(12),
                                                  ),
                                                  child: Text(
                                                    "➕ Other (Write your own)",
                                                    style: TextStyle(
                                                      fontSize:
                                                      ResponsiveHelper
                                                          .fontSize(15),
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      /// ================= CUSTOM INPUT =================
                                      Obx(() => controller
                                          .isCustomCategory.value
                                          ? Padding(
                                        padding: EdgeInsets.only(
                                          top: ResponsiveHelper
                                              .spacing(10),
                                        ),
                                        child: CustomTextField(
                                          textEditingController:
                                          controller
                                              .customCategoryController,
                                          hintText:
                                          "Enter custom category",
                                          fillColor: Colors.white,
                                        ),
                                      )
                                          : const SizedBox()),
                                    ],
                                  )),

                                  SizedBox(height: ResponsiveHelper.spacing(12)),

                                  ///=================== Select Date ===================
                                  CustomTextField(
                                    textEditingController:
                                    controller.dateController,
                                    readOnly: true,
                                    hintText: AppStrings.selectDate.tr,
                                    fillColor: Colors.white,
                                    suffixIcon: Icon(
                                      Icons.calendar_month,
                                      size: ResponsiveHelper.iconSize(22),
                                    ),
                                    onTap: () async {
                                      DateTime? pickedDate =
                                      await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );

                                      if (pickedDate != null) {
                                        String formattedDate =
                                            "${pickedDate.month.toString().padLeft(2, '0')}/"
                                            "${pickedDate.day.toString().padLeft(2, '0')}/"
                                            "${pickedDate.year}";
                                        controller.dateController.text =
                                            formattedDate;
                                      }
                                    },
                                  ),

                                  SizedBox(height: ResponsiveHelper.spacing(12)),

                                  ///=================== Amount Field ===================
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: CustomTextField(
                                          textEditingController:
                                          controller.amountController,
                                          keyboardType: TextInputType.number,
                                          hintText:
                                          AppStrings.enterAmount.tr,
                                          fieldBorderRadius:
                                          ResponsiveHelper.borderRadius(8),
                                          fillColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                      height: ResponsiveHelper.height(250)),

                                  ///=================== Create Button ===================
                                  controller.isCreateLoading.value
                                      ? const CustomLoader()
                                      : CustomButton(
                                    onTap: () {
                                      if (controller
                                          .validateBudgetForm()) {
                                        controller.budgetCreate();
                                      }
                                    },
                                    title:
                                    AppStrings.createBudgets.tr,
                                    fillColor: AppColors.blue50,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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