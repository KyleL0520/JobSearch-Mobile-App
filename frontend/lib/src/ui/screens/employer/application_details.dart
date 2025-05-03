import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/button/redButton.dart';
import 'package:frontend/src/ui/widgets/button/yellowButton.dart';
import 'package:frontend/src/ui/widgets/title/form_title.dart';

class ApplicationDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> appliedJob;
  const ApplicationDetailsScreen({super.key, required this.appliedJob});

  void temp() {}

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
              Center(
                child: ClipOval(
                  child:
                      appliedJob['avatar'].startsWith('assets/')
                          ? Image.asset(
                            appliedJob['avatar'],
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                          : Image.file(
                            File(appliedJob['avatar']),
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                ),
              ),
              const SizedBox(height: 30),
              const SizedBox(height: 10),
              Row(
                children: [
                  Image.asset('assets/icons/job.png', width: 18, height: 18),
                  const SizedBox(width: 15),
                  Text(appliedJob['profile']['title']),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.email_outlined, color: AppColors.white),
                  const SizedBox(width: 10),
                  Text(appliedJob['email']),
                ],
              ),
              const SizedBox(height: 30),
              CustomFormTitle(title: 'Career History'),
              const SizedBox(height: 10),
              Column(
                children:
                    appliedJob['profile']['careerHistorys']
                        .map<Widget>(
                          (career) => _three_line_card(
                            career['company'],
                            career['jobTitle'],
                            career['stillInThisRole'] == true
                                ? '${career['startDate']} - Still in this role'
                                : '${career['startDate']} - ${career['endDate']}',
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 20),
              CustomFormTitle(title: 'Education'),
              const SizedBox(height: 10),
              Column(
                children:
                    appliedJob['profile']['educations']
                        .map<Widget>(
                          (education) => _three_line_card(
                            education['courseOfQualification'],
                            education['institution'],
                            education['isComplete'] == true
                                ? 'Finished in ${education['finishDate']}'
                                : 'Currently Studying',
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 20),
              CustomFormTitle(title: 'Skills'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    appliedJob['profile']['skills']
                        .map<Widget>((skill) => _pointCard(skill['label']))
                        .toList(),
              ),
              const SizedBox(height: 20),
              CustomFormTitle(title: 'Languages'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    appliedJob['profile']['languages']
                        .map<Widget>(
                          (language) => _pointCard(language['label']),
                        )
                        .toList(),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  RedButton(text: 'Reject', function: temp),
                  SizedBox(width: 10),
                  YellowButton(text: 'Accept', function: temp),
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
}
