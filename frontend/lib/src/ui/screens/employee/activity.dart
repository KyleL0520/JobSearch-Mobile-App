import 'package:flutter/material.dart';
import 'package:frontend/src/provider/job.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/button/redButton.dart';
import 'package:frontend/src/ui/widgets/jobCard/job_card.dart';
import 'package:frontend/src/ui/widgets/jobCard/job_card_applied.dart';
import 'package:provider/provider.dart';

class EmployeeActivityScreen extends StatefulWidget {
  const EmployeeActivityScreen({super.key});

  @override
  State<EmployeeActivityScreen> createState() => _EmployeeActivityScreenState();
}

class _EmployeeActivityScreenState extends State<EmployeeActivityScreen> {
  bool isSavedSelected = true;

  @override
  Widget build(BuildContext context) {
    final job = Provider.of<JobProvider>(context).job;

    return Scaffold(
      appBar: CustomAppBar(title: 'Activity', isCenterTitle: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isSavedSelected = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSavedSelected ? AppColors.yellow : AppColors.white,
                      padding: EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Saved',
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isSavedSelected = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSavedSelected ? AppColors.white : AppColors.yellow,
                      padding: EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Applied',
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return isSavedSelected
                      ? JobCard(isShowBookmark: true)
                      : JobCardApplied(
                        formTitle: 'View Application',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 30),
                            Text(
                              job!.title,
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              job.company,
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              job.location,
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              'RM 5,000 - RM 7,000 per month',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 40),
                            Text(
                              'Submitted',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity(vertical: -4),
                              leading: Icon(
                                Icons.person_outline_rounded,
                                size: 25,
                              ),
                              title: Text(
                                'Web Dev Profile',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.white,
                                size: 19,
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity(vertical: -4),
                              leading: Icon(
                                Icons.insert_drive_file_outlined,
                                size: 25,
                              ),
                              title: Text(
                                'Cover Letter.pdf',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.white,
                                size: 19,
                              ),
                            ),
                            SizedBox(height: 30),
                            Row(children: [RedButton(text: 'Delete')]),
                          ],
                        ),
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
