import 'package:flutter/material.dart';
import 'package:frontend/src/class/role.dart';
import 'package:frontend/src/provider/role.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/screens/login.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            Spacer(),
            TextButton(
              onPressed: () {
                Provider.of<RoleProvider>(
                    context,
                    listen: false,
                  ).setRole(Role(isEmployee: true));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: Text(
                'Employee',
                style: TextStyle(
                  fontSize: 30,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 50),
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.white,
            ),
            SizedBox(height: 50),
            TextButton(
              onPressed: () {
                Provider.of<RoleProvider>(
                    context,
                    listen: false,
                  ).setRole(Role(isEmployee: false));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: Text(
                'Employer',
                style: TextStyle(
                  fontSize: 30,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
