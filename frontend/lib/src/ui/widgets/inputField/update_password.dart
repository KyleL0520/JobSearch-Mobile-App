import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/title/form_title.dart';

class UpdatePasswordTextField extends StatefulWidget {
  final String title;
  final TextEditingController passwordController;
  final String hintText;

  const UpdatePasswordTextField({
    super.key,
    required this.title,
    required this.passwordController,
    required this.hintText,
  });

  @override
  State<UpdatePasswordTextField> createState() =>
      _UpdatePasswordTextFieldState();
}

class _UpdatePasswordTextFieldState extends State<UpdatePasswordTextField> {
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
        CustomFormTitle(title: widget.title),
        const SizedBox(height: 10),
        TextField(
          controller: widget.passwordController,
          style: TextStyle(color: AppColors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: AppColors.grey,
              fontWeight: FontWeight.w600,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            errorText: null,
          ),
          onChanged: (value) {
            setState(() {
              if (value.isEmpty) {
                _errorText = '${widget.title} is required';
              } else if (!_isValidPassword(value)) {
                _errorText = 'Password format incorrect';
              } else {
                _errorText = null;
              }
            });
          },
        ),
        const SizedBox(height: 5),
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
      ],
    );
  }
}
