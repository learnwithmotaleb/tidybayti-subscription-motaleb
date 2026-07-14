import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../time_helper/time_helper.dart';

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final DateTime createdAt; // Pass the createdAt DateTime here
  final String date;

  const NotificationCard({
    super.key,
    required this.icon,
    required this.title,
    required this.createdAt,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate timeAgo dynamically here
    final timeAgo = TimeHelper.timeAgo(
        createdAt.toLocal()); // Using the helper method to calculate time ago

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 30.sp),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5.h),
                // SizedBox(height: 5.h),
                // Text(
                //   date,
                //   style: TextStyle(
                //     fontSize: 12.sp,
                //     color: Colors.grey,
                //   ),
                // ),
                Text(
                  timeAgo, // Display the time ago dynamically
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
