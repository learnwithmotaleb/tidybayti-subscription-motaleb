import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BounceTransition extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.7, end: 1.0)
          .chain(CurveTween(curve: Curves.elasticOut)) // ✅ Bounce effect
          .animate(animation),
      child: child,
    );
  }
}
