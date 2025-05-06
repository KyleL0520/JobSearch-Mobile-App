import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/auth/auth_service.dart';
import 'package:frontend/src/ui/screens/employee/main_screen.dart';
import 'package:frontend/src/ui/screens/employer/main_screen.dart';
import 'package:frontend/src/ui/screens/login.dart';
import 'package:frontend/src/ui/screens/verify_email.dart';
import 'package:frontend/src/ui/widgets/app_loading.dart';

class AuthLayout extends StatelessWidget {
  AuthLayout({super.key});
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> _getCurrentUserRole(String uid) async {
    final DocumentSnapshot employeeDoc =
        await _firestore.collection('Employee').doc(uid).get();

    if (employeeDoc.exists) {
      return 'employee';
    }
    return 'employer';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder<User?>(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AppLoading();
            }

            final user = snapshot.data;

            if (user != null) {
              if (!user.emailVerified) {
                return const VerifyEmailScreen();
              }

              return FutureBuilder<String?>(
                future: _getCurrentUserRole(user.uid),
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
