import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/title/form_title.dart';

class DatePickerField extends StatefulWidget {
  final String title;
  final String hintText;
  final bool isRequired;
  final String? initialValue;
  final Function(String?) onChanged;

  const DatePickerField({
    super.key,
    required this.hintText,
    required this.title,
    required this.isRequired,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  String? _errorText;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      final parts = widget.initialValue!.split('/');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);
        if (day != null && month != null && year != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              selectedDate = DateTime(year, month, day);
            });
          });
        }
      }
    }
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext context) => Container(
            height: 216,
            padding: const EdgeInsets.only(top: 6.0),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: SafeArea(top: false, child: child),
          ),
    );
  }

  void _validateDate() {
    setState(() {
      if (selectedDate == null && widget.isRequired) {
        _errorText = '${widget.title} is required';
      } else {
        _errorText = null;
      }
    });
  }

  String? formatDateToDDMMYYYY(DateTime? date) {
    if (date == null) return null;
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    final displayText =
        selectedDate != null
            ? formatDateToDDMMYYYY(selectedDate)!
            : widget.hintText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomFormTitle(title: widget.title),
        const SizedBox(height: 10),
        _DatePickerItem(
          children: <Widget>[
            Expanded(
              child: CupertinoButton(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.transparent,
                  ),
                  child: Text(
                    displayText,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          selectedDate == null
                              ? AppColors.grey
                              : AppColors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                onPressed:
                    () => _showDialog(
                      CupertinoDatePicker(
                        initialDateTime: selectedDate ?? DateTime.now(),
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() {
                            selectedDate = newDate;
                            _validateDate();
                          });
                          widget.onChanged(formatDateToDDMMYYYY(selectedDate));
                        },
                      ),
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 20,
          child:
              _errorText != null
                  ? Text(
                    _errorText!,
                    style: TextStyle(
                      color: AppColors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _DatePickerItem extends StatelessWidget {
  const _DatePickerItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: CupertinoColors.inactiveGray, width: 0.0),
          bottom: BorderSide(color: CupertinoColors.inactiveGray, width: 0.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}
