import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/utils/app_images/app_images.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';

import 'package:tidybayte/app/view/components/custom_image/custom_image.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

class HouseTypeScreen extends StatefulWidget {
  const HouseTypeScreen({super.key});

  @override
  State<HouseTypeScreen> createState() => _HouseTypeScreenState();
}

class _HouseTypeScreenState extends State<HouseTypeScreen> {
  List categoryType = [
    AppStrings.custom.tr,
    AppStrings.mansion.tr,
    AppStrings.villa.tr,
    AppStrings.apartment.tr,
    AppStrings.beachHouse.tr,

    AppStrings.bungalow.tr,
  ];
  List houseTextColor = [
    AppColors.dark500,
    AppColors.dark500,
    AppColors.dark500,
    AppColors.red,
    AppColors.freeServiceColor,
    AppColors.dark300,
  ];

  List houseImages = [
    // AppImages.custom,
    // AppImages.mansion,
    // AppImages.bungalow,
    // AppImages.villa,
    // AppImages.house,
    // AppImages.apartMent,

    AppIcons.customNewRoom,
    AppIcons.mansionNewRoom,
    AppIcons.vilaNewRoom,
    AppIcons.apartmentNewRoom,
    AppIcons.beachHouseNewRoom,
    AppIcons.bungalowNewRoom,
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.imageBg,
        body: Stack(
          children: [
            // Background image
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .85, // নিচে gap থাকবে
              child: Image.asset(
                AppImages.houseType,
                fit: BoxFit.cover,
              ),
            ),
            // Foreground content
            SingleChildScrollView(
              padding: ResponsiveHelper.symmetric(vertical: 100, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [



                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // এটি icon এবং text কে একই লাইনের মাঝখানে (vertically center) রাখবে
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero, // ডিফল্ট গ্যাপ সরানোর জন্য
                            constraints: const BoxConstraints(), // অতিরিক্ত জায়গা কমানোর জন্য
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: ResponsiveHelper.iconSize(16)
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.width(8)), // আইকন এবং লেখার মাঝে কিছুটা গ্যাপ
                          Expanded( // টেক্সট বড় হলে যেন ওভারফ্লো না হয়
                            child: CustomText(
                              text: AppStrings.chooseYourHouseType.tr,
                              color: AppColors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: ResponsiveHelper.fontSize(24)
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height:ResponsiveHelper.spacing(8),
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 1, // প্রয়োজন হলে থিকনেস দিতে পারেন
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 100.h,
                  // ),
                  // // const CustomImage(
                  // //   imageSrc: AppImages.houseImages,
                  // //   imageType: ImageType.png,
                  // // ),
                  SizedBox(
                    height: ResponsiveHelper.spacing(350)
                  ),



                  GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 18,
                              mainAxisExtent: 100),
                      itemCount: categoryType.length,
                      itemBuilder: (BuildContext context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.houseInformationScreen,
                                arguments:
                                    index == 0 ? "" : categoryType[index]);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x14000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 0),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            padding: ResponsiveHelper.symmetric(
                                vertical: 14, horizontal: 12),


                            // child: Column(
                            //   children: [
                            //     CustomImage(
                            //       imageSrc: houseImages[index],
                            //       imageType: ImageType.svg,
                            //     ),
                            //     CustomText(
                            //       text: categoryType[index],
                            //       color: AppColors.dark500,
                            //       fontWeight: FontWeight.w400,
                            //       fontSize: 16,
                            //     ),
                            //   ],
                            // ),


                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center, // 👈 icon + text vertical center
                                crossAxisAlignment: CrossAxisAlignment.center, // 👈 horizontal center
                                children: [
                                  CustomImage(
                                    imageSrc: houseImages[index],
                                    imageType: ImageType.svg,
                                    sizeHeight: ResponsiveHelper.iconSize(40), // optional, icon size fix করতে চাইলে
                                    sizeWidth: ResponsiveHelper.iconSize(40),
                                    imageColor:AppColors.iconColor
                                  ),
                                  SizedBox(height: ResponsiveHelper.spacing(8)), // icon আর text এর মধ্যে gap
                                  CustomText(
                                    text: categoryType[index],
                                    color: AppColors.dark500,
                                    fontWeight: FontWeight.w400,
                                    fontSize: ResponsiveHelper.fontSize(14),
                                    textAlign: TextAlign.center, // text center
                                  ),
                                ],
                              ),
                            ),







                          ),
                        );
                      }),


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
