import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/database_service.dart';
import 'package:frontend/database/service/job.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/screens/employee/job_details.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  late Future<List<Map<String, dynamic>>> jobsFuture;

  final String _uid = FirebaseAuth.instance.currentUser!.uid;
  final jobService = JobService();
  final db = DatabaseService();

  @override
  void initState() {
    super.initState();
    jobsFuture = jobService.readAllJob();
  }

  void refreshJobs() {
    setState(() {
      jobsFuture = jobService.readAllJob();
    });
  }

  Future<String> getCompanyName(String employerId) async {
    final snapshot = await db.read(
      collectionPath: 'Employer',
      docId: employerId,
    );

    if (snapshot != null) {
      final data = snapshot.data() as Map<String, dynamic>;
      return data['name'] as String? ?? '';
    } else {
      return '';
    }
  }

  Future<bool> isJobSaved(String jobId) async {
    final snapshot = await db.read(
      collectionPath: 'Employee/$_uid/SavedJob',
      docId: jobId,
    );

    return snapshot != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'JobSearch', isCenterTitle: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 7,
                ),
                suffixIcon: Icon(Icons.search, color: AppColors.black),
                hintText: 'Search',
                hintStyle: TextStyle(color: AppColors.black),
                filled: true,
                fillColor: AppColors.grey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: jobsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/empty.png',
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'There are no job at the moment',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else {
                    final jobs = snapshot.data!;
                    return ListView.builder(
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        final job = jobs[index];
                        return Expanded(
                          child: FutureBuilder<bool>(
                            future: isJobSaved(job['jobId']),
                            builder: (context, snapshot) {
                              bool isSaved = snapshot.data ?? false;
                              return GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => EmployeeJobDetailsScreen(
                                            job: job,
                                          ),
                                    ),
                                  );
                                  refreshJobs();
                                },
                                child: Card(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 3,
                                    vertical: 6,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: AppColors.grey,
                                  child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        ClipOval(
                                          child:
                                              job['logo'].startsWith('assets/')
                                                  ? Image.asset(
                                                    job['logo'],
                                                    width: 60,
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                  )
                                                  : Image.file(
                                                    File(job['logo']),
                                                    width: 60,
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                  ),
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                job['title'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: AppColors.black,
                                                ),
                                              ),
                                              Text(
                                                job['location'],
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: AppColors.black,
                                                ),
                                              ),
                                              Text(
                                                job['payRange'],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            final newIsSaved = !isSaved;
                                            if (newIsSaved) {
                                              await jobService.saveJob(job);
                                            } else {
                                              await jobService.deleteSavedJob(
                                                job['jobId'],
                                              );
                                            }
                                            setState(() {
                                              isSaved = newIsSaved;
                                            });
                                          },
                                          icon: Icon(
                                            isSaved
                                                ? Icons.bookmark
                                                : Icons.bookmark_border,
                                            color: AppColors.black,
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
