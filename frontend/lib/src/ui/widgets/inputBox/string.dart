import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/form_title.dart';

class StringBox extends StatelessWidget {
  final String title;
  final String labelText;
  final String errorMessage;
  const StringBox({super.key, required this.title, required this.labelText, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomFormTitle(title: title),
        TextFormField(
          decoration: InputDecoration(labelText: labelText),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return errorMessage;
            }
            return null;
          },
        )
        
      ],
    );
  }
}