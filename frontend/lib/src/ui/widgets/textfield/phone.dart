import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';

class PhoneNumberTextField extends StatefulWidget {
  final TextEditingController phoneNumberController;

  const PhoneNumberTextField({super.key, required this.phoneNumberController});

  @override
  State<PhoneNumberTextField> createState() => _PhoneNumberTextFieldState();
}

class _PhoneNumberTextFieldState extends State<PhoneNumberTextField> {
  String? _errorText;

  bool _isValidPhoneNumber(String email) {
    final phoneNumberRegex = RegExp(r'^\+?[0-9]{7,15}$');
    return phoneNumberRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: widget.phoneNumberController,
        style: TextStyle(color: AppColors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.local_phone_outlined, color: AppColors.black),
          hintText: 'Phone Number',
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
              _errorText = 'Phone Number is required';
            } else if (!_isValidPhoneNumber(value)) {
              _errorText = 'Invalid phone number format';
            } else {
              _errorText = null;
            }
          });
        },
      ),
    );
  }
}
