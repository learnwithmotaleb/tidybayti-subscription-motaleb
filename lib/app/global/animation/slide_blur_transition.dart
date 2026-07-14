import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

class SlideBlurTransition extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5.0 * (1 - animation.value),
              sigmaY: 5.0 * (1 - animation.value),
            ),
            child: Container(color: Colors.transparent),
          ),
        ),
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0), // ✅ Slide from left
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
      ],
    );
  }
}
