import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';

class RadioOption extends StatefulWidget {
  final String title;
  final bool viewArrow;
  const RadioOption({super.key, required this.title, required this.viewArrow});

  @override
  State<RadioOption> createState() => _RadioOptionState();
}

class _RadioOptionState extends State<RadioOption> {
  @override
  Widget build(BuildContext context) {
    String? option;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity(vertical: -4),
      leading: Radio<String>(
        value: widget.title,
        groupValue: option,
        activeColor: AppColors.yellow,
        onChanged: (String? value) {
          setState(() {
            option = value;
          });
        },
      ),
      title: Text(
        widget.title,
        style: TextStyle(color: AppColors.white, fontSize: 14),
      ),
      trailing: widget.viewArrow ? Icon(Icons.arrow_forward_ios, color: AppColors.white, size: 19) : null,
    );
  }
}
