import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';

class RadioOptionGroup extends StatefulWidget {
  final List<String> options;
  final String? initialValue;
  final bool viewArrow;

  const RadioOptionGroup({
    super.key,
    required this.options,
    this.initialValue,
    this.viewArrow = false,
  });

  @override
  State<RadioOptionGroup> createState() => _RadioOptionGroupState();
}

class _RadioOptionGroupState extends State<RadioOptionGroup> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue ?? widget.options.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.options.map((option) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity(vertical: -4),
          leading: Radio<String>(
            value: option,
            groupValue: selectedValue,
            activeColor: AppColors.yellow,
            onChanged: (String? value) {
              setState(() {
                selectedValue = value;
              });
            },
          ),
          title: Text(
            option,
            style: TextStyle(color: AppColors.white, fontSize: 14),
          ),
          trailing: widget.viewArrow
              ? Icon(Icons.arrow_forward_ios,
                  color: AppColors.white, size: 19)
              : null,
        );
      }).toList(),
    );
  }
}
