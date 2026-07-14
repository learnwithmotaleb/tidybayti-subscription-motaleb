import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tidybayte/app/controller/owner_controller/download_controller/download_controller.dart';
import 'package:tidybayte/app/data/model/owner_model/work_schedule/user_task_model.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';

class WorkScheduleDownloadScreen extends StatefulWidget {
  const WorkScheduleDownloadScreen({super.key});

  @override
  State<WorkScheduleDownloadScreen> createState() =>
      _WorkScheduleDownloadScreenState();
}

class _WorkScheduleDownloadScreenState
    extends State<WorkScheduleDownloadScreen> {
  final DownloadController downloadController = Get.find<DownloadController>();

  @override
  void initState() {
    super.initState();
    downloadController.getUserTask(dayName: "All"); // ✅ Fetch work schedule
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: Text(AppStrings.workSchedulePdf.tr)),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PdfPreview(
                build: (format) => generatePDF(), // ✅ Generate the PDF
              ),
            ),
          ],
        ),
      ),
    );
  }

  final PdfColor containerColor = PdfColor.fromInt(0xffB5D8EE); // ✅ Light Blue
  final PdfColor cardColor = PdfColor.fromInt(0xffF5F5F5); // ✅ Light Gray
  final PdfColor headerColor = PdfColor.fromInt(0xff4A90E2); // ✅ Blue Header

  /// ✅ Generates the PDF File with Improved Card Design
  Future<Uint8List> generatePDF() async {
    final pdf = pw.Document();

    /// ✅ Fetch the latest task data from the controller
    Data userTaskData = downloadController.userTaskData.value;

    if (userTaskData.result == null || userTaskData.result!.isEmpty) {
      return pdf.save(); // ✅ Return empty PDF if no tasks are available
    }

    final PdfPageFormat pageFormat = PdfPageFormat.a4;

    /// ✅ Function to build each task card
    pw.Widget buildTaskCard(Result task) {
      return pw.Container(
        padding: pw.EdgeInsets.all(12.r),
        margin: pw.EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
        decoration: pw.BoxDecoration(
          color: cardColor,
          borderRadius: pw.BorderRadius.circular(10.r),
          border: pw.Border.all(color: PdfColors.grey400, width: 1),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            /// ✅ Task Title
            pw.Container(
              padding: pw.EdgeInsets.all(8.r),
              decoration: pw.BoxDecoration(
                color: headerColor,
                borderRadius: pw.BorderRadius.circular(8.r),
              ),
              child: pw.Text(
                task.taskName ?? AppStrings.noTaskName.tr,
                style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white),
              ),
            ),
            pw.SizedBox(height: 8.h),

            /// ✅ Assigned To
            pw.Text(
              "${AppStrings.assignedTo.tr}: ${task.assignedTo?.firstName ?? "N/A"} ${task.assignedTo?.lastName ?? ""}",
              style: pw.TextStyle(
                  fontSize: 14.sp,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black),
            ),
            pw.SizedBox(height: 4),

            /// ✅ Task Details
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                        " ${AppStrings.startTime.tr}: ${task.startTimeStr ?? "N/A"}",
                        style: pw.TextStyle(fontSize: 12.sp)),
                    pw.Text(
                        "${AppStrings.endTime.tr}: ${task.endTimeStr ?? "N/A"}",
                        style: pw.TextStyle(fontSize: 12.sp)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("${AppStrings.room.tr}: ${task.room ?? "N/A"}",
                        style: pw.TextStyle(fontSize: 12.sp)),
                    pw.Text("${AppStrings.status.tr}: ${task.status ?? "N/A"}",
                        style: pw.TextStyle(fontSize: 12.sp)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 8.h),
          ],
        ),
      );
    }

    /// ✅ Generate all task cards
    List<pw.Widget> taskCards =
        userTaskData.result!.map((task) => buildTaskCard(task)).toList();

    /// ✅ Add Pages with Task Cards
    pdf.addPage(
      pw.MultiPage(
        pageFormat: pageFormat,
        build: (pw.Context context) => taskCards,
      ),
    );

    return pdf.save();
  }
}
