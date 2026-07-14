import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class HelpWhereScreen extends StatefulWidget {
  const HelpWhereScreen({super.key});

  @override
  State<HelpWhereScreen> createState() => _HelpWhereScreenState();
}

class _HelpWhereScreenState extends State<HelpWhereScreen> {
  final String supportEmail = "support@tidybayte.com";

  final String videoUrl =
      // "https://drive.google.com/file/d/16bH3EjyFfNlWjYrc-GOJDy1wJKITbCOo/preview";
      "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";

  late VideoPlayerController _videoController;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );

      await _videoController.initialize();

      setState(() {
        _isInitialized = true;
      });

      // Auto play (optional)
      // _videoController.play();
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      debugPrint('Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  /// ------------------- OPEN EMAIL APP -------------------
  Future<void> openMailApp() async {
    const String emailSubject = "Support Needed";
    final Uri mail = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: "subject=${Uri.encodeComponent(emailSubject)}",
    );

    try {
      if (await canLaunchUrl(mail)) {
        await launchUrl(
          mail,
          mode: LaunchMode.externalApplication,
        );
      } else {
        try {
          await launchUrl(
            Uri.parse('https://mail.google.com'),
            mode: LaunchMode.externalApplication,
          );
        } catch (e) {
          Get.snackbar(
            "Error",
            "No email app found. Please ensure Gmail is installed and try again.",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4),
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Could not open email app: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.howToUse.tr,
          ),
          backgroundColor: AppColors.white,
        ),
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
          child: Column(
            children: [
              /// ------------------- VIDEO PLAYER -------------------
              Padding(
                padding: ResponsiveHelper.all(20),
                child: Container(
                  height: 220.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(16),),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(16),),
                    child: _hasError
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.white,
                                  size: ResponsiveHelper.iconSize(50),
                                ),
                                SizedBox(height: ResponsiveHelper.spacing(16),),
                                CustomText(
                                  text: "Could not load video",
                                  color: Colors.white,
                                  fontSize: ResponsiveHelper.fontSize(14),
                                ),
                              ],
                            ),
                          )
                        : !_isInitialized
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              )
                            : Stack(
                                children: [
                                  // Video Player
                                  Center(
                                    child: AspectRatio(
                                      aspectRatio:
                                          _videoController.value.aspectRatio,
                                      child: VideoPlayer(_videoController),
                                    ),
                                  ),

                                  // Play/Pause Button Overlay
                                  Positioned.fill(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (_videoController
                                              .value.isPlaying) {
                                            _videoController.pause();
                                          } else {
                                            _videoController.play();
                                          }
                                        });
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Center(
                                          child: AnimatedOpacity(
                                            opacity:
                                                _videoController.value.isPlaying
                                                    ? 0.0
                                                    : 1.0,
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: Container(
                                              padding: ResponsiveHelper.all(15),
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                                size: ResponsiveHelper.iconSize(50),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Video Progress Bar
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: VideoProgressIndicator(
                                      _videoController,
                                      allowScrubbing: true,
                                      colors: VideoProgressColors(
                                        playedColor: AppColors.primary,
                                        bufferedColor:
                                            Colors.white.withOpacity(0.5),
                                        backgroundColor:
                                            Colors.white.withOpacity(0.2),
                                      ),
                                      padding: ResponsiveHelper.symmetric(
                                        vertical: 8,
                                        horizontal: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                  ),
                ),
              ),

              const Spacer(),

              /// ------------------- SUPPORT EMAIL CARD -------------------
              Padding(
                padding: ResponsiveHelper.symmetric(horizontal: 20),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: openMailApp,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(16),),
                    child: Container(
                      padding: ResponsiveHelper.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(ResponsiveHelper.borderRadius(16),),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: ResponsiveHelper.borderRadius(24),
                            backgroundColor:
                                AppColors.primary.withOpacity(0.15),
                            child: Icon(
                              Icons.email_outlined,
                              color: AppColors.primary,
                              size: 28.r,
                            ),
                          ),
                          SizedBox(width: ResponsiveHelper.spacing(16),),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: AppStrings.needHelp.tr,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: ResponsiveHelper.fontSize(16),
                                ),
                                SizedBox(height: ResponsiveHelper.spacing(4),),
                                CustomText(
                                  text: supportEmail,
                                  color: Colors.grey,
                                  fontSize: ResponsiveHelper.fontSize(14),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: ResponsiveHelper.iconSize(8),),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: ResponsiveHelper.spacing(60),),
            ],
          ),
        ),
      ),
    );
  }
}
