import 'package:flutter/material.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Profile', isCenterTitle: false),
    );
  }
}