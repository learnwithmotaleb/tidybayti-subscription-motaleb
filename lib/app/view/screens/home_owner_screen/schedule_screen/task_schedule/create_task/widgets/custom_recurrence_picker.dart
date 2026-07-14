import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_colors/app_colors.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/view/components/custom_text/custom_text.dart';
import '../models/recurrence_data.dart';

class OverlaySnackBar extends StatefulWidget {
  final String message;
  final Duration duration;

  const OverlaySnackBar({
    super.key,
    required this.message,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<OverlaySnackBar> createState() => _OverlaySnackBarState();
}

class _OverlaySnackBarState extends State<OverlaySnackBar> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOverlay();
    });
  }

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) {

        return Positioned(
          bottom: ResponsiveHelper.height(50),  // ✅ was: 50.h
          left: ResponsiveHelper.width(20),     // ✅ was: 20.w
          right: ResponsiveHelper.width(20),    // ✅ was: 20.w
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: ResponsiveHelper.symmetric(
                vertical: 12,
                horizontal: 20,
              ), // ✅ was: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w)
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.borderRadius(8), // ✅ was: 8.r
                ),
              ),
              child: Text(
                widget.message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.fontSize(16), // ✅ was: 16.sp
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    Timer(widget.duration, () {
      _removeOverlay();
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class CustomRecurrencePicker extends StatefulWidget {
  const CustomRecurrencePicker({super.key});

  @override
  State<CustomRecurrencePicker> createState() => _CustomRecurrencePickerState();
}

class _CustomRecurrencePickerState extends State<CustomRecurrencePicker> {
  int selectedNumber = 1;
  String selectedUnit = "Days";
  int maxCount = 30;
  List<String> selectedDays = ['1st'];
  List<String> selectedWeekDays = [];
  List<String> selectedMonths = [];
  String _displayString = " ";
  String _errorMessage = "";

  Map<String, String> get units => {
    "Days": AppStrings.days.tr,
    "Weeks": AppStrings.weeks.tr,
    "Months": AppStrings.months.tr,
    "Years": AppStrings.years.tr,
  };

  final List<String> weekDays = [
    "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
  ];
  final List<String> monthNames = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];
  final List<String> weekValues = ["1st", "2nd", "3rd", "4th", "Last"];

  @override
  void initState() {
    super.initState();
    _updateDisplayString();
  }

  void _updateDisplayString() {
    final data = RecurrenceData(
      number: selectedNumber,
      unit: selectedUnit,
      days: selectedDays,
      weekDays: selectedWeekDays,
      months: selectedMonths,
    );
    setState(() {
      _displayString = data.toString();
    });
  }

  void _validateAndSet() {
    setState(() {
      _errorMessage = "";
    });

    if (selectedUnit == "Weeks" && selectedWeekDays.isEmpty) {
      setState(() {
        _errorMessage = AppStrings.pleaseSelectWeekDay.tr;
      });
      return;
    }

    if ((selectedUnit == "Months" || selectedUnit == "Years") &&
        (selectedDays.isEmpty || selectedWeekDays.isEmpty)) {
      setState(() {
        _errorMessage = AppStrings.pleaseSelectSpecificDay.tr;
      });
      return;
    }

    if (selectedUnit == "Years" && selectedMonths.isEmpty) {
      setState(() {
        _errorMessage = AppStrings.pleaseSelectMonth.tr;
      });
      return;
    }

    final recurrenceData = RecurrenceData(
      number: selectedNumber,
      unit: selectedUnit,
      days: selectedDays,
      weekDays: selectedWeekDays,
      months: selectedMonths,
    );
    Navigator.pop(context, recurrenceData);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context); // ✅

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(12), // ✅ was: 12.r
              ),
            ),
            title: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.selectRecurrence.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveHelper.fontSize(16), // ✅ was: 16.sp
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: _validateAndSet,
                        child: Text(
                          AppStrings.sets.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveHelper.fontSize(16), // ✅ was: 16.sp
                            color: AppColors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _displayString,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.fontSize(16), // ✅ was: 16.sp
                    ),
                  ),
                  const Divider(color: Colors.black),
                ],
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      /// Number Picker
                      SizedBox(
                        height: ResponsiveHelper.height(250), // ✅ was: 250.h
                        width: ResponsiveHelper.width(80),    // ✅ was: 80.w
                        child: ListView.builder(
                          itemCount: maxCount,
                          itemBuilder: (context, index) {
                            int value = index + 1;
                            bool isSelected = selectedNumber == value;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedNumber = value;
                                  _updateDisplayString();
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: ResponsiveHelper.spacing(4), // ✅ was: 4.h
                                ),
                                padding: ResponsiveHelper.symmetric(
                                  vertical: 12,
                                  horizontal: 25,
                                ), // ✅ was: EdgeInsets.symmetric(vertical: 12.h, horizontal: 25.w)
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.addedColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveHelper.borderRadius(10), // ✅ was: 10.r
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "$value",
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.spacing(16)), // ✅ was: 16.w

                      /// Unit Picker
                      SizedBox(
                        height: ResponsiveHelper.height(250), // ✅ was: 250.h
                        width: ResponsiveHelper.width(120),   // ✅ was: 120.w
                        child: ListView(
                          children: units.entries.map((entry) {
                            String unitKey = entry.key;
                            String translatedUnit = entry.value;
                            bool isSelected = selectedUnit == unitKey;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedUnit = unitKey;
                                  selectedDays.clear();
                                  selectedWeekDays.clear();
                                  selectedMonths.clear();
                                  if (unitKey == "Days") {
                                    maxCount = 30;
                                  } else if (unitKey == "Weeks") {
                                    maxCount = 7;
                                  } else if (unitKey == "Months") {
                                    maxCount = 12;
                                  } else if (unitKey == "Years") {
                                    maxCount = 7;
                                  }
                                  selectedNumber = 1;
                                  _updateDisplayString();
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: ResponsiveHelper.spacing(4), // ✅ was: 4.h
                                ),
                                padding: ResponsiveHelper.symmetric(
                                  vertical: 12,
                                  horizontal: 25,
                                ), // ✅ was: EdgeInsets.symmetric(vertical: 12.h, horizontal: 25.w)
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.addedColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveHelper.borderRadius(10), // ✅ was: 10.r
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    translatedUnit,
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.spacing(16)), // ✅ was: 16.h

                  /// Weeks Section
                  if (selectedUnit == "Weeks") ...[
                    const Divider(),
                    Text(AppStrings.selectDays.tr,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: ResponsiveHelper.spacing(8)), // ✅ was: 8.h
                    Wrap(
                      spacing: 8,
                      children: weekDays.map((day) {
                        final isSelected = selectedWeekDays.contains(day);
                        return ChoiceChip(
                          backgroundColor: Colors.white,
                          label: Text(day),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              isSelected
                                  ? selectedWeekDays.remove(day)
                                  : selectedWeekDays.add(day);
                              _updateDisplayString();
                            });
                          },
                          selectedColor: AppColors.addedColor,
                        );
                      }).toList(),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)), // ✅ was: 16.h
                  ],

                  /// Years Section
                  if (selectedUnit == "Years") ...[
                    const Divider(),
                    Text(AppStrings.selectMonths.tr,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: ResponsiveHelper.spacing(8)), // ✅ was: 8.h
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: monthNames.map((month) {
                        final isSelected = selectedMonths.contains(month);
                        return ChoiceChip(
                          backgroundColor: Colors.white,
                          label: Text(month),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              isSelected
                                  ? selectedMonths.remove(month)
                                  : selectedMonths.add(month);
                              _updateDisplayString();
                            });
                          },
                          selectedColor: AppColors.addedColor,
                        );
                      }).toList(),
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(16)), // ✅ was: 16.h
                  ],

                  /// Months / Years Specific Days Section
                  if (selectedUnit == "Months" || selectedUnit == "Years") ...[
                    const Divider(color: Colors.black),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          color: AppColors.black,
                          text: AppStrings.specificDays.tr,
                          fontSize: ResponsiveHelper.fontSize(16), // ✅ was: 16.sp
                          fontWeight: FontWeight.bold,
                        ),
                        Row(
                          children: [
                            /// Week Values Picker
                            SizedBox(
                              height: ResponsiveHelper.height(200), // ✅ was: 200.h
                              width: ResponsiveHelper.width(120),   // ✅ was: 120.w
                              child: ListView(
                                scrollDirection: Axis.vertical,
                                children: weekValues.map((value) {
                                  bool isSelected =
                                  selectedDays.contains(value);
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedDays.contains(value)
                                            ? selectedDays.remove(value)
                                            : selectedDays.add(value);
                                        _updateDisplayString();
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: ResponsiveHelper.spacing(4), // ✅ was: 4.h
                                      ),
                                      padding: ResponsiveHelper.symmetric(
                                        vertical: 12,
                                        horizontal: 25,
                                      ), // ✅ was: EdgeInsets.symmetric(vertical: 12.h, horizontal: 25.w)
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.addedColor
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveHelper.borderRadius(10), // ✅ was: 10.r
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(width: ResponsiveHelper.spacing(16)), // ✅ was: 16.w

                            /// Week Days Picker
                            SizedBox(
                              height: ResponsiveHelper.height(200), // ✅ was: 200.h
                              width: ResponsiveHelper.width(120),   // ✅ was: 120.w
                              child: ListView(
                                scrollDirection: Axis.vertical,
                                children: weekDays.map((day) {
                                  bool isSelected =
                                  selectedWeekDays.contains(day);
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedWeekDays.contains(day)
                                            ? selectedWeekDays.remove(day)
                                            : selectedWeekDays.add(day);
                                        _updateDisplayString();
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: ResponsiveHelper.spacing(4), // ✅ was: 4.h
                                      ),
                                      padding: ResponsiveHelper.symmetric(
                                        vertical: 12,
                                        horizontal: 25,
                                      ), // ✅ was: EdgeInsets.symmetric(vertical: 12.h, horizontal: 25.w)
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.addedColor
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveHelper.borderRadius(10), // ✅ was: 10.r
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          day,
                                          style: TextStyle(
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_errorMessage.isNotEmpty) OverlaySnackBar(message: _errorMessage),
        ],
      ),
    );
  }
}