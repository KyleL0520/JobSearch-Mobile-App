import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';

class CardWidget extends StatelessWidget {
  final String first;
  final String second;
  final String third;
  const CardWidget({
    super.key,
    required this.first,
    required this.second,
    required this.third,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 3, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColors.grey,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                first,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                second,
                style: TextStyle(fontSize: 13, color: AppColors.black),
              ),
              const SizedBox(height: 5),
              Text(
                third,
                style: TextStyle(fontSize: 12, color: AppColors.black),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
