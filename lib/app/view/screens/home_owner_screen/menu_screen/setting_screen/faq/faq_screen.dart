import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/info_controller/info_controller.dart';
import 'package:tidybayte/app/global/helper/GenerelError/general_error.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/components/no_internet_screen/no_internet_screen.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InfoController infoController = Get.find<InfoController>();

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.addedColor,
        body: Obx(() {
          switch (infoController.rxRequestStatus.value) {
            case Status.loading:
              return const CustomLoader();

            case Status.internetError:
              return NoInternetScreen(
                onTap: infoController.getFaq,
              );

            case Status.error:
              return GeneralErrorScreen(
                onTap: infoController.getFaq,
              );

            case Status.completed:
              final faqData =
                  infoController.faqList.value.data ?? []; // ✅ Fixed null issue

              if (faqData.isEmpty) {
                return const Center(
                  child: CustomText(
                    text: "No Data found",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }

              return Padding(
                padding:  ResponsiveHelper.symmetric(vertical: 20),
                child: Column(
                  children: [
                    CustomMenuAppbar(
                      title: AppStrings.faq.tr,
                      onBack: Get.back,
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding:  ResponsiveHelper.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: faqData.length,
                        itemBuilder: (context, index) {
                          final item = faqData[index];

                          return Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.employeeCardColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                /// **Question**
                                ListTile(
                                  title: CustomText(
                                    maxLines: 2,
                                    textAlign: TextAlign.start,
                                    text: item.question ??
                                        "No question available",
                                    color: Colors.black,
                                    fontSize: ResponsiveHelper.fontSize(14),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  trailing: Obx(() {
                                    final isSelected =
                                        infoController.selectedIndex.value ==
                                            index;
                                    return Icon(
                                      isSelected
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Colors.green,
                                    );
                                  }),
                                  onTap: () => infoController.toggleItem(index),
                                ),

                                /// **Answer**
                                Obx(() {
                                  final isSelected =
                                      infoController.selectedIndex.value ==
                                          index;
                                  return AnimatedCrossFade(
                                    firstChild: Container(),
                                    secondChild: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: CustomText(
                                        maxLines: 50,
                                        textAlign: TextAlign.start,
                                        text: item.description ??
                                            "No answer available",
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    crossFadeState: isSelected
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                    duration: const Duration(milliseconds: 300),
                                  );
                                }),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
          }
        }),
      ),
    );
  }
}
