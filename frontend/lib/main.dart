import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/auth/auth_layout.dart';
import 'package:frontend/firebase_options.dart';
import 'package:frontend/src/config/route/app_routes.dart';
import 'package:frontend/src/styles/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: AppColors.blue,
        brightness: Brightness.dark,
      ),
      home: AuthLayout(),
      routes: AppRoutes.routes,
    );
  }
}
