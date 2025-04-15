import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/button/redButton.dart';
import 'package:frontend/src/ui/widgets/button/yellowButton.dart';
import 'package:frontend/src/ui/widgets/title/form_title.dart';

class ApplicationDetailsScreen extends StatelessWidget {
  const ApplicationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Application', isCenterTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.asset(
                      'assets/images/userAvatar.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: AppColors.white),
                  const SizedBox(width: 10),
                  Text('Kuala Lumpur'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Image.asset('assets/icons/job.png', width: 18, height: 18),
                  const SizedBox(width: 15),
                  Text('Full Stack Web Developer'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.local_phone_outlined, color: AppColors.white),
                  const SizedBox(width: 10),
                  Text('+60 01125554123'),
                ],
              ),
              const SizedBox(height: 30),
              CustomFormTitle(title: 'Career History'),
              const SizedBox(height: 10),
              _three_line_card(
                'Full-Stack developer',
                'Lazada Company',
                'March 2023 - March 2024',
              ),
              _three_line_card(
                'Backend developer',
                'Ant Company',
                'April 2022 - February 2023',
              ),
              const SizedBox(height: 20),
              CustomFormTitle(title: 'Education'),
              const SizedBox(height: 10),
              _three_line_card(
                'Bachelor of Software Engineering',
                'Tunku Abdul Rahman College',
                'Finsihed in Jan 2022',
              ),
              const SizedBox(height: 20),
              CustomFormTitle(title: 'Skills'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _pointCard('NestJs'),
                  _pointCard('MongoDB'),
                  _pointCard('Typescript'),
                  _pointCard('React'),
                  _pointCard('NextJs'),
                ],
              ),
              const SizedBox(height: 20),
              CustomFormTitle(title: 'Languages'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _pointCard('English'),
                  _pointCard('Chinese - Mandarin'),
                  _pointCard('Melayu'),
                ],
              ),
              const SizedBox(height: 20),
              CustomFormTitle(title: 'Resume'),
              const SizedBox(height: 10),
              Row(children: [_fileCard('Resume.pdf')]),
              const SizedBox(height: 20),
              CustomFormTitle(title: 'Cover Letter'),
              const SizedBox(height: 10),
              Row(children: [_fileCard('CoverLetter.pdf')]),
              const SizedBox(height: 30),
              Row(
                children: [
                  RedButton(text: 'Reject'),
                  SizedBox(width: 10),
                  YellowButton(text: 'Accept'),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _three_line_card(String title, String venue, String date) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 3, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.grey,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColors.black,
                    ),
                  ),
                  Text(
                    venue,
                    style: TextStyle(fontSize: 13, color: AppColors.black),
                  ),
                  Text(
                    date,
                    style: TextStyle(fontSize: 13, color: AppColors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pointCard(String name) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(name, style: TextStyle(fontSize: 15, color: AppColors.black)),
    );
  }

  Widget _fileCard(String name) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.document_scanner_outlined,
              color: AppColors.black,
              size: 35,
            ),
            SizedBox(width: 10),
            Text(name, style: TextStyle(fontSize: 15, color: AppColors.black)),
          ],
        ),
      ),
    );
  }
}
