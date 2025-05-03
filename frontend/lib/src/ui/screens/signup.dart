import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/auth/auth_service.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/screens/login.dart';
import 'package:frontend/src/ui/widgets/inputField/auth_text_field.dart';
import 'package:frontend/src/ui/widgets/inputField/password.dart';
import 'package:frontend/src/ui/widgets/inputField/role_selection.dart';
import 'package:frontend/src/ui/widgets/title/title.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final locationController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = 'employee';

  final String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  final String phoneNumberPattern = r'^\+?[0-9]{7,15}$';
  final String passwordPattern =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,16}$';

  String errorMessage = '';

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    locationController.dispose();
    passwordController.dispose();
  }

  void register(BuildContext context) async {
    String name = usernameController.text.trim();
    String email = emailController.text.trim();
    String phoneNumber = phoneNumberController.text.trim();
    String location = locationController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phoneNumber.isEmpty ||
        location.isEmpty ||
        password.isEmpty ||
        !RegExp(emailPattern).hasMatch(email) ||
        !RegExp(phoneNumberPattern).hasMatch(phoneNumber) ||
        !RegExp(passwordPattern).hasMatch(password)) {
      return;
    }

    try {
      await authService.value.createAccount(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        location: location,
        password: password,
        role: selectedRole,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign up successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      await Future.delayed(Duration(seconds: 2));

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'There is an error in sign up page';
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
                CustomTitle(title: 'Sign Up', isCenterTitle: false),
                SizedBox(height: 40),
                AuthTextField(
                  textController: usernameController,
                  hintText: 'Name',
                  icon: Icons.person_outline_rounded,
                ),
                AuthTextField(
                  textController: emailController,
                  regex: emailPattern,
                  hintText: 'Email',
                  icon: Icons.email_outlined,
                  specifiedErrorMessage: 'Invalid email format',
                ),
                AuthTextField(
                  textController: phoneNumberController,
                  regex: phoneNumberPattern,
                  hintText: 'Phone Number',
                  icon: Icons.phone_outlined,
                  specifiedErrorMessage: 'Invalid phone number format',
                ),
                AuthTextField(
                  textController: locationController,
                  hintText: 'Location',
                  icon: Icons.location_on_outlined,
                ),
                RoleSelection(
                  onRoleChanged: (role) {
                    setState(() {
                      selectedRole = role;
                    });
                  },
                ),
                PasswordTextField(passwordController: passwordController),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () => register(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
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
                      "Already have an account?",
                      style: TextStyle(fontSize: 14, letterSpacing: 0.7),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Log In',
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
