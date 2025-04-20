import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController textController;
  final String? regex;
  final String hintText;
  final IconData icon;
  final String? specifiedErrorMessage;

  const AuthTextField({
    super.key,
    required this.textController,
    this.regex,
    required this.hintText,
    this.specifiedErrorMessage,
    required this.icon,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  String? _errorText;

  bool _isValidText(String text) {
    if (widget.regex != null) {
      final regex = RegExp(widget.regex!);
      return regex.hasMatch(text);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.textController,
          style: TextStyle(color: AppColors.black, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon, color: AppColors.black),
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: AppColors.grey,
              fontWeight: FontWeight.w600,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            errorText: null,
          ),
          onChanged: (value) {
            setState(() {
              if (value.isEmpty) {
                _errorText = '${widget.hintText} is required';
              } else if (!_isValidText(value)) {
                _errorText = widget.specifiedErrorMessage ?? '';
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
