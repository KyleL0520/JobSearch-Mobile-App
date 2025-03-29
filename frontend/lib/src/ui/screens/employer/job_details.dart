import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/form_title.dart';
import 'package:frontend/src/ui/widgets/inputBox/string.dart';
import 'package:frontend/src/ui/widgets/popupForm/radio_option.dart';

class EmployerJobDetailsScreen extends StatelessWidget {
  final String? title;
  const EmployerJobDetailsScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title ?? 'Title',
        isCenterTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Save', style: TextStyle(color: AppColors.yellow)),
          ),
        ],
      ),
      body: Form(
        child: Column(
          children: [
            StringBox(
              title: 'Title',
              labelText: title ?? 'Title',
              errorMessage: 'Title is required',
            ),
            const SizedBox(height: 10),
            StringBox(
              title: 'Location',
              labelText: 'Location',
              errorMessage: 'Location is required',
            ),
            const SizedBox(height: 20),
            CustomFormTitle(title: 'Work Type'),
            const SizedBox(height: 10),
            RadioOption(title: 'Full time', viewArrow: false),
            RadioOption(title: 'Part time', viewArrow: false),
            const SizedBox(height: 20),
            CustomFormTitle(title: 'Pay Type'),
            const SizedBox(height: 10),
            RadioOption(title: 'Hourly rate', viewArrow: false),
            RadioOption(title: 'Monthly salary', viewArrow: false),
            RadioOption(title: 'Annual salary', viewArrow: false),
            const SizedBox(height: 20),
            CustomFormTitle(title: 'Pay Range'),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
