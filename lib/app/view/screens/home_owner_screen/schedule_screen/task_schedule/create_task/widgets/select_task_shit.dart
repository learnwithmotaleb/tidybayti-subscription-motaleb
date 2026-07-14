import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../../utils/app_strings/app_strings.dart';
import 'package:tidybayte/app/global/helper/responsive_helper.dart';
import '../controller/task_preset_controller.dart';
import '../models/task_name_model.dart';
import 'smart_task_input.dart';

class SelectTaskShit extends StatefulWidget {
  final String initiallySelected;
  final String initialRecurrence;

  const SelectTaskShit({
    super.key,
    this.initiallySelected = '',
    this.initialRecurrence = '',
  });

  @override
  State<SelectTaskShit> createState() => _SelectTaskShitState();
}

class _SelectTaskShitState extends State<SelectTaskShit> {
  final TaskPresetController _controller = Get.find<TaskPresetController>();
  String _title = '';
  String _recurrence = '';
  String _rrule = '';

  Future<List<Map<String, String>>> _fetchSuggestions(String query) async {
    await _controller.getTaskPresets();

    final List<TaskNameData> generalTasks =
        _controller.taskPreset.value.data ?? [];

    final tasks = generalTasks.cast<dynamic>();

    return tasks
        .where((t) =>
    t.title != null &&
        t.title!.toLowerCase().contains(query.toLowerCase().trim()))
        .map((t) => <String, String>{
      'title': t.title?.toString() ?? '',
      'recurrence': t.recurrence?.toString() ?? '',
      'rrule': t.rrule?.toString() ?? '',
    })
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _title = widget.initiallySelected;
    _recurrence = widget.initialRecurrence;
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.9,
            minChildSize: 0.3,
            builder: (_, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                      ResponsiveHelper.borderRadius(20), // ✅ was: 20.r
                    ),
                  ),
                ),
                padding: ResponsiveHelper.all(20), // ✅ was: EdgeInsets.all(20.w)
                child: Column(
                  children: [
                    Container(
                      width: ResponsiveHelper.width(40),    // ✅ was: 40.w
                      height: ResponsiveHelper.height(5),   // ✅ was: 5.h
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.borderRadius(12), // ✅ was: 12.r
                        ),
                      ),
                      margin: EdgeInsets.only(
                        bottom: ResponsiveHelper.spacing(12), // ✅ was: 12.h
                      ),
                    ),
                    Text(
                      AppStrings.selectTask.tr,
                      style: theme.textTheme.titleLarge,
                    ),
                    SizedBox(height: ResponsiveHelper.spacing(12)), // ✅ was: 12.h
                    SmartTaskInput(
                      onSearch: _fetchSuggestions,
                      initialTitle: _title,
                      initialRecurrence: _recurrence,
                      onSelected: (t, r, rrule) {
                        setState(() {
                          _title = t;
                          _recurrence = r;
                          _rrule = rrule;
                        });
                        print('📝 Task selected: $_title');
                        print('🔁 Recurrence selected: $_recurrence');
                        print('⚙️ RRule selected: $_rrule');
                      },
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _title.trim().length >= 1
                          ? () {
                        print(
                            '✅ Submitting - Title: $_title, Recurrence: $_recurrence');
                        Get.back(result: {
                          'title': _title,
                          'recurrence': _recurrence,
                          'rrule': _rrule,
                        });
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.borderRadius(8), // ✅ was: 8.r
                          ),
                        ),
                        minimumSize: Size(
                          double.infinity,
                          ResponsiveHelper.height(48), // ✅ was: 48.h
                        ),
                      ),
                      child: Text(
                        AppStrings.submit.tr,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}