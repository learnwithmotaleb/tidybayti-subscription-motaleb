import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import 'package:tidybayte/app/utils/app_strings/app_strings.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';

class SmartTaskInput extends StatefulWidget {
  final Future<List<Map<String, String>>> Function(String query) onSearch;
  final String? initialTitle;
  final String? initialRecurrence;
  final Function(String title, String recurrence, String rrule) onSelected;

  const SmartTaskInput({
    super.key,
    required this.onSearch,
    required this.onSelected,
    this.initialTitle,
    this.initialRecurrence,
  });

  @override
  State<SmartTaskInput> createState() => _SmartTaskInputState();
}

class _SmartTaskInputState extends State<SmartTaskInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  List<Map<String, String>> _results = [];
  bool _isLoading = false;
  String? _selectedRecurrence;
  String? _selectedRrule;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialTitle ?? '';
    _selectedRecurrence = widget.initialRecurrence;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    widget.onSelected(text, _selectedRecurrence ?? '', _selectedRrule ?? '');

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (text.trim().isEmpty) {
        setState(() => _results = []);
        return;
      }
      setState(() => _isLoading = true);
      final fetched = await widget.onSearch(text.trim());
      if (mounted) {
        setState(() {
          _results = fetched;
          _isLoading = false;
        });
      }
    });
  }

  void _selectTask(Map<String, String> item) {
    _controller.text = item['title'] ?? '';
    _selectedRecurrence = item['recurrence'] ?? '';
    _selectedRrule = item['rrule'] ?? '';
    _results.clear();
    widget.onSelected(
        _controller.text, _selectedRecurrence ?? '', _selectedRrule ?? '');
    setState(() {});
  }

  void _submitManual() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSelected(text, _selectedRecurrence ?? '', _selectedRrule ?? '');
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: AppStrings.searchOrEnterTaskName.tr,
            suffixIcon: _isLoading
                ? Padding(
              padding: ResponsiveHelper.all(12), // ✅ already using ResponsiveHelper
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
                : IconButton(
              icon: const Icon(Icons.check),
              onPressed: _submitManual,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(10), // ✅ was: 10.r
              ),
              borderSide: const BorderSide(color: AppColors.mediumGray),
            ),
            contentPadding: ResponsiveHelper.symmetric(
              horizontal: 12,
              vertical: 10,
            ), // ✅ already using ResponsiveHelper
          ),
          onChanged: _onChanged,
        ),
        if (_results.isNotEmpty)
          Container(
            constraints: BoxConstraints(
              maxHeight: ResponsiveHelper.height(400), // ✅ was: 400.h
            ),
            margin: EdgeInsets.only(
              top: ResponsiveHelper.spacing(6), // ✅ was: 6.h
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(8), // ✅ was: 8.r
              ),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _results.length,
              itemBuilder: (_, i) {
                final item = _results[i];
                return ListTile(
                  title: Text(item['title'] ?? ''),
                  subtitle: Text(
                    item['recurrence'] ?? '',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  onTap: () => _selectTask(item),
                );
              },
            ),
          ),
      ],
    );
  }
}