import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/auth/auth_service.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/screens/employee/main_screen.dart';
import 'package:frontend/src/ui/screens/employer/main_screen.dart';
import 'package:frontend/src/ui/screens/forgot_password.dart';
import 'package:frontend/src/ui/screens/signup.dart';
import 'package:frontend/src/ui/widgets/inputField/auth_text_field.dart';
import 'package:frontend/src/ui/widgets/inputField/password.dart';
import 'package:frontend/src/ui/widgets/title/title.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  String errorMessage = '';

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signIn() async {
    try {
      await authService.value.signIn(
        email: emailController.text,
        password: passwordController.text,
      );

      final uid = FirebaseAuth.instance.currentUser!.uid;

      final employeeDoc =
          await FirebaseFirestore.instance
              .collection('Employee')
              .doc(uid)
              .get();

      String role = '';
      if (employeeDoc.exists) {
        role = 'employee';
      } else {
        final employerDoc =
            await FirebaseFirestore.instance
                .collection('Employer')
                .doc(uid)
                .get();

        if (employerDoc.exists) {
          role = 'employer';
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  role == 'employee'
                      ? const EmployeeMainScreen()
                      : const EmployerMainScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = 'Account not exist';
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                SizedBox(height: 40),
                CustomTitle(title: 'Log In', isCenterTitle: false),
                SizedBox(height: 40),
                AuthTextField(
                  textController: emailController,
                  regex: emailPattern,
                  hintText: 'Email',
                  icon: Icons.email_outlined,
                  specifiedErrorMessage: 'Invalid email format',
                ),
                PasswordTextField(passwordController: passwordController),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FrogotPasswordScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.white,
                    ),
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.9,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      signIn();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 14, letterSpacing: 0.7),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.yellow,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
