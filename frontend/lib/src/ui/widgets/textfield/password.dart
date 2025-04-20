import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController passwordController;

  const PasswordTextField({super.key, required this.passwordController});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscure = true;
  String? _errorText;

  bool _isValidPassword(String password) {
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,16}$',
    );
    return passwordRegex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.passwordController,
          obscureText: _isObscure,
          style: TextStyle(color: AppColors.black),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              color: AppColors.black,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
              icon: Icon(
                _isObscure ? Icons.visibility_off : Icons.visibility,
                color: AppColors.black,
              ),
            ),
            hintText: 'Password',
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
            errorText: null,
          ),
          onChanged: (value) {
            setState(() {
              if (value.isEmpty) {
                _errorText = 'Password is required';
              } else if (!_isValidPassword(value)) {
                _errorText = 'Invalid password';
              } else {
                _errorText = null;
              }
            });
          },
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 20,
          child:
              _errorText != null
                  ? Text(
                    _errorText!,
                    style: TextStyle(
                      color: AppColors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
