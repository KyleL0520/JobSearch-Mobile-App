import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';

class PayRangeTextField extends StatefulWidget {
  final TextEditingController textController;
  final String? regex;
  final String hintText;
  final String specifiedErrorMessage;

  const PayRangeTextField({
    super.key,
    required this.textController,
    this.regex,
    required this.hintText,
    required this.specifiedErrorMessage,
  });

  @override
  State<PayRangeTextField> createState() => _PayRangeTextFieldState();
}

class _PayRangeTextFieldState extends State<PayRangeTextField> {
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
      children: [
        TextField(
          controller: widget.textController,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: AppColors.grey,
              fontWeight: FontWeight.bold,
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
                _errorText = 'This field is required';
              } else if (!_isValidText(value)) {
                _errorText = widget.specifiedErrorMessage;
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
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
