import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/popupForm/title.dart';

class ProfileOption extends StatefulWidget {
  const ProfileOption({super.key});

  @override
  State<ProfileOption> createState() => _ProfileOptionState();
}

class _ProfileOptionState extends State<ProfileOption> {
  String? selectedProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomPopupFormTitle(title: 'Profile'),
        SizedBox(height: 10),
        buildRadioOption('Web Dev Profile'),
        buildRadioOption('Event Crew Profile'),
        buildRadioOption('Mobile Dev Profile'),
      ],
    );
  }

  Widget buildRadioOption(String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity(vertical: -4),
      leading: Radio<String>(
        value: title,
        groupValue: selectedProfile,
        activeColor: AppColors.yellow,
        onChanged: (String? value) {
          setState(() {
            selectedProfile = value;
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
