import 'dart:async';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/global/helper/shared_prefe/shared_prefe.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  navigateScreen() async {
    // ✅ Get stored values
    String? token =
    await SharePrefsHelper.getString(AppConstants.token);

    bool? isOwner =
    await SharePrefsHelper.getBool(AppConstants.isOwner);

    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔍 SPLASH SCREEN DEBUG INFO:');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📌 token: $token');
    print('📌 isOwner: $isOwner');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    // ✅ No token = Not logged in
    if (token == null || token.isEmpty) {
      print('❌ User NOT logged in');
      Get.offAndToNamed(AppRoutes.getStartedLoadingScreen);
      return;
    }

    // ✅ Logged in as OWNER
    if (isOwner == true) {
      print('✅ OWNER LOGIN');
      Get.offAllNamed(AppRoutes.homeScreen);
      return;
    }

    // ✅ Logged in as EMPLOYEE
    if (isOwner == false) {
      print('✅ EMPLOYEE LOGIN');
      Get.offAllNamed(AppRoutes.employeeHomeScreen);
      return;
    }

    // ✅ Fallback
    Get.offAndToNamed(AppRoutes.getStartedLoadingScreen);
  }





  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      navigateScreen();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.blue500,
        body: Padding(
          padding: ResponsiveHelper.symmetric(vertical: 24, horizontal: 20),
          child:  Center(child: CustomLoader()),
        ),
      ),
    );
  }
}