import 'package:flutter/material.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';

class SmartGroceryInput extends StatefulWidget {
  final List<String> allSuggestions;
  final List<String> initialItems;
  final Function(List<String>) onChanged;
  final String hintText;

  const SmartGroceryInput({
    Key? key,
    required this.allSuggestions,
    required this.onChanged,
    this.initialItems = const [],
    this.hintText = "Add or search grocery item...",
  }) : super(key: key);

  @override
  State<SmartGroceryInput> createState() => _SmartGroceryInputState();
}

class _SmartGroceryInputState extends State<SmartGroceryInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late List<String> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.initialItems);
  }

  void _addItem(String item) {
    if (item.isEmpty) return;
    if (!_selectedItems.contains(item)) {
      setState(() => _selectedItems.add(item));
      widget.onChanged(_selectedItems);
    }
    _controller.clear();
    _focusNode.requestFocus();
  }

  void _removeItem(String item) {
    setState(() => _selectedItems.remove(item));
    widget.onChanged(_selectedItems);
  }

  @override
  Widget build(BuildContext context) {


    final filtered = widget.allSuggestions
        .where((e) =>
    e.toLowerCase().contains(_controller.text.trim().toLowerCase()) &&
        !_selectedItems.contains(e))
        .take(8)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ✅ Chips Row
        if (_selectedItems.isNotEmpty)
          Wrap(
            spacing: ResponsiveHelper.spacing(6),
            runSpacing: ResponsiveHelper.spacing(6),
            children: _selectedItems
                .map((item) => Chip(
              label: Text(
                item,
                style: TextStyle(
                  fontSize: ResponsiveHelper.fontSize(13),
                ),
              ),
              backgroundColor: AppColors.lightBlueBackground,
              onDeleted: () => _removeItem(item),
            ))
                .toList(),
          ),

        SizedBox(height: ResponsiveHelper.spacing(8)),

        /// ✅ Input Field
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          style: TextStyle(fontSize: ResponsiveHelper.fontSize(14)),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(fontSize: ResponsiveHelper.fontSize(14)),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.add,
                size: ResponsiveHelper.iconSize(22),
              ),
              onPressed: () => _addItem(_controller.text.trim()),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(8),
              ),
              borderSide: const BorderSide(color: AppColors.mediumGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(8),
              ),
              borderSide: const BorderSide(color: AppColors.blue),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.padding(12),
              vertical: ResponsiveHelper.spacing(10),
            ),
          ),
          onSubmitted: (v) => _addItem(v.trim()),
          onChanged: (_) => setState(() {}),
        ),

        /// ✅ Suggestions List
        if (_controller.text.isNotEmpty && filtered.isNotEmpty) ...[
          SizedBox(height: ResponsiveHelper.spacing(4)),
          Container(
            constraints: BoxConstraints(
              maxHeight: ResponsiveHelper.height(300),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.borderRadius(8),
              ),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filtered.length,
              itemBuilder: (_, index) {
                final suggestion = filtered[index];
                return ListTile(
                  title: Text(
                    suggestion,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(14),
                    ),
                  ),
                  onTap: () => _addItem(suggestion),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}