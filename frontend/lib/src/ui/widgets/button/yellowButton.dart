import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';

class YellowButton extends StatelessWidget {
  final String text;
  const YellowButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yellow,
          padding: EdgeInsets.symmetric(vertical: 11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
