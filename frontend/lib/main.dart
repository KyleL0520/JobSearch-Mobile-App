import 'package:flutter/material.dart';
import 'package:frontend/src/config/route/app_routes.dart';
import 'package:frontend/src/provider/job.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => JobProvider(), child: MyApp()));
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
      initialRoute: AppRoutes.start,
      routes: AppRoutes.screens,
    );
  }
}
