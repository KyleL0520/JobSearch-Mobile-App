import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/screens/login.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/textfield/email.dart';
import 'package:frontend/src/ui/widgets/textfield/location.dart';
import 'package:frontend/src/ui/widgets/textfield/password.dart';
import 'package:frontend/src/ui/widgets/textfield/phone.dart';
import 'package:frontend/src/ui/widgets/title.dart';
import 'package:frontend/src/ui/widgets/textfield/username.dart';

class SignUpScreen extends StatelessWidget {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final locationController = TextEditingController();
  final passwordController = TextEditingController();
  final bool isEmployee;
  SignUpScreen({super.key, required this.isEmployee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: isEmployee ? 'Employee' : 'Employer',
        isCenterTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              CustomTitle(title: 'Sign Up', isCenterTitle: false),
              SizedBox(height: 40),
              UsernameTextField(usernameController: usernameController),
              SizedBox(height: 16),
              EmailTextField(emailController: emailController),
              SizedBox(height: 16),
              PhoneNumberTextField(
                phoneNumberController: phoneNumberController,
              ),
              SizedBox(height: 16),
              LocationTextField(locationController: locationController),
              SizedBox(height: 16),
              PasswordTextField(passwordController: passwordController),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => LoginScreen(isEmployee: isEmployee),
                      ),
                    );
                  },
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
                          builder:
                              (context) => LoginScreen(isEmployee: isEmployee),
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
    );
  }
}
