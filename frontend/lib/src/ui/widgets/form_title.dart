import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';

class CustomFormTitle extends StatelessWidget {
  final String title;
  const CustomFormTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.white,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
