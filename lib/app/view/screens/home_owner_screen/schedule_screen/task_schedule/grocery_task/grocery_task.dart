import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/grocery_controller/grocery_controller.dart';
import 'package:tidybayte/app/data/service/api_url.dart';
import 'package:tidybayte/app/global/helper/global_alart/global_alart.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/custom_room_card/custom_room_card.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import '../../../../../../data/model/owner_model/grocery_model/grocery_model.dart';
import '../../../../employee_screen/employee_grocery/custom_grocery_details_dialog.dart';
import 'inner_widgets/add_grocery_button.dart';

class GroceryTask extends StatefulWidget {
  const GroceryTask({super.key});

  @override
  State<GroceryTask> createState() => _GroceryTaskState();
}

class _GroceryTaskState extends State<GroceryTask> {
  final GroceryController controller = Get.find<GroceryController>();

  @override
  void initState() {
    super.initState();

    // ✅ Load initial pending grocery list ONLY ONCE
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectedTabIndex.value = 0;
      controller.fetchGroceryData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Container(
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
                CustomMenuAppbar(
                  title: AppStrings.shopping.tr,
                  onBack: () => Get.back(),
                ),

                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView(
                      padding:  ResponsiveHelper.symmetric(horizontal: 30),
                      children: [
                        const AddGroceryButton(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTabButton(
                              AppStrings.pendingShopping.tr,
                              0,
                              ApiUrl.getGroceryOngoing,
                            ),
                            _buildTabButton(
                              AppStrings.completedShopping.tr,
                              1,
                              ApiUrl.groceryComplete,
                            ),
                          ],
                        ),

                         SizedBox(height: ResponsiveHelper.spacing(20)),

                        _buildGroceryList(),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index, String apiUrl) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          controller.selectedTabIndex.value = index;
          controller.isLoading.value = true;
          await controller.getMyGrocery(apiUrl: apiUrl);
          controller.isLoading.value = false;
        },
        child: Obx(() => Container(
          margin:  ResponsiveHelper.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: controller.selectedTabIndex.value == index
                ? AppColors.blue900
                : Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
            border: Border.all(
              color: controller.selectedTabIndex.value == index
                  ? AppColors.blue900
                  : AppColors.blue50,
            ),
          ),
          padding:  ResponsiveHelper.all(10),
          child: CustomText(
            text: title,
            textAlign: TextAlign.center,
            color: controller.selectedTabIndex.value == index
                ? Colors.white
                : AppColors.blue900,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        )),
      ),
    );
  }

  Widget _buildGroceryList() {
    final groceryData = controller.groceryData;

    if (groceryData.isEmpty) {
      return  Padding(
        padding: EdgeInsets.only(top: ResponsiveHelper.padding(50)),
        child: Center(
          child: CustomText(
            text: "No Data Found",
            color: AppColors.blue900,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Column(
      children: List.generate(groceryData.length, (index) {
        final GroceryModel data = groceryData[index];

        String taskName = (data.groceryList != null && data.groceryList!.isNotEmpty)
            ? data.groceryList!.join(", ")
            : "No Task Name";

        return Padding(
          padding:  EdgeInsets.only(bottom: ResponsiveHelper.padding(10)),
          child: CustomRoomCard(
            taskName: taskName,
            assignedTo:
            "${data.assignedTo?.firstName ?? ""} ${data.assignedTo?.lastName ?? ""}",
            time: '${data.startTimeStr ?? ""} To ${data.endTimeStr ?? ""}',
            onInfoPressed: () {
              _showTaskDetailsDialog(context, data);
            },
            onDeletePressed: () async {
              final bool? confirmed = await GlobalAlert.showDeleteDialog(
                context,
                    () async {
                  await controller.removeGrocery(groceryId: data.id ?? "");
                },
                "Are You Sure you want to remove",
              );

              if (confirmed ?? false) {
                print("✅ Grocery deleted");
              }
            },
          ),
        );
      }),
    );
  }

  void _showTaskDetailsDialog(BuildContext context, GroceryModel data) {
    showDialog(
      context: context,
      builder: (_) => CustomGroceryDetailsDialog(
        assignTo:
        '${data.assignedTo?.firstName ?? ""} ${data.assignedTo?.lastName ?? ""}',
        startTime: data.startTimeStr ?? 'N/A',
        endTime: data.endTimeStr ?? 'N/A',
        date: data.startDateStr ?? 'N/A',
        groceryItems: data.groceryList ?? [],
      ),
    );
  }
}
