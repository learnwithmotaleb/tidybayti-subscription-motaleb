import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformHelper {
  // Android
  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  // iOS
  static bool get isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  // Mobile (Android or iOS)
  static bool get isMobile => isAndroid || isIOS;

  // Web
  static bool get isWeb => kIsWeb;

  // Desktop
  static bool get isDesktop =>
      !kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.macOS ||
              defaultTargetPlatform == TargetPlatform.windows ||
              defaultTargetPlatform == TargetPlatform.linux);

  // Tablet (optional: can be based on screen size)
  static bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600 && !isDesktop;
  }
}