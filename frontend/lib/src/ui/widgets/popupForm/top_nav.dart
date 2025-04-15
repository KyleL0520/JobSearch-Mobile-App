import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/title/form_title.dart';

class PopupFormTopNav extends StatelessWidget {
  final String title;
  final bool btnSubmit;
  const PopupFormTopNav({
    super.key,
    required this.title,
    required this.btnSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            '<  back',
            style: TextStyle(
              color: AppColors.darkRed,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        CustomFormTitle(title: title),
        btnSubmit
            ? GestureDetector(
              onTap: () {},
              child: Text(
                'Submit',
                style: TextStyle(
                  color: AppColors.yellow,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
            : Text('       '),
      ],
    );
  }
}
