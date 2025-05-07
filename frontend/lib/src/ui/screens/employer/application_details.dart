import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/database/service/job.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/button/redButton.dart';
import 'package:frontend/src/ui/widgets/button/yellowButton.dart';
import 'package:frontend/src/ui/widgets/card.dart';
import 'package:frontend/src/ui/widgets/snackbar/snack_bar.dart';
import 'package:frontend/src/ui/widgets/title/form_title.dart';

class ApplicationDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> appliedJob;
  final bool isAccepted;
  const ApplicationDetailsScreen({
    super.key,
    required this.appliedJob,
    required this.isAccepted,
  });

  @override
  State<ApplicationDetailsScreen> createState() =>
      _ApplicationDetailsScreenState();
}

class _ApplicationDetailsScreenState extends State<ApplicationDetailsScreen> {
  final jobService = JobService();

  void acceptApplication() async {
    try {
      await jobService.acceptApplication(
        applicationId: widget.appliedJob['applicationId'],
      );
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.successSnackBar(
          title: 'Application accepted successfully',
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.failedSnackBar(title: 'Failed to accept application'),
      );
    }

    Navigator.pop(context);
  }

  void rejectApplication() async {
    try {
      await jobService.rejectApplication(
        applicationId: widget.appliedJob['applicationId'],
      );
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.successSnackBar(
          title: 'Application rejected successfully',
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.failedSnackBar(title: 'Failed to reject application'),
      );
    }
    Navigator.pop(context);
  }

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
                      widget.appliedJob['avatar'].startsWith('assets/')
                          ? Image.asset(
                            widget.appliedJob['avatar'],
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                          : Image.file(
                            File(widget.appliedJob['avatar']),
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Image.asset('assets/icons/job.png', width: 18, height: 18),
                  const SizedBox(width: 15),
                  Text(widget.appliedJob['profile']['title']),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.email_outlined, color: AppColors.white),
                  const SizedBox(width: 10),
                  Text(widget.appliedJob['email']),
                ],
              ),
              const SizedBox(height: 30),
              const CustomFormTitle(title: 'Career History'),
              const SizedBox(height: 10),
              Column(
                children:
                    (widget.appliedJob['profile']['careerHistorys'] as List)
                        .map<Widget>(
                          (career) => Row(
                            children: [
                              CardWidget(
                                first: career['company'],
                                second: career['jobTitle'],
                                third:
                                    career['stillInThisRole'] == true
                                        ? '${career['startDate']} - Still in this role'
                                        : '${career['startDate']} - ${career['endDate']}',
                              ),
                            ],
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 20),
              const CustomFormTitle(title: 'Education'),
              const SizedBox(height: 10),
              Column(
                children:
                    (widget.appliedJob['profile']['educations'] as List)
                        .map<Widget>(
                          (education) => Row(
                            children: [
                              CardWidget(
                                first: education['courseOfQualification'],
                                second: education['institution'],
                                third:
                                    education['isComplete'] == true
                                        ? 'Finished in ${education['finishDate']}'
                                        : 'Currently Studying',
                              ),
                            ],
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 20),
              const CustomFormTitle(title: 'Skills'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    (widget.appliedJob['profile']['skills'] as List)
                        .map<Widget>((skill) => _pointCard(skill['label']))
                        .toList(),
              ),
              const SizedBox(height: 20),
              const CustomFormTitle(title: 'Languages'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    (widget.appliedJob['profile']['languages'] as List)
                        .map<Widget>(
                          (language) => _pointCard(language['label']),
                        )
                        .toList(),
              ),
              const SizedBox(height: 30),
              widget.isAccepted
                  ? SizedBox()
                  : Row(
                    children: [
                      Expanded(
                        child: RedButton(
                          text: 'Reject',
                          function: rejectApplication,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: YellowButton(
                          text: 'Accept',
                          function: acceptApplication,
                        ),
                      ),
                    ],
                  ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pointCard(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        name,
        style: const TextStyle(fontSize: 15, color: AppColors.black),
      ),
    );
  }
}
