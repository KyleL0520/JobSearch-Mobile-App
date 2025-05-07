import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/auth/auth_service.dart';
import 'package:frontend/database/database_service.dart';
import 'package:frontend/src/ui/screens/edit_password.dart';
import 'package:frontend/src/ui/screens/employer/edit_profile.dart';
import 'package:frontend/src/ui/screens/employer/application_accepted.dart';
import 'package:frontend/src/ui/screens/login.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/button/section.dart';

class EmployerProfileScreen extends StatefulWidget {
  const EmployerProfileScreen({super.key});

  @override
  State<EmployerProfileScreen> createState() => _EmployerProfileScreenState();
}

class _EmployerProfileScreenState extends State<EmployerProfileScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final db = DatabaseService();

  String _displayName = 'Profile';
  String _avatar = 'assets/images/userAvatar.png';

  Future<String?> getAvatar(String uid) async {
    final snapshot = await db.read(collectionPath: 'Employer', docId: uid);

    if (snapshot != null && snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return data['avatar'] as String?;
    }

    return null;
  }

  Future<void> _refreshProfile() async {
    final avatar = await getAvatar(uid);
    await FirebaseAuth.instance.currentUser?.reload();
    final displayName = authService.value.currentUser!.displayName ?? 'Profile';

    if (!mounted) return;

    setState(() {
      _avatar = avatar ?? 'assets/images/userAvatar.png';
      _displayName = displayName;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: _displayName, isCenterTitle: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ClipOval(
              child:
                  _avatar.startsWith('assets/')
                      ? Image.asset(
                        _avatar,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                      : Image.file(
                        File(_avatar),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
            ),
            const SizedBox(height: 50),
            SectionButton(
              icon: Icons.edit,
              title: 'Edit Profile',
              action: EditProfileScreen(),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
                await _refreshProfile();
              },
            ),
            const SizedBox(height: 20),
            SectionButton(
              icon: Icons.lock_outline,
              title: 'Edit Password',
              action: EditPasswordScreen(uid: uid),
            ),
            const SizedBox(height: 20),
            SectionButton(
              icon: Icons.edit_document,
              title: 'Application Accepted',
              action: ApplicationAcceptedScreen(),
            ),
            const SizedBox(height: 20),
            SectionButton(
              icon: Icons.logout_outlined,
              title: 'Logout',
              action: LoginScreen(),
              onTap: () async {
                await authService.value.signOut();
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
