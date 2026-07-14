import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_menu_appbar/custom_menu_appbar.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({super.key});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 0.obs;

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments ?? {};

    // ✅ Support BOTH pdfPath (local) and pdfUrl (server)
    final String? pdfPath = arguments["pdfPath"];
    final String? pdfUrl = arguments["pdfUrl"];
    final String title = arguments["title"] ?? AppStrings.recipeDetails.tr;

    // ✅ Determine if it's a local file or server URL
    final bool isLocalFile = pdfPath != null && pdfPath.isNotEmpty;
    final bool isServerUrl = pdfUrl != null && pdfUrl.isNotEmpty;

    // ✅ Debug prints
    print("========== PDF VIEWER DEBUG ==========");
    print("Local Path: $pdfPath");
    print("Server URL: $pdfUrl");
    print("Is Local File: $isLocalFile");
    print("Is Server URL: $isServerUrl");
    print("=====================================");

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

                // Page counter
                Obx(() => totalPages.value > 0
                    ? Container(
                  padding:  ResponsiveHelper.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: Colors.black87,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Page ${currentPage.value} of ${totalPages.value}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink()),

                // PDF Viewer
                Expanded(
                  child: _buildPdfViewer(isLocalFile, isServerUrl, pdfPath, pdfUrl),
                ),

                // Bottom toolbar
                Container(
                  color: Colors.white,
                  padding:  ResponsiveHelper.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Previous page
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          if (currentPage.value > 1) {
                            _pdfViewerController.previousPage();
                          }
                        },
                      ),

                      // Zoom out
                      IconButton(
                        icon: const Icon(Icons.zoom_out),
                        onPressed: () {
                          _pdfViewerController.zoomLevel =
                              _pdfViewerController.zoomLevel - 0.25;
                        },
                      ),

                      // Zoom in
                      IconButton(
                        icon: const Icon(Icons.zoom_in),
                        onPressed: () {
                          _pdfViewerController.zoomLevel =
                              _pdfViewerController.zoomLevel + 0.25;
                        },
                      ),

                      // Next page
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          if (currentPage.value < totalPages.value) {
                            _pdfViewerController.nextPage();
                          }
                        },
                      ),

                      // Jump to page
                      IconButton(
                        icon: const Icon(Icons.list),
                        onPressed: () {
                          _showPageJumpDialog();
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

  // ✅ NEW: Build appropriate PDF viewer based on source
  Widget _buildPdfViewer(bool isLocalFile, bool isServerUrl, String? pdfPath, String? pdfUrl) {
    if (!isLocalFile && !isServerUrl) {
      return const Center(
        child: Text("No PDF file found"),
      );
    }

    return Container(
      color: Colors.white,
      child: isServerUrl
          ? _buildServerPdfViewer(pdfUrl!)
          : _buildLocalPdfViewer(pdfPath!),
    );
  }

  // ✅ NEW: Server PDF viewer (downloads from URL)
  Widget _buildServerPdfViewer(String pdfUrl) {
    print("📡 Loading PDF from server: $pdfUrl");

    return SfPdfViewer.network(
      pdfUrl,
      controller: _pdfViewerController,
      onDocumentLoaded: (PdfDocumentLoadedDetails details) {
        totalPages.value = details.document.pages.count;
        print("✅ PDF loaded: ${totalPages.value} pages");
      },
      onPageChanged: (PdfPageChangedDetails details) {
        currentPage.value = details.newPageNumber;
      },
      onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
        print("❌ PDF Load Failed: ${details.error}");
        print("❌ Description: ${details.description}");

        Get.snackbar(
          "PDF Load Error",
          "Failed to load PDF from server: ${details.description}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      },
    );
  }

  // ✅ Existing: Local PDF viewer
  Widget _buildLocalPdfViewer(String pdfPath) {
    print("📂 Loading PDF from local file: $pdfPath");

    return SfPdfViewer.file(
      File(pdfPath),
      controller: _pdfViewerController,
      onDocumentLoaded: (PdfDocumentLoadedDetails details) {
        totalPages.value = details.document.pages.count;
        print("✅ PDF loaded: ${totalPages.value} pages");
      },
      onPageChanged: (PdfPageChangedDetails details) {
        currentPage.value = details.newPageNumber;
      },
      onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
        print("❌ PDF Load Failed: ${details.error}");
        print("❌ Description: ${details.description}");

        Get.snackbar(
          "PDF Load Error",
          "Failed to load PDF from local storage: ${details.description}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      },
    );
  }

  // Dialog to jump to specific page
  void _showPageJumpDialog() {
    final TextEditingController pageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Jump to Page"),
        content: TextField(
          controller: pageController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Enter page number (1-${totalPages.value})",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final page = int.tryParse(pageController.text);
              if (page != null && page > 0 && page <= totalPages.value) {
                _pdfViewerController.jumpToPage(page);
                Get.back();
              } else {
                Get.snackbar(
                  "Invalid Page",
                  "Please enter a valid page number",
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text("Go"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }
}