import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/wallet_controller/wallet_controller.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/GenerelError/general_error.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/budget_card/butget_card.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/no_internet_screen/no_internet_screen.dart';

class WalletBudgetScreen extends StatelessWidget {
  WalletBudgetScreen({super.key});

  final WalletController controller = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.padding(20),
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          await controller.getBudget();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.maxContentWidth,
              ),
              child: Column(
                children: [
                  SizedBox(height: ResponsiveHelper.spacing(20)),

                  ///============= Budget Show List =============
                  Obx(() {
                    switch (controller.rxRequestStatus.value) {
                      case Status.loading:
                        return const Center(child: CustomLoader());

                      case Status.internetError:
                        return NoInternetScreen(onTap: () {
                          controller.getBudget();
                        });

                      case Status.error:
                        return GeneralErrorScreen(
                          onTap: () {
                            controller.getBudget();
                          },
                        );

                      case Status.completed:
                        final budgetList =
                            controller.budgetData.value.result ?? [];

                        if (budgetList.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: ResponsiveHelper.spacing(50),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.folder_off,
                                    size: ResponsiveHelper.iconSize(80),
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                      height: ResponsiveHelper.spacing(10)),
                                  Text(
                                    AppStrings.noData.tr,
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.fontSize(18),
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: List.generate(
                            budgetList.length,
                                (index) {
                              final data = budgetList[index];

                              double totalBudget =
                                  data.amount?.toDouble() ?? 0.0;
                              double totalExpense =
                                  data.currentExpense?.toDouble() ?? 0.0;
                              double progress = totalBudget > 0
                                  ? (totalBudget - totalExpense) / totalBudget
                                  : 0.0;

                              progress = progress.clamp(0.0, 1.0);

                              return GestureDetector(
                                onTap: () {},
                                child: BudgetCard(
                                  image: data.budgetImage ?? "",
                                  title: data.category ?? "",
                                  month: data.budgetMonth ?? "",
                                  amount: totalBudget,
                                  progress: progress,
                                  progressColor: AppColors.red,
                                  backgroundColor: AppColors.blue100,
                                  iconColor: Colors.grey,
                                  amountColor: Colors.green,
                                  onTapExpense: () {
                                    Get.toNamed(
                                      AppRoutes.budgetDetailsScreen,
                                      arguments: [
                                        data.id,
                                        data.category,
                                        progress,
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}