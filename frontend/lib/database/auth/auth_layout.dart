import 'package:flutter/material.dart';
import 'package:frontend/database/auth/auth_service.dart';
import 'package:frontend/src/provider/role.dart';
import 'package:frontend/src/ui/screens/employee/main_screen.dart';
import 'package:frontend/src/ui/screens/employer/main_screen.dart';
import 'package:frontend/src/ui/screens/start.dart';
import 'package:frontend/src/ui/widgets/app_loading.dart';
import 'package:provider/provider.dart';

class AuthLayout extends StatelessWidget {
  final Widget? pageIfNotConnectd;

  const AuthLayout({super.key, this.pageIfNotConnectd});

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<RoleProvider>(context).role;

    if (role == null) {
      return Center(child: CircularProgressIndicator());
    }

    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            if (snapshot.connectionState == ConnectionState.waiting) {
              widget = const AppLoading();
            } else if (snapshot.hasData) {
              widget =
                  role.isEmployee
                      ? const EmployeeMainScreen()
                      : const EmployerMainScreen();
            } else {
              widget = pageIfNotConnectd ?? const StartScreen();
            }
            return widget;
          },
        );
      },
    );
  }
}
