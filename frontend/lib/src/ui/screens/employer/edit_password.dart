import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/textfield/text.dart';

class EditPasswordScreen extends StatelessWidget {
  const EditPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordContorller = TextEditingController();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Password',
        isCenterTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Save', style: TextStyle(color: AppColors.yellow)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/images/shopee.jpg', width: 80, height: 80),
            const SizedBox(height: 20),
            StringTextField(
              textController: passwordContorller,
              hintText: '********',
              title: 'New Password',
              specifiedErrorMessage: '',
            ),
            StringTextField(
              textController: passwordContorller,
              hintText: '********',
              title: 'Confirm password',
              specifiedErrorMessage: '',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
