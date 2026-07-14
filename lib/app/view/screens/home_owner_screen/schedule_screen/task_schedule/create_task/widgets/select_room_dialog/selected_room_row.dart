import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';

import '../../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../../utils/app_strings/app_strings.dart';

class SelectedRoomRow extends StatelessWidget {
  final List<String> selectedUsers;
  final TextEditingController searchController;
  final ScrollController scrollController;
  final Function(String) onUserRemoved;

  const SelectedRoomRow({
    required this.selectedUsers,
    required this.searchController,
    required this.scrollController,
    required this.onUserRemoved,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding:  ResponsiveHelper.symmetric(vertical: 8),
      child: Row(
        children: [
          // Text(
          //   "To:",
          //   style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...selectedUsers.map(
                    (user) => Padding(
                      padding:  EdgeInsets.only(right: ResponsiveHelper.padding(8)),
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.lightBlueBackground,
                          borderRadius: BorderRadius.circular( ResponsiveHelper.borderRadius(20)),
                        ),
                        padding:  ResponsiveHelper.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        margin:  ResponsiveHelper.all(
                          4,
                        ), // equivalent to Chip's padding
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              user,
                              style:  TextStyle(
                                fontSize:  ResponsiveHelper.fontSize(14),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                             SizedBox(width:  ResponsiveHelper.spacing(8)),
                            GestureDetector(
                              onTap: () => onUserRemoved(user),
                              child:  Icon(Icons.close, size:  ResponsiveHelper.iconSize(18)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width:
                        searchController.text.isEmpty && selectedUsers.isEmpty
                            ? 100
                            : null,
                    child: IntrinsicWidth(
                      stepWidth: 10,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: AppStrings.searchHint.tr,
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
