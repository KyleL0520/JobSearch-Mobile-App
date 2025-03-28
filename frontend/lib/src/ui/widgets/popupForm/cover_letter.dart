import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/popupForm/title.dart';

class CoverLetter extends StatefulWidget {
  const CoverLetter({super.key});

  @override
  State<CoverLetter> createState() => _CoverLetterState();
}

class _CoverLetterState extends State<CoverLetter> {
  String? selectedCoverLetter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomPopupFormTitle(title: 'Cover Letter'),
            TextButton(
              onPressed: () {},
              child: Text(
                'Upload',
                style: TextStyle(
                  color: AppColors.yellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        buildRadioOption('CoverLetter.pdf'),
        buildRadioOption('Write a cover letter'),
        buildRadioOption("Don't include a cover letter"),
      ],
    );
  }

  Widget buildRadioOption(String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity(vertical: -4),
      leading: Radio<String>(
        value: title,
        groupValue: selectedCoverLetter,
        activeColor: AppColors.yellow,
        onChanged: (String? value) {
          setState(() {
            selectedCoverLetter = value;
          });
        },
      ),
      title: Text(
        title,
        style: TextStyle(color: AppColors.white, fontSize: 14),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: AppColors.white, size: 19),
    );
  }
}
