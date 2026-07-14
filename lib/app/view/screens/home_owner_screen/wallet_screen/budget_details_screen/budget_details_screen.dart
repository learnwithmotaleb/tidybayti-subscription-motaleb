import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/wallet_controller/wallet_controller.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/GenerelError/general_error.dart';
import 'package:tidybayte/app/global/helper/global_alart/global_alart.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/global/helper/time_converter/time_converter.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/components/no_internet_screen/no_internet_screen.dart';

class BudgetDetailsScreen extends StatefulWidget {
  const BudgetDetailsScreen({super.key});

  @override
  State<BudgetDetailsScreen> createState() => _BudgetDetailsScreenState();
}

class _BudgetDetailsScreenState extends State<BudgetDetailsScreen> {
  final id = Get.arguments[0];
  final categoryName = Get.arguments[1];

  final WalletController controller = Get.find<WalletController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getSingleBudget(budgetId: id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    DateTime parseCustomDate(String dateStr) {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
      }
      return DateTime.now();
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xCCE8F3FA), Color(0xFFB5D8EE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Obx(() {
              switch (controller.rxRequestStatus.value) {
                case Status.loading:
                  return const Center(child: CustomLoader());

                case Status.internetError:
                  return NoInternetScreen(
                    onTap: () => controller.getSingleBudget(budgetId: id),
                  );

                case Status.error:
                  return GeneralErrorScreen(
                    onTap: () => controller.getSingleBudget(budgetId: id),
                  );

                case Status.completed:
                  final budget = controller.budgetDetailsData.value;
                  final amount = budget.amount?.toDouble() ?? 0.0;
                  final currentExpense =
                      budget.currentExpense?.toDouble() ?? 0.0;
                  final progress =
                  amount > 0 ? (amount - currentExpense) / amount : 0.0;
                  final expenses = budget.expenses ?? [];

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.padding(15),
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: ResponsiveHelper.maxContentWidth,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// ✅ Appbar
                            CustomMenuAppbar(
                              isRemove: true,
                              onRemove: () {
                                GlobalAlert.showDeleteDialog(context, () {
                                  controller.removeBudget(budgetId: id);
                                }, AppStrings.removeBudget.tr);
                              },
                              title: categoryName,
                              onBack: () {
                                Get.back();
                              },
                              isEdit: true,
                              onTap: () {
                                GlobalAlert.showEditBudgetDialog(
                                  context,
                                  controller,
                                  id,
                                  budget.category ?? "",
                                  budget.amount.toString(),
                                );
                              },
                            ),
                            SizedBox(height: ResponsiveHelper.spacing(20)),

                            /// ✅ Budget Details Card
                            Container(
                              padding: EdgeInsets.all(
                                ResponsiveHelper.padding(15),
                              ),
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CustomText(
                                        text: AppStrings.budgetDetails.tr,
                                        fontWeight: FontWeight.w600,
                                        fontSize: ResponsiveHelper.fontSize(24),
                                        color: AppColors.blue800,
                                      ),
                                      const Spacer(),
                                      CustomText(
                                        text: amount.toStringAsFixed(2),
                                        fontWeight: FontWeight.w600,
                                        fontSize: ResponsiveHelper.fontSize(24),
                                        color: AppColors.green,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: ResponsiveHelper.spacing(8)),

                                  /// ✅ Budget Date
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        color: Colors.grey,
                                        size: ResponsiveHelper.iconSize(22),
                                      ),
                                      SizedBox(
                                          width: ResponsiveHelper.spacing(5)),
                                      CustomText(
                                        text: budget.budgetDateTime != null
                                            ? DateConverter.estimatedDate(
                                            budget.budgetDateTime!.toLocal())
                                            : "N/A",
                                        fontWeight: FontWeight.w400,
                                        fontSize: ResponsiveHelper.fontSize(14),
                                        color: AppColors.dark300,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: ResponsiveHelper.spacing(12)),

                                  /// ✅ Budget Progress
                                  LinearProgressIndicator(
                                    value: progress.clamp(0.0, 1.0),
                                    backgroundColor: AppColors.blue100,
                                    color: AppColors.red,
                                    minHeight: ResponsiveHelper.height(8),
                                  ),
                                  SizedBox(
                                      height: ResponsiveHelper.spacing(12)),

                                  /// ✅ Cost & Remaining
                                  Row(
                                    children: [
                                      CustomText(
                                        text:
                                        "${AppStrings.cost.tr}: ${currentExpense.toStringAsFixed(2)}",
                                        fontWeight: FontWeight.w400,
                                        fontSize: ResponsiveHelper.fontSize(14),
                                        color: AppColors.red,
                                      ),
                                      const Spacer(),
                                      CustomText(
                                        text:
                                        "${AppStrings.left.tr}: ${(amount - currentExpense).toStringAsFixed(2)}",
                                        fontWeight: FontWeight.w400,
                                        fontSize: ResponsiveHelper.fontSize(14),
                                        color: AppColors.green,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: ResponsiveHelper.spacing(16)),

                            /// ✅ Expense Overview Title
                            CustomText(
                              text: AppStrings.expenseOverview.tr,
                              fontWeight: FontWeight.w500,
                              fontSize: ResponsiveHelper.fontSize(20),
                              color: AppColors.blue900,
                            ),

                            /// ✅ Expense List
                            expenses.isEmpty
                                ? Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: ResponsiveHelper.spacing(50),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.money_off,
                                      size: ResponsiveHelper.iconSize(80),
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                        height:
                                        ResponsiveHelper.spacing(10)),
                                    CustomText(
                                      text:
                                      AppStrings.noExpenseFound.tr,
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                      ResponsiveHelper.fontSize(18),
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            )
                                : ListView.builder(
                              shrinkWrap: true,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              itemCount: expenses.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: ResponsiveHelper.spacing(5),
                                  ),
                                  color: Colors.white,
                                  padding: EdgeInsets.only(
                                    top: ResponsiveHelper.spacing(10),
                                    left: ResponsiveHelper.padding(10),
                                    right: ResponsiveHelper.padding(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.house,
                                            color: Colors.grey,
                                            size: ResponsiveHelper
                                                .iconSize(22),
                                          ),
                                          SizedBox(
                                              width: ResponsiveHelper
                                                  .spacing(10)),
                                          CustomText(
                                            text:
                                            budget.category ?? "",
                                            color: AppColors.dark300,
                                            fontSize: ResponsiveHelper
                                                .fontSize(16),
                                          ),
                                          const Spacer(),
                                          CustomText(
                                            text: expenses[index]
                                                .amount
                                                ?.toStringAsFixed(
                                                2) ??
                                                '0',
                                            color: AppColors.dark300,
                                            fontSize: ResponsiveHelper
                                                .fontSize(16),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_month,
                                            color: Colors.grey,
                                            size: ResponsiveHelper
                                                .iconSize(22),
                                          ),
                                          SizedBox(
                                              width: ResponsiveHelper
                                                  .spacing(8)),
                                          // CustomText(
                                          //   text: expenses[index]
                                          //       .expenseDateStr !=
                                          //       null
                                          //       ? DateConverter
                                          //       .estimatedDate(
                                          //       parseCustomDate(
                                          //           expenses[index]
                                          //               .expenseDateStr!))
                                          //       : "N/A",
                                          //   fontSize: ResponsiveHelper
                                          //       .fontSize(14),
                                          // ),

                                          CustomText(
                                            text: expenses[index].createdAt != null
                                                ? DateConverter.estimatedDate(expenses[index].createdAt!)
                                                : "N/A",
                                            fontSize: ResponsiveHelper.fontSize(14),
                                          ),

                                          const Spacer(),
                                          IconButton(
                                            onPressed: () {
                                              GlobalAlert
                                                  .showDeleteDialog(
                                                  context, () {
                                                controller.removeExpense(
                                                    expenseId:
                                                    expenses[index]
                                                        .id ??
                                                        "",
                                                    budgetId: id);
                                              },
                                                  AppStrings
                                                      .removeExpense
                                                      .tr);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.grey,
                                              size: ResponsiveHelper
                                                  .iconSize(22),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                            SizedBox(height: ResponsiveHelper.spacing(20)),
                          ],
                        ),
                      ),
                    ),
                  );
              }
            }),
          ),
        ),

        /// ✅ Add Expense Bottom Button
        // bottomSheet: Container(
        //   color: const Color(0xffB5D8EE),
        //   child: Padding(
        //     padding: EdgeInsets.symmetric(
        //       horizontal: ResponsiveHelper.padding(20),
        //       vertical: ResponsiveHelper.spacing(20),
        //     ),
        //     child: Center(
        //       child: ConstrainedBox(
        //         constraints: BoxConstraints(
        //           maxWidth: ResponsiveHelper.maxContentWidth,
        //         ),
        //         child: CustomButton(
        //           onTap: () => Get.toNamed(
        //             AppRoutes.addExpenseScreen,
        //             arguments: [id, categoryName],
        //           ),
        //           fillColor: Colors.white,
        //           title: AppStrings.addExpanse.tr,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),


// bottomSheet: এর জায়গায় bottomNavigationBar: লিখুন
        bottomNavigationBar: Container(
          color: const Color(0xffB5D8EE),
          height: ResponsiveHelper.height(90), // fixed height দিন
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.padding(20),
              vertical: ResponsiveHelper.spacing(20),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveHelper.maxContentWidth,
                ),
                child: CustomButton(
                  onTap: () => Get.toNamed(
                    AppRoutes.addExpenseScreen,
                    arguments: [id, categoryName],
                  ),
                  fillColor: Colors.white,
                  title: AppStrings.addExpanse.tr,
                ),
              ),
            ),
          ),
        ),















      ),
    );
  }
}