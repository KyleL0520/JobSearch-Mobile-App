import 'package:flutter/material.dart';
import 'package:frontend/src/ui/screens/employer/edit_password.dart';
import 'package:frontend/src/ui/screens/employer/edit_profile.dart';
import 'package:frontend/src/ui/screens/start.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/button/section.dart';

class EmployerProfileScreen extends StatelessWidget {
  const EmployerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Profile', isCenterTitle: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/images/shopee.jpg', width: 80, height: 80),
            const SizedBox(height: 50),
            SectionButton(
              icon: Icons.edit,
              title: 'Edit Profile',
              action: EditProfileScreen(),
            ),
            const SizedBox(height: 20),
            SectionButton(
              icon: Icons.lock_outline,
              title: 'Edit Password',
              action: EditPasswordScreen(),
            ),
            const SizedBox(height: 20),
            SectionButton(
              icon: Icons.logout_outlined,
              title: 'Logout',
              action: StartScreen(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
