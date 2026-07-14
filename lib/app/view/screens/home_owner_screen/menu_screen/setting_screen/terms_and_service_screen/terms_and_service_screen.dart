import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/controller/owner_controller/info_controller/info_controller.dart';
import 'package:tidybayte/app/global/helper/GenerelError/general_error.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_const/app_const.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_loader/custom_loader.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:tidybayte/app/view/components/no_internet_screen/no_internet_screen.dart';

class TermsAndServiceScreen extends StatefulWidget {
  const TermsAndServiceScreen({super.key});

  @override
  State<TermsAndServiceScreen> createState() => _TermsAndServiceScreenState();
}

class _TermsAndServiceScreenState extends State<TermsAndServiceScreen> {
  final InfoController infoController = Get.find<InfoController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      infoController.isApi = true; // Set to true for terms API
      infoController.infoData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.addedColor,
        body: Obx(() {
          switch (infoController.rxRequestStatus.value) {
            case Status.loading:
              return const CustomLoader();

            case Status.internetError:
              return NoInternetScreen(onTap: infoController.infoData);

            case Status.error:
              return GeneralErrorScreen(onTap: infoController.infoData);

            case Status.completed:
              return Padding(
                padding: ResponsiveHelper.symmetric(vertical: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomMenuAppbar(
                        title: AppStrings.termsOfService.tr,
                        onBack: Get.back,
                      ),
                      Padding(
                        padding: ResponsiveHelper.symmetric(horizontal: 20),
                        child: HtmlWidget(
                          infoController.termsData.value.description ??
                              AppStrings.noDescriptionAvailable.tr,
                        ),
                      ),
                    ],
                  ),
                ),
              );
          }
        }),
      ),
    );
  }
}
