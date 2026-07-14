// lib/components/dynamic_textfield/dynamic_text_field_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';

import '../../../utils/app_colors/app_colors.dart';
import '../custom_text/custom_text.dart';

import '../snackbar_helper/snackbar_helper.dart';

class DynamicTextFieldList extends StatefulWidget {
  final String fieldLabel;
  final bool isListData;
  final String titleHintText;
  final String descriptionHintText;
  final void Function(Map<String, String>) onDataChanged;
  final Map<String, String> initialValues; // Map type

  final int minFields;
  final String addAnotherLabel;

  final List<int> doubleHeightIndexes;

  const DynamicTextFieldList({
    super.key,
    required this.fieldLabel,
    this.initialValues = const {},
    this.minFields = 1,
    required this.addAnotherLabel,
    this.doubleHeightIndexes = const [],
    required this.titleHintText,
    required this.descriptionHintText,
    this.isListData = false,
    required this.onDataChanged,
  });

  @override
  State<DynamicTextFieldList> createState() => _DynamicTextFieldListState();
}

class _DynamicTextFieldListState extends State<DynamicTextFieldList> {
  late List<TextEditingController> titleControllers;
  late List<TextEditingController> descriptionControllers;
  late List<String> fieldKeys; // Store the keys separately to maintain order

  int counter = 0;

  @override
  void initState() {
    super.initState();

    titleControllers = [];
    descriptionControllers = [];
    fieldKeys = [];

    if (widget.initialValues.isNotEmpty) {
      widget.initialValues.forEach((key, value) {
        titleControllers.add(TextEditingController(text: key));
        descriptionControllers.add(TextEditingController(text: value));
        fieldKeys.add(key);
      });
    } else {
      for (int i = 0; i < widget.minFields; i++) {
        _addNewFieldControllers();
      }
    }
  }

  void _updateData() {
    Map<String, String> data = {};
    for (int i = 0; i < titleControllers.length; i++) {
      if (widget.isListData) {
        // For 'Preparation Steps' and similar single-field lists
        data['Step ${i + 1}'] = titleControllers[i].text;
      } else {
        // For 'Ingredients' and 'Nutrition Info'
        data[titleControllers[i].text] = descriptionControllers[i].text;
      }
    }
    widget.onDataChanged(data);
  }

  void _addNewFieldControllers() {
    counter++;
    String newKey = 'Field $counter';
    titleControllers.add(TextEditingController());
    descriptionControllers.add(TextEditingController());
    fieldKeys.add(newKey);
  }

  void _addField() {
    setState(() {
      _addNewFieldControllers();
    });
  }

  void _removeField(int index) {
    if (fieldKeys.length <= widget.minFields) {
      SnackbarHelper.show(
        message:
            '${AppStrings.keepAtLeast.tr} ${widget.minFields} ${widget.fieldLabel.toLowerCase()}${widget.minFields > 1 ? 's' : ''}.',
        backgroundColor: AppColors.primary,
        textColor: AppColors.white,
        isSuccess: false,
      );
      return;
    }

    setState(() {
      titleControllers[index].dispose();
      descriptionControllers[index].dispose();
      titleControllers.removeAt(index);
      descriptionControllers.removeAt(index);
      fieldKeys.removeAt(index);
    });
  }

  @override
  void dispose() {
    for (var controller in titleControllers) {
      controller.dispose();
    }

    for (var controller in descriptionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        ...List.generate(fieldKeys.length, (index) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side: Label + TextField (inside Column)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          textAlign: TextAlign.start,
                          text: fieldKeys.length > 1
                              ? '${widget.fieldLabel} ${index + 1}'
                              : widget.fieldLabel,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: AppColors.black,
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: titleControllers[index],
                          onChanged: (text) => _updateData(),
                          decoration: InputDecoration(
                            hintText: widget.titleHintText,
                            hintStyle: TextStyle(
                              color: AppColors.mediumGray,
                              fontSize: 12.sp,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.r),
                              borderSide:
                                  const BorderSide(color: AppColors.mediumGray),
                            ),
                          ),
                        ),
                        if (!widget.isListData) ...[
                          SizedBox(height: 8.h),
                          TextField(
                            controller: descriptionControllers[index],
                            onChanged: (text) => _updateData(),
                            decoration: InputDecoration(
                              hintText: widget.descriptionHintText,
                              hintStyle: TextStyle(
                                color: AppColors.mediumGray,
                                fontSize: 12.sp,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.r),
                                borderSide: const BorderSide(
                                    color: AppColors.mediumGray),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Right Side: Icons (Delete / Add)
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      if (fieldKeys.length > widget.minFields)
                        GestureDetector(
                          onTap: () => _removeField(index),
                          child: Padding(
                            padding: EdgeInsets.all(4.0.r),
                            child: Icon(
                              Icons.delete,
                              color: AppColors.black,
                              size: 24.r,
                            ),
                          ),
                        ),
                      if (index == fieldKeys.length - 1)
                        GestureDetector(
                          onTap: _addField,
                          child: Padding(
                            padding: EdgeInsets.all(4.0.r),
                            child: Container(
                              height: 30.h,
                              width: 30.w,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: AppColors.mediumGray),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 24.r,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              // Divider(color: AppColors.borderGray, height: 8.h, thickness: 1),

              // if (index < fieldKeys.length - 1)
              //   Divider(color: AppColors.borderGray, height: 8.h, thickness: 1),
            ],
          );
        }),
      ],
    );
  }
}
