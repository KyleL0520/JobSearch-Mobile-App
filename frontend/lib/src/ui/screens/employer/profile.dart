import 'package:flutter/material.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';

class EmployerProfileScreen extends StatelessWidget {
  const EmployerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Profile', isCenterTitle: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [const SizedBox(height: 20)]),
      ),
    );
  }
}
