import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../utils/app_strings/app_strings.dart';
import '../inner_widgets/smart_grocery_input.dart';
import 'grocery_item_list_controller.dart';

class SelectGroceryShit extends StatefulWidget {
  final List<String> initiallySelected;

  const SelectGroceryShit({super.key, this.initiallySelected = const []});

  @override
  State<SelectGroceryShit> createState() => _SelectGroceryShitState();
}

class _SelectGroceryShitState extends State<SelectGroceryShit> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GroceryItemListController _controller =
      Get.find<GroceryItemListController>();

  // ✅ Support multiple selections
  late List<String> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems =
        List<String>.from(widget.initiallySelected); // ✅ keep old items
    _searchController.addListener(_onSearchChanged);
    Future.delayed(Duration.zero, () {
      _controller.getGroceries();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() => setState(() {});

  // void _toggleSelection(String item) {
  //   setState(() {
  //     if (_selectedItems.contains(item)) {
  //       _selectedItems.remove(item);
  //     } else {
  //       _selectedItems.add(item);
  //     }
  //   });
  // }

  // List<String> _getAllGroceryNames(GroceryItemListController controller) {
  //   final data = controller.groceries.value;
  //   final all = [
  //     ...?data.fruits,
  //     ...?data.vegetables,
  //     ...?data.personalCare,
  //     ...?data.householdCareCleaning,
  //     ...?data.frozenFood,
  //     ...?data.beverages,
  //     ...?data.homeBaking,
  //     ...?data.snacks,
  //     ...?data.sugarSweetsChocolates,
  //     ...?data.herbsSpicesSeasoning,
  //     ...?data.driedFruitsNutsSeeds,
  //     ...?data.dairy,
  //     ...?data.saucesDressingsCondimentsJamsHoneysSyrupsSpreads,
  //     ...?data.pastaRicePulsesCereals,
  //     ...?data.cannedFood,
  //     ...?data.breadAndBakedGoods,
  //     ...?data.meat,
  //     ...?data.fishSeafood,
  //     ...?data.meatAlternatives,
  //   ];

  //   final query = _searchController.text.trim().toLowerCase();
  //   if (query.isEmpty) return all;
  //   return all.where((e) => e.toLowerCase().contains(query)).toList();
  // }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.95,
            minChildSize: 0.25,
            builder: (_, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.borderRadius(20))),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top grab handle
                    Center(
                      child: Container(
                        width: ResponsiveHelper.iconSize(40),
                        height: ResponsiveHelper.iconSize(5),
                        margin: EdgeInsets.only(top: ResponsiveHelper.height(8), bottom: ResponsiveHelper.height(12)),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(12)),
                        ),
                      ),
                    ),

                    // Header
                    Padding(
                      padding: ResponsiveHelper.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                AppStrings.selectGroceryItems.tr,
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    const Divider(color: AppColors.lightBorder),

                    // Content
                    Expanded(
                      child: Padding(
                        padding: ResponsiveHelper.symmetric(
                            horizontal: 20, vertical: 8),
                        child: SingleChildScrollView(
                          // ✅ Fix overflow
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Selected items & search field
                              // SelectedGroceryRow(
                              //   selectedUsers: _selectedItems,
                              //   searchController: _searchController,
                              //   scrollController: _scrollController,
                              //   onUserRemoved: (item) => _toggleSelection(item),
                              // ),
                              SmartGroceryInput(
                                allSuggestions: [
                                  ...?_controller.groceries.value.fruits,
                                  ...?_controller.groceries.value.vegetables,
                                  ...?_controller.groceries.value.personalCare,
                                  ...?_controller
                                      .groceries.value.householdCareCleaning,
                                  ...?_controller.groceries.value.frozenFood,
                                  ...?_controller.groceries.value.beverages,
                                  ...?_controller.groceries.value.homeBaking,
                                  ...?_controller.groceries.value.snacks,
                                  ...?_controller
                                      .groceries.value.sugarSweetsChocolates,
                                  ...?_controller
                                      .groceries.value.herbsSpicesSeasoning,
                                  ...?_controller
                                      .groceries.value.driedFruitsNutsSeeds,
                                  ...?_controller.groceries.value.dairy,
                                  ...?_controller.groceries.value
                                      .saucesDressingsCondimentsJamsHoneysSyrupsSpreads,
                                  ...?_controller
                                      .groceries.value.pastaRicePulsesCereals,
                                  ...?_controller.groceries.value.cannedFood,
                                  ...?_controller
                                      .groceries.value.breadAndBakedGoods,
                                  ...?_controller.groceries.value.meat,
                                  ...?_controller.groceries.value.fishSeafood,
                                  ...?_controller
                                      .groceries.value.meatAlternatives,
                                ],
                                initialItems:
                                    _selectedItems, // ✅ keep previously selected items
                                onChanged: (items) {
                                  setState(() {
                                    _selectedItems = items;
                                  });
                                },
                              ),

                              // const Divider(color: AppColors.lightBorder),
                              // SizedBox(height: 12.h),

                              // Text(
                              //   'Grocery Items',
                              //   style: textTheme.bodyMedium?.copyWith(
                              //     fontWeight: FontWeight.w900,
                              //   ),
                              // ),
                              // SizedBox(height: 8.h),

                              // // List of grocery items
                              // Expanded(
                              //   child: Obx(() {
                              //     if (_controller.rxRequestStatus.value ==
                              //         Status.loading) {
                              //       return const Center(
                              //         child: CircularProgressIndicator(
                              //           color: Colors.lightBlueAccent,
                              //         ),
                              //       );
                              //     }
                              //     if (_controller.rxRequestStatus.value ==
                              //         Status.error) {
                              //       return const Center(
                              //         child: CustomText(
                              //           top: 20,
                              //           fontWeight: FontWeight.w500,
                              //           fontSize: 16,
                              //           text: 'No Internet',
                              //           color: Colors.black,
                              //         ),
                              //       );
                              //     }

                              //     final groceries =
                              //         _getAllGroceryNames(_controller);

                              //     return ListView.builder(
                              //       controller: scrollController,
                              //       itemCount: groceries.length,
                              //       itemBuilder: (context, index) {
                              //         final item = groceries[index];
                              //         return SuggestedGroceryTile(
                              //           user: item,
                              //           selected: _selectedItems.contains(item),
                              //           onTap: () => _toggleSelection(item),
                              //         );
                              //       },
                              //     );
                              //   }),
                              // ),
                              SizedBox(height: 12.h),

                              // Add button
                              SizedBox(
                                width: double.infinity,
                                height: 44.h,
                                child: ElevatedButton(
                                  onPressed: _selectedItems.isEmpty
                                      ? null
                                      : () {
                                          Get.back(result: {
                                            'SelectedItems': _selectedItems,
                                          });
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(8)),
                                    ),
                                  ),
                                  child: Text(
                                    AppStrings.submit.tr,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
