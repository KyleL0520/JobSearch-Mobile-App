import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/auth/auth_service.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/screens/login.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/inputField/auth_text_field.dart';
import 'package:frontend/src/ui/widgets/title/title.dart';

class FrogotPasswordScreen extends StatefulWidget {
  const FrogotPasswordScreen({super.key});

  @override
  State<FrogotPasswordScreen> createState() => _FrogotPasswordScreenState();
}

class _FrogotPasswordScreenState extends State<FrogotPasswordScreen> {
  final emailController = TextEditingController();
  String errorMessage = '';
  final String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  void resetPassword() async {
    try {
      await authService.value.resetPassword(email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email send successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        errorMessage = '';
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = 'Email not exist';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppColors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', isCenterTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              CustomTitle(title: 'Forgot Password', isCenterTitle: false),
              SizedBox(height: 40),
              Text(
                'Enter your email address to receive a password reset link.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.7,
                  color: AppColors.grey,
                ),
              ),
              SizedBox(height: 30),
              AuthTextField(
                textController: emailController,
                regex: emailPattern,
                hintText: 'Email',
                icon: Icons.email_outlined,
                specifiedErrorMessage: 'Invalid email format',
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
