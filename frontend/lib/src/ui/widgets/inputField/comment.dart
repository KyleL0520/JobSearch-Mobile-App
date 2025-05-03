import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';

class CommentTextField extends StatefulWidget {
  final TextEditingController commentController;
  const CommentTextField({super.key, required this.commentController});

  @override
  State<CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends State<CommentTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.commentController,
      maxLength: 400,
      maxLines: 13,
      minLines: 13,
      style: TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        hintText: 'comment...',
        hintStyle: TextStyle(color: AppColors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.white),
        ),
        filled: true,
        fillColor: AppColors.darkBlue,
        contentPadding: EdgeInsets.all(15),
      ),
    );
  }
}
