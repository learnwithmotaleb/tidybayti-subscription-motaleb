import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScaleTransitionEffect extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve, // ✅ Nullable Curve
      Alignment? alignment, // ✅ Nullable Alignment
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: curve ?? Curves.easeOut, // ✅ Handle null case
        ),
      ),
      child: child,
    );
  }
}
