import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';

class UsernameTextField extends StatefulWidget {
  final TextEditingController usernameController;

  const UsernameTextField({super.key, required this.usernameController});

  @override
  State<UsernameTextField> createState() => _UsernameTextFieldState();
}

class _UsernameTextFieldState extends State<UsernameTextField> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: widget.usernameController,
        style: TextStyle(color: AppColors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.person_outline_rounded,
            color: AppColors.black,
          ),
          hintText: 'Username',
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
              _errorText = 'Username is required';
            } else {
              _errorText = null;
            }
          });
        },
      ),
    );
  }
}
