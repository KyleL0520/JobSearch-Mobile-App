import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/title/form_title.dart';

class DescriptionTextField extends StatefulWidget {
  final TextEditingController textController;
  final String title;
  final String? regex;
  final String hintText;
  final int maxLength;
  final String specifiedErrorMessage;

  const DescriptionTextField({
    super.key,
    required this.textController,
    this.regex,
    required this.hintText,
    required this.title,
    required this.specifiedErrorMessage,
    required this.maxLength,
  });

  @override
  State<DescriptionTextField> createState() => _DescriptionTextFieldState();
}

class _DescriptionTextFieldState extends State<DescriptionTextField> {
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
        CustomFormTitle(title: widget.title),
        const SizedBox(height: 10),
        TextField(
          controller: widget.textController,
          maxLength: widget.maxLength,
          maxLines: 9,
          minLines: 9,
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
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            errorText: null,
          ),
          onChanged: (value) {
            setState(() {
              if (value.isEmpty) {
                _errorText = '${widget.title} is required';
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
