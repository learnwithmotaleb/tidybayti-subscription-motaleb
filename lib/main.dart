import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tidybayte/app/core/dependency/dependency_injection.dart';
import 'package:tidybayte/app/data/subscription/subscription_controller.dart';
import 'package:tidybayte/app/view/components/device_utils/device_utils.dart';
import 'app/controller/language_controller/langauge_controller.dart';
import 'app/core/app_routes/app_routes.dart';
import 'app/core/dependency/path.dart';
import 'app/global/helper/responsive_helper.dart';
import 'app/global/language/language_transalator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  GoogleFonts.config.allowRuntimeFetching = true;
  DeviceUtils.lockDevicePortrait();

  final languageController = Get.put(LanguageController());
  await languageController.loadLocal();
  await initDependencies();

  // ✅ Ensure SubscriptionController exists before any screen calls
  // Get.find<SubscriptionController>() — safe even if DependencyInjection
  // already registers it (Get.put returns the existing instance, doesn't
  // duplicate it).
  Get.put(SubscriptionController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Removed duplicate Get.put(LanguageController()) — already
    // registered in main(), calling it again here was redundant.
    final languageController = Get.find<LanguageController>();

    ResponsiveHelper.init(context);

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