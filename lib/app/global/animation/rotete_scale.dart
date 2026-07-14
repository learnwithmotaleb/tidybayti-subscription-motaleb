import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RotateScaleTransition extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return RotationTransition(
      turns: Tween<double>(begin: -0.2, end: 0.0).animate(animation),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.7, end: 1.0).animate(animation),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    );
  }
}
