import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tidybayte/app/core/dependency/dependency_injection.dart';
import 'package:tidybayte/app/view/components/device_utils/device_utils.dart';
import 'app/controller/language_controller/langauge_controller.dart';
import 'app/core/app_routes/app_routes.dart';
import 'app/core/dependency/path.dart';
import 'app/global/helper/responsive_helper.dart';
import 'app/global/language/language_transalator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 // GoogleFonts.config.allowRuntimeFetching = false;

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  GoogleFonts.config.allowRuntimeFetching = true;
  DeviceUtils.lockDevicePortrait();

  final languageController = Get.put(LanguageController());
  await languageController.loadLocal();
  await initDependencies();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.put(LanguageController());

    // ✅ Initialize ResponsiveHelper here
    ResponsiveHelper.init(context);

    debugPrint(
        "height====================${MediaQuery.of(context).size.height}");
    debugPrint("width====================${MediaQuery.of(context).size.width}");

    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(411, 840),
      child: GetMaterialApp(
        initialBinding: DependencyInjection(),
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),
        initialRoute: AppRoutes.splashScreen,
        navigatorKey: Get.key,
        getPages: AppRoutes.routes,
        locale: languageController.locale,
        fallbackLocale: const Locale('en', 'US'),
        translations: Language(),
      ),
    );
  }
}