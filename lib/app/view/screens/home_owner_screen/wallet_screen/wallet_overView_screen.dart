import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tidybayte/app/controller/owner_controller/wallet_controller/wallet_controller.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';

class WalletOverviewScreen extends StatefulWidget {
  const WalletOverviewScreen({super.key});

  @override
  State<WalletOverviewScreen> createState() => _WalletOverviewState();
}

class _WalletOverviewState extends State<WalletOverviewScreen> {
  DateTime dateTime = DateTime.now();
  final WalletController controller = Get.find<WalletController>();

  @override
  void initState() {
    super.initState();
    _fetchDataForSelectedDate();
  }

  void _fetchDataForSelectedDate() {
    String selectedMonth = intl.DateFormat('MMMM').format(dateTime);
    String selectedYear = intl.DateFormat('yyyy').format(dateTime);
    controller.getOverView(month: selectedMonth, year: selectedYear);
  }

  Future<void> selectYearMonth(BuildContext context) async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: AlertDialog(
            title: Text(AppStrings.selectYearAndMonth.tr),
            content: SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.monthYear,
                initialDateTime: dateTime,
                minimumYear: 2023,
                maximumYear: 2101,
                onDateTimeChanged: (DateTime newDateTime) {
                  dateTime = newDateTime;
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppStrings.cancel.tr),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(dateTime);
                },
                child: Text(AppStrings.ok.tr),
              ),
            ],
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        dateTime = picked;
      });
      _fetchDataForSelectedDate();
    }
  }

  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.spacing(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () => selectYearMonth(context),
              icon: Container(
                padding: EdgeInsets.all(ResponsiveHelper.padding(10)),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: ResponsiveHelper.borderWidth(2),
                  ),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.borderRadius(8),
                  ),
                ),
                child: CustomText(
                  color: AppColors.dark500,
                  text: intl.DateFormat('MMMM yyyy').format(dateTime),
                  fontSize: ResponsiveHelper.fontSize(14),
                ),
              ),
            ),
            SizedBox(height: ResponsiveHelper.spacing(20)),
      
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.padding(20),
              ),
              child: Obx(() {
                final overviewData = controller.overViewData.value;
      
                if (overviewData.result == null ||
                    overviewData.result!.isEmpty) {
                  return Center(
                    child: Text(
                      "No data available",
                      style: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(14),
                      ),
                    ),
                  );
                }
      
                final List<ChartDataCombined> combinedData =
                overviewData.result!.map((item) {
                  return ChartDataCombined(
                    category: item.category ?? 'Unknown',
                    budget: item.amount?.toDouble() ?? 0.0,
                    expense: item.currentExpense?.toDouble() ?? 0.0,
                  );
                }).toList();
      
                debugPrint(
                    'Combined Chart Data: ${combinedData.map((e) => '${e.category}: Budget=${e.budget}, Expense=${e.expense}').toList()}');
      
                return Column(
                  children: [
                    SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        labelRotation: 45,
                        majorGridLines: const MajorGridLines(width: 0),
                        labelPlacement: LabelPlacement.betweenTicks,
                        labelStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(11),
                        ),
                      ),
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: true,
                        enablePinching: true,
                      ),
                      primaryYAxis: NumericAxis(
                        minimum: 0,
                        maximum: (combinedData.isNotEmpty)
                            ? combinedData
                            .map((e) => e.budget)
                            .reduce((a, b) => a > b ? a : b) +
                            100
                            : 1000,
                        interval: 50,
                        labelStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(11),
                        ),
                      ),
                      series: <CartesianSeries<ChartDataCombined, String>>[
                        ColumnSeries<ChartDataCombined, String>(
                          dataSource: combinedData,
                          xValueMapper: (ChartDataCombined data, _) =>
                          data.category,
                          yValueMapper: (ChartDataCombined data, _) => data.budget,
                          name: 'Budget',
                          color: AppColors.employeeCardColor,
                          width: 0.5,
                          spacing: 0.15,
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            labelAlignment: ChartDataLabelAlignment.top,
                            textStyle: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(12),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ColumnSeries<ChartDataCombined, String>(
                          dataSource: combinedData,
                          xValueMapper: (ChartDataCombined data, _) =>
                          data.category,
                          yValueMapper: (ChartDataCombined data, _) =>
                          data.expense,
                          name: 'Expense',
                          color: AppColors.bhdColor,
                          width: 0.5,
                          spacing: 0.15,
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            labelAlignment: ChartDataLabelAlignment.top,
                            textStyle: TextStyle(
                              fontSize: ResponsiveHelper.fontSize(12),
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // SfCartesianChart এর পরে এটা add করো
                    SizedBox(height: ResponsiveHelper.spacing(16)),
      
      // Legend Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Total Budget Circle
                        Container(
                          width: ResponsiveHelper.iconSize(14),
                          height: ResponsiveHelper.iconSize(14),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.spacing(6)),
                        Text(
                          "Total Budget",
                          style: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(13),
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.spacing(24)),
                        // Expense Circle
                        Container(
                          width: ResponsiveHelper.iconSize(14),
                          height: ResponsiveHelper.iconSize(14),
                          decoration: const BoxDecoration(
                            color: Color(0xFF726758),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.spacing(6)),
                        Text(
                          "Expense",
                          style: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(13),
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartDataCombined {
  final String category;
  final double budget;
  final double expense;

  ChartDataCombined({
    required this.category,
    required this.budget,
    required this.expense,
  });
}