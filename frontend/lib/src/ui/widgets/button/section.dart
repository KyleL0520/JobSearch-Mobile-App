import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';

class SectionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget action;
  const SectionButton({
    super.key,
    required this.icon,
    required this.title,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => action),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: title == 'Logout' ? AppColors.red : AppColors.white,
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: TextStyle(
                  color: title == 'Logout' ? AppColors.red : AppColors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios, color: AppColors.grey),
        ],
      ),
    );
  }
}
