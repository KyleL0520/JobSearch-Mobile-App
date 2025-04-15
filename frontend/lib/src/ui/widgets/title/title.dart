import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';

class CustomTitle extends StatelessWidget {
  final String title;
  final bool isCenterTitle;
  const CustomTitle({
    super.key,
    required this.title,
    required this.isCenterTitle,
  });

  @override
  Widget build(BuildContext context) {
    return isCenterTitle
        ? Text(
          title,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
        : Text(
          title,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        );
  }
}
