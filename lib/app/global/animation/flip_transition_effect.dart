import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlipTransitionEffect extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final double rotateValue = (animation.value - 0.5) * 3.1416;
        return Transform(
          transform: Matrix4.rotationY(rotateValue),
          alignment: Alignment.center,
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
