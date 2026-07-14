import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import '../../../../../../../../controller/owner_controller/select_room_controller/select_room_controller.dart';
import '../../../../../../../../global/helper/responsive_helper.dart';
import '../../../../../../../../global/helper/shared_prefe/shared_prefe.dart';
import '../../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../../utils/app_strings/app_strings.dart';
import '../../../../../../../components/custom_text/custom_text.dart';
import 'selected_room_row.dart';
import 'suggested_room_tile.dart';

class SelectRoomDialog extends StatefulWidget {
  final List<String>? preSelectedRoomIds;
  final List<String>? preSelectedRoomNames;

  const SelectRoomDialog({
    super.key,
    this.preSelectedRoomIds,
    this.preSelectedRoomNames,
  });

  @override
  State<SelectRoomDialog> createState() => _SelectRoomSheetState();
}

class _SelectRoomSheetState extends State<SelectRoomDialog> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SelectRoomController _controller = Get.find<SelectRoomController>();

  List<String> _selectedRooms = [];
  List<String> _selectedRoomIds = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadSavedHouseAndRoom();

    if (widget.preSelectedRoomNames != null &&
        widget.preSelectedRoomIds != null) {
      _selectedRooms = List.from(widget.preSelectedRoomNames!);
      _selectedRoomIds = List.from(widget.preSelectedRoomIds!);
      _controller.selectedRoomIdList.value =
          List.from(widget.preSelectedRoomIds!);
      print('✅ Pre-selected rooms: $_selectedRooms');
      print('✅ Pre-selected IDs: $_selectedRoomIds');
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadSavedHouseAndRoom() async {
    final savedHouseId = await SharePrefsHelper.getSelectedHouseId();
    if (savedHouseId != null && savedHouseId.isNotEmpty) {
      _controller.getRooms(houseId: savedHouseId);
    }
  }

  void _onSearchChanged() => setState(() {});

  void _toggleRoomSelection(String roomName, String roomId) {
    setState(() {
      if (_selectedRoomIds.contains(roomId)) {
        int index = _selectedRoomIds.indexOf(roomId);
        _selectedRoomIds.removeAt(index);
        _selectedRooms.removeAt(index);
      } else {
        _selectedRooms.add(roomName);
        _selectedRoomIds.add(roomId);
      }
      _controller.selectedRoomIdList.value = List.from(_selectedRoomIds);
      _searchController.clear();
      print('✅ Selected rooms: $_selectedRooms');
      print('✅ Selected IDs: $_selectedRoomIds');
    });
  }

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
            initialChildSize: 0.9,
            minChildSize: 0.4,
            maxChildSize: 0.95,
            builder: (_, sheetScrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                      ResponsiveHelper.borderRadius(20), // ✅ was: 20.r
                    ),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== Top Handle =====
                    Center(
                      child: Container(
                        width: ResponsiveHelper.width(40),    // ✅ was: 40.w
                        height: ResponsiveHelper.height(5),   // ✅ was: 5.h
                        margin: EdgeInsets.only(
                          top: ResponsiveHelper.spacing(10),    // ✅ was: 10.h
                          bottom: ResponsiveHelper.spacing(12), // ✅ was: 12.h
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(12), // ✅ was: 12.r
                          ),
                        ),
                      ),
                    ),

                    // ===== Header =====
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.padding(20), // ✅ was: 20.w
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                AppStrings.selectRoom.tr,
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
                    SizedBox(height: ResponsiveHelper.spacing(10)), // ✅ was: 10.h
                    Divider(
                      color: AppColors.lightBorder,
                      height: ResponsiveHelper.height(0), // ✅ was: 0.h
                    ),

                    // ===== Selected Items + Search =====
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.padding(20), // ✅ was: 20.w
                      ),
                      child: Column(
                        children: [
                          SelectedRoomRow(
                            selectedUsers: _selectedRooms,
                            searchController: _searchController,
                            scrollController: _scrollController,
                            onUserRemoved: (room) {
                              int index = _selectedRooms.indexOf(room);
                              if (index >= 0 &&
                                  index < _selectedRoomIds.length) {
                                _toggleRoomSelection(
                                    room, _selectedRoomIds[index]);
                              }
                            },
                          ),
                          Divider(
                            color: AppColors.lightBorder,
                            height: ResponsiveHelper.height(0), // ✅ was: 0.h
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(12)), // ✅ was: 12.h
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppStrings.suggested.tr,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.spacing(8)), // ✅ was: 8.h
                        ],
                      ),
                    ),

                    // ===== List =====
                    Expanded(
                      child: Obx(() {
                        if (_controller.rxRequestStatus.value ==
                            Status.loading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.lightBlueAccent,
                            ),
                          );
                        }
                        if (_controller.rxRequestStatus.value == Status.error) {
                          return Center(
                            child: CustomText(
                              top: ResponsiveHelper.spacing(20), // ✅ was: 20
                              fontWeight: FontWeight.w500,
                              fontSize: ResponsiveHelper.fontSize(16), // ✅ was: 16
                              text: AppStrings.noInternet.tr,
                              color: Colors.black,
                            ),
                          );
                        }

                        final rooms = _controller.roomList;
                        final filteredRooms = rooms.where((room) {
                          final roomName = room.name;
                          return roomName != null &&
                              roomName.isNotEmpty &&
                              roomName.toLowerCase().contains(
                                  _searchController.text.toLowerCase());
                        }).toList();

                        if (filteredRooms.isEmpty) {
                          return Center(
                            child: CustomText(
                              top: ResponsiveHelper.spacing(20), // ✅ was: 20
                              fontWeight: FontWeight.w500,
                              fontSize: ResponsiveHelper.fontSize(16), // ✅ was: 16
                              text: AppStrings.noRoomsAvailable.tr,
                              color: Colors.grey,
                            ),
                          );
                        }

                        return ListView.builder(
                          controller: sheetScrollController,
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.padding(20), // ✅ was: 20.w
                          ),
                          itemCount: filteredRooms.length,
                          itemBuilder: (context, index) {
                            final room = filteredRooms[index];
                            final roomId = room.id ?? '';
                            return SuggestedRoomTile(
                              user: room.name ?? '',
                              selected: _selectedRoomIds.contains(roomId),
                              onTap: () => _toggleRoomSelection(
                                  room.name ?? '', roomId),
                            );
                          },
                        );
                      }),
                    ),

                    // ===== Bottom Button =====
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        ResponsiveHelper.padding(20),  // ✅ was: 20.w
                        ResponsiveHelper.spacing(8),   // ✅ was: 8.h
                        ResponsiveHelper.padding(20),  // ✅ was: 20.w
                        ResponsiveHelper.spacing(20),  // ✅ was: 20.h
                      ),
                      child: SizedBox(
                        height: ResponsiveHelper.height(44), // ✅ was: 44.h
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _selectedRooms.isEmpty
                              ? null
                              : () {
                            Get.back(result: {
                              'RoomNames': _selectedRooms,
                              'RoomIds': _selectedRoomIds,
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveHelper.borderRadius(8), // ✅ was: 8.r
                              ),
                            ),
                          ),
                          child: Text(
                            AppStrings.selectRoom.tr,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.white,
                            ),
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