import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/auth/auth_service.dart';
import 'package:frontend/src/styles/app_colors.dart';

class SectionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget action;
  final VoidCallback? onTap;
  const SectionButton({
    super.key,
    required this.icon,
    required this.title,
    required this.action,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    void logout() async {
      try {
        await authService.value.signOut();
      } on FirebaseAuthException catch (e) {
        print(e.message);
      }
    }

    return GestureDetector(
      onTap:
          onTap ??
          () {
            if (title == 'Logout') {
              logout();
            }
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
