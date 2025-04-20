import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/textfield/text.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController companyContorller = TextEditingController();
    final TextEditingController emailContorller = TextEditingController();
    final TextEditingController phoneNumberContorller = TextEditingController();
    final TextEditingController companyLocationContorller =
        TextEditingController();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Profile',
        isCenterTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Save', style: TextStyle(color: AppColors.yellow)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/images/shopee.jpg', width: 80, height: 80),
            const SizedBox(height: 20),
            StringTextField(
              textController: companyContorller,
              hintText: 'Shopee',
              title: 'Company',
              regex: r'^(\b\w+\b[\s]*){1,20}$',
              specifiedErrorMessage:
                  'Company name cannot be more than 20 words',
            ),
            StringTextField(
              textController: emailContorller,
              hintText: 'shopee0113@gmail.com',
              title: 'Email',
              regex: r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
              specifiedErrorMessage: 'Invalid email format',
            ),
            StringTextField(
              textController: phoneNumberContorller,
              hintText: '+60 1125447863',
              title: 'Phone Number',
              regex: r'^\+?[0-9]{7,15}$',
              specifiedErrorMessage: 'Invalid phone number format',
            ),
            StringTextField(
              textController: companyLocationContorller,
              hintText: 'Kuala Lumpur',
              title: 'Company Location',
              specifiedErrorMessage: '',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
