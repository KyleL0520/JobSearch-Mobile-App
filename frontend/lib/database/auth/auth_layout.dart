import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/auth/auth_service.dart';
import 'package:frontend/src/ui/screens/employee/main_screen.dart';
import 'package:frontend/src/ui/screens/employer/main_screen.dart';
import 'package:frontend/src/ui/screens/login.dart';
import 'package:frontend/src/ui/widgets/app_loading.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key});

  Future<String?> _getUserRole() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userDoc =
          await FirebaseFirestore.instance.collection('User').doc(uid).get();

      return userDoc['role'] as String?;
    } catch (e) {
      debugPrint('Error fetching user role: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading();
            }

            if (snapshot.hasData) {
              return FutureBuilder<String?>(
                future: _getUserRole(),
                builder: (context, roleSnapshot) {
                  if (roleSnapshot.connectionState == ConnectionState.waiting) {
                    return const AppLoading();
                  }

                  if (roleSnapshot.hasData && roleSnapshot.data != null) {
                    final role = roleSnapshot.data!;
                    return role == 'employee'
                        ? const EmployeeMainScreen()
                        : const EmployerMainScreen();
                  }

                  return LoginScreen();
                },
              );
            }

            return LoginScreen();
          },
        );
      },
    );
  }
}
