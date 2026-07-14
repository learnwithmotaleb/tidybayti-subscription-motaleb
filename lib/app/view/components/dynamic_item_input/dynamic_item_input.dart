import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DynamicItemInput extends StatefulWidget {
  final String hintText;
  final String submitButtonText;
  final Function(List<String>) onItemsChanged;
  final List<String>? initialItems;
  final Color? chipColor;
  final Color? chipTextColor;
  final Color? deleteIconColor;
  final Color? buttonColor;
  final Color? buttonTextColor;

  const DynamicItemInput({
    Key? key,
    this.hintText = "Add item",
    this.submitButtonText = "Add",
    required this.onItemsChanged,
    this.initialItems,
    this.chipColor,
    this.chipTextColor,
    this.deleteIconColor,
    this.buttonColor,
    this.buttonTextColor,
  }) : super(key: key);

  @override
  State<DynamicItemInput> createState() => _DynamicItemInputState();
}

class _DynamicItemInputState extends State<DynamicItemInput> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _items = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialItems != null) {
      _items = List.from(widget.initialItems!);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addItem() {
    final text = _textController.text.trim();
    if (text.isNotEmpty && !_items.contains(text)) {
      setState(() {
        _items.add(text);
        _textController.clear();
      });
      widget.onItemsChanged(_items);
      _focusNode.requestFocus(); // Keep focus on text field
    }
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
    widget.onItemsChanged(_items);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input Row
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    // borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                ),
                onSubmitted: (_) => _addItem(),
              ),
            ),
            SizedBox(width: 8.w),
            ElevatedButton(
              onPressed: _addItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.buttonColor ?? Colors.white,
                foregroundColor: widget.buttonTextColor ?? Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(widget.submitButtonText),
            ),
          ],
        ),

        // Items Display
        if (_items.isNotEmpty) ...[
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: widget.chipColor ?? Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item,
                      style: TextStyle(
                        color: widget.chipTextColor ?? Colors.black87,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () => _removeItem(index),
                      child: Icon(
                        Icons.close,
                        size: 16.r,
                        color: widget.deleteIconColor ?? Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
