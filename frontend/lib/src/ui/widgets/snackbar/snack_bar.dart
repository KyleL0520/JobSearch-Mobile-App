import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';

class CustomSnackBar {
  static SnackBar successSnackBar({required String title}) {
    return SnackBar(
      content: Text(title, style: TextStyle(fontSize: 17)),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    );
  }

  static SnackBar failedSnackBar({required String title}) {
    return SnackBar(
      content: Text(title, style: TextStyle(fontSize: 17)),
      backgroundColor: AppColors.red,
      duration: Duration(seconds: 3),
    );
  }
}
