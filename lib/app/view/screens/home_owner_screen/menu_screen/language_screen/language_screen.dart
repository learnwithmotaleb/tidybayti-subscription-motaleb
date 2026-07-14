// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tidybayte/app/controller/language_controller/langauge_controller.dart';
// import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
// import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
// import 'package:tidybayte/app/view/components/custom_appbar/custom_appbar.dart';
// import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
// import 'package:tidybayte/app/view/components/custom_text_field/custom_text_field.dart';
//
// class LanguageScreen extends StatelessWidget {
//   LanguageScreen({super.key});
//
//   final LanguageController languageController = Get.find<LanguageController>();
//   final List<String> languageList = [
//     "English".tr, // Will translate to Arabic when Arabic is selected
//     "العربية".tr, // Will translate to English when English is selected
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.ltr,
//       child: Scaffold(
//         backgroundColor: AppColors.blue500,
//         appBar: CustomAppBar(
//           appBarContent: AppStrings.language.tr,
//           iconData: Icons.arrow_back,
//         ),
//         body: Obx(() {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ///===========================Select Your language==================
//                 CustomText(
//                   text: AppStrings.selectYourLanguage.tr,
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                   bottom: 10,
//                 ),
//
//                 /// Language selection row
//                 Expanded(
//                   flex: 2,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: 44,
//                         child: CustomTextField(
//                           inputTextStyle: const TextStyle(color: Colors.black),
//                           onTap: () {
//                             languageController.isLanguage.value =
//                                 !languageController.isLanguage.value;
//                           },
//                           readOnly: true,
//                           textEditingController: languageController.language,
//                           hintText: AppStrings.language.tr,
//                           fillColor: Colors.white,
//                           fieldBorderColor: AppColors.profileCard,
//                           suffixIcon: Icon(
//                             languageController.isLanguage.value
//                                 ? Icons.keyboard_arrow_up
//                                 : Icons.keyboard_arrow_down,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//
//                       /// Dropdown options
//                       if (languageController.isLanguage.value)
//                         Container(
//                           margin: const EdgeInsets.only(top: 8),
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: ListView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount: languageList.length,
//                             itemBuilder: (context, index) {
//                               return GestureDetector(
//                                 onTap: () {
//                                   final selectedLocale = index == 0
//                                       ? const Locale("en", "US")
//                                       : const Locale("ar", "SA");
//
//                                   languageController
//                                       .changeLocale(selectedLocale);
//                                 },
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 8),
//                                   child: CustomText(
//                                     text: languageList[index],
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 16,
//                                     color: languageController
//                                                 .selectedCategory.value ==
//                                             index
//                                         ? AppColors.profileCard
//                                         : Colors.black,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/language_controller/langauge_controller.dart';
import 'package:tidybayte/app/core/app_routes/app_routes.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_icons/app_icons.dart';
import 'package:tidybayte/app/utils/app_images/app_images.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_appbar/custom_appbar.dart';
import 'package:tidybayte/app/view/components/custom_button/custom_button.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/view/components/custom_text_field/custom_text_field.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key});

  final LanguageController languageController = Get.find<LanguageController>();
  final List<String> languageList = [
    "English".tr,
    "العربية".tr,
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.blue500,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.languageBg),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 18.h,),
                Row(
                  children: [
                    
                    IconButton(onPressed: (){
                      Get.back();
                    }, icon: Icon(Icons.arrow_back_ios,size: ResponsiveHelper.iconSize(24),)),
                    Expanded(
                      child: CustomText(
                            text: AppStrings.chooseYourLanguage.tr,
                            color: AppColors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 22.sp,
                          ),
                    ),
                  ],
                ),
                
                  SizedBox(height: 8.h),
                  Divider(color: Colors.grey.shade300),

                  // Device অনুযায়ী বাকি জায়গা নেবে
                  const Expanded(child: SizedBox()),

                  // Buttons
                  CustomButton(
                    width: double.infinity,
                    onTap: () {
                      languageController.changeLocale(const Locale("en", "US"));
                    },
                    fillColor: AppColors.white,
                    title: "English".tr,
                    radius: 16,
                    textColor: AppColors.englishText,
                  ),
                  SizedBox(height: 8.h),
                  CustomButton(
                    width: double.infinity,
                    onTap: () {
                      languageController.changeLocale(const Locale("ar", "SA"));
                    },
                    fillColor: AppColors.white,
                    title: "العربية".tr,
                    radius: 16,
                    textColor: AppColors.englishText,
                  ),
                  SizedBox(height: 58.h),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 28),
                    child: CustomButton(
                      width: double.infinity,
                      onTap: () {
                        Get.toNamed(AppRoutes.getStartedScreen,

                        );
                      },
                      fillColor: AppColors.buttonRed,
                      title: AppStrings.submit.tr,
                      radius: 16,
                      textColor: AppColors.white,
                      fontSize: 30.sp,

                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
