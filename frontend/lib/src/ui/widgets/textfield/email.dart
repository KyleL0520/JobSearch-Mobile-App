import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';

class EmailTextField extends StatefulWidget {
  final TextEditingController emailController;

  const EmailTextField({super.key, required this.emailController});

  @override
  State<EmailTextField> createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends State<EmailTextField> {
  String? _errorText;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: widget.emailController,
        style: TextStyle(color: AppColors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email_outlined, color: AppColors.black),
          hintText: 'Email',
          hintStyle: TextStyle(
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 2),
          errorText: _errorText,
          errorStyle: TextStyle(
            color: AppColors.darkRed,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        onChanged: (value) {
          setState(() {
            if (value.isEmpty) {
              _errorText = 'Email is required';
            } else if (!_isValidEmail(value)) {
              _errorText = 'Invalid email format';
            } else {
              _errorText = null;
            }
          });
        },
      ),
    );
  }
}
