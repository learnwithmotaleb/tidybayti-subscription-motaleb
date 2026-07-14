import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';



class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return   Center(
      child: SpinKitCircle(
        //color: AppColors.blue900,
        color: AppColors.blue,
        // color: AppColors.appBarBackground,
        size: 60.h,
      ),
    );
    /*Center(child:

    Center(
    child: SpinKitSpinningLines(
    color: AppColors.blue,
      size: 50.0,
    ),
    ),);*/
  }
}