// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';

class SuggestedGroceryTile extends StatelessWidget {
  final String user;
  final bool selected;
  final VoidCallback onTap;

  const SuggestedGroceryTile({
    required this.user,
    required this.selected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  ResponsiveHelper.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Radio<String>(
              value: user,
              groupValue: selected ? user : null,
              onChanged: (_) => onTap(),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
           SizedBox(width: ResponsiveHelper.width(8)),
          Text(user,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.black)),
        ],
      ),
    );
  }
}
