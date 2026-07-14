import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/wallet_controller/wallet_controller.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_text_field/custom_text_field.dart';


class AddExpenseScreen extends StatelessWidget {
  AddExpenseScreen({super.key});

  final WalletController controller = Get.find<WalletController>();

  final budgetId = Get.arguments[0];
  final categoryName = Get.arguments[1];

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
                    ///=============================== Add Expense Appbar ========================
                    CustomMenuAppbar(
                      isEdit: false,
                      title: AppStrings.addExpanse.tr,
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
                              ///========================= Category Name (Read Only) =============
                              CustomTextField(
                                readOnly: true,
                                textEditingController:
                                TextEditingController(text: categoryName),
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(16)),

                              ///============================ Select Date ========================
                              CustomTextField(
                                textEditingController:
                                controller.expenseDateController,
                                readOnly: true,
                                hintText: AppStrings.selectDate.tr,
                                fillColor: Colors.white,
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  size: ResponsiveHelper.iconSize(24),
                                ),
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
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
                                    controller.expenseDateController.text =
                                        formattedDate;
                                  }
                                },
                              ),
                              SizedBox(height: ResponsiveHelper.spacing(16)),

                              ///============================ Enter Amount =======================
                              CustomTextField(
                                hintText: AppStrings.enterAmount.tr,
                                textEditingController:
                                controller.expenseAmountController,
                              ),
                              SizedBox(
                                height: ResponsiveHelper.height(300),
                              ),

                              ///========================= Save Button ===========================
                              controller.isExpenseLoading.value
                                  ? const CustomLoader()
                                  : CustomButton(
                                onTap: () {
                                  controller.expenseAdd(
                                      budgetId: budgetId);
                                },
                                title: AppStrings.save.tr,
                                fillColor: AppColors.blue50,
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