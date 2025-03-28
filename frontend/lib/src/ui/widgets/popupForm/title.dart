import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';

class CustomPopupFormTitle extends StatelessWidget {
  final String title;
  const CustomPopupFormTitle({super.key, required this.title});

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
