import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;
  final RxBool isLoading = true.obs;
  final RxDouble loadingProgress = 0.0.obs;

  @override
  void initState() {
    super.initState();

    final arguments = Get.arguments ?? {};
    final String url = arguments["url"] ?? "";

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)

      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 '
            '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
      )

      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            loadingProgress.value = progress / 100;
          },
          onPageStarted: (String url) {
            isLoading.value = true;
          },
          onPageFinished: (String url) {
            isLoading.value = false;
          },
          onWebResourceError: (WebResourceError error) {
            // ✅ এই line add করো
            if (error.isForMainFrame == false) return;

            Get.snackbar(
              "Error",
              "Failed to load content: ${error.description}",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(url));


    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(false);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments ?? {};
    final String title = arguments["title"] ?? AppStrings.recipeDetails.tr;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xCCE8F3FA),
                Color(0xFFB5D8EE),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                CustomMenuAppbar(
                  title: title,
                  onBack: () => Get.back(),
                ),

                // Loading Progress Bar
                Obx(() => isLoading.value
                    ? LinearProgressIndicator(
                  value: loadingProgress.value,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.blue900,
                  ),
                )
                    : const SizedBox.shrink()),

                // WebView
                Expanded(
                  child: Obx(() => Stack(
                    children: [
                      WebViewWidget(controller: controller),

                      // Loading overlay
                      if (isLoading.value)
                        Container(
                          color: Colors.white.withOpacity(0.8),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.blue900,
                            ),
                          ),
                        ),
                    ],
                  )),
                ),

                // Bottom navigation controls (optional)
                Container(
                  color: Colors.white,
                  padding:  ResponsiveHelper.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () async {
                          if (await controller.canGoBack()) {
                            controller.goBack();
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () async {
                          if (await controller.canGoForward()) {
                            controller.goForward();
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          controller.reload();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}