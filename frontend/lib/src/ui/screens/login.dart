import 'package:flutter/material.dart';
import 'package:frontend/src/provider/role.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/screens/employee/main_screen.dart';
import 'package:frontend/src/ui/screens/forgot_password.dart';
import 'package:frontend/src/ui/screens/employer/main_screen.dart';
import 'package:frontend/src/ui/screens/signup.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/textfield/auth_text_field.dart';
import 'package:frontend/src/ui/widgets/textfield/password.dart';
import 'package:frontend/src/ui/widgets/title/title.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<RoleProvider>(context).role;

    if (role == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: role.isEmployee ? 'Employee' : 'Employer',
        isCenterTitle: true,
      ),
      body: SingleChildScrollView(
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
                        builder:
                            (context) =>
                                FrogotPasswordScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(foregroundColor: AppColors.white),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                role.isEmployee
                                    ? EmployeeMainScreen()
                                    : EmployerMainScreen(),
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
                          builder:
                              (context) => SignUpScreen(),
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
    );
  }
}
