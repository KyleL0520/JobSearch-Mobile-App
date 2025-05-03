import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/database_service.dart';
import 'package:frontend/database/service/job.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/screens/employee/job_details.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/button/redButton.dart';
import 'package:frontend/src/ui/widgets/popupForm/popup_form.dart';
import 'package:frontend/src/ui/widgets/snackbar/snack_bar.dart';

class EmployeeActivityScreen extends StatefulWidget {
  const EmployeeActivityScreen({super.key});

  @override
  State<EmployeeActivityScreen> createState() => _EmployeeActivityScreenState();
}

class _EmployeeActivityScreenState extends State<EmployeeActivityScreen> {
  final String _uid = FirebaseAuth.instance.currentUser!.uid;
  final db = DatabaseService();
  final jobService = JobService();

  bool isSavedSelected = true;

  late Future<List<Map<String, dynamic>>> savedJobsFuture;
  late Future<List<Map<String, dynamic>>> appliedJobsFuture;

  void temp() {}

  void removeApplication(String jobId) async {
    try {
      await jobService.deleteAppliedJob(jobId);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.successSnackBar(title: 'Job apply deleted successfully'),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.failedSnackBar(title: 'Job apply failed to delete'),
      );
    }

    Navigator.pop(context);
    refreshJobs();
  }

  @override
  void initState() {
    super.initState();
    savedJobsFuture = jobService.readSavedJob();
    appliedJobsFuture = jobService.readAppliedJobByEmployee();
  }

  void refreshJobs() {
    setState(() {
      savedJobsFuture = jobService.readSavedJob();
      appliedJobsFuture = jobService.readAppliedJobByEmployee();
    });
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
              child:
                  isSavedSelected
                      ? FutureBuilder<List<Map<String, dynamic>>>(
                        future: savedJobsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Something went wrong'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
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
                                    'There are no saved job at the moment',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            final savedJobs = snapshot.data!;
                            return ListView.builder(
                              itemCount: savedJobs.length,
                              itemBuilder: (context, index) {
                                final savedJob = savedJobs[index];
                                return Expanded(
                                  child: FutureBuilder<bool>(
                                    future: isJobSaved(savedJob['jobId']),
                                    builder: (context, snapshot) {
                                      bool isSaved = snapshot.data ?? false;
                                      return GestureDetector(
                                        onTap: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      EmployeeJobDetailsScreen(
                                                        job: savedJob,
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
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          color: AppColors.grey,
                                          child: Padding(
                                            padding: EdgeInsets.all(12),
                                            child: Row(
                                              children: [
                                                ClipOval(
                                                  child:
                                                      savedJob['logo']
                                                              .startsWith(
                                                                'assets/',
                                                              )
                                                          ? Image.asset(
                                                            savedJob['logo'],
                                                            width: 60,
                                                            height: 60,
                                                            fit: BoxFit.cover,
                                                          )
                                                          : Image.file(
                                                            File(
                                                              savedJob['logo'],
                                                            ),
                                                            width: 60,
                                                            height: 60,
                                                            fit: BoxFit.cover,
                                                          ),
                                                ),
                                                SizedBox(width: 20),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        savedJob['title'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        savedJob['company'],
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        savedJob['location'],
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () async {
                                                    final newIsSaved = !isSaved;
                                                    if (newIsSaved) {
                                                      await jobService.saveJob(
                                                        savedJob,
                                                      );
                                                    } else {
                                                      await jobService
                                                          .deleteSavedJob(
                                                            savedJob['jobId'],
                                                          );
                                                    }
                                                    setState(() {
                                                      isSaved = newIsSaved;
                                                    });
                                                    refreshJobs();
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
                      )
                      : FutureBuilder<List<Map<String, dynamic>>>(
                        future: appliedJobsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Something went wrong'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
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
                                    'There are no saved job at the moment',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            final appliedJobs = snapshot.data!;
                            return ListView.builder(
                              itemCount: appliedJobs.length,
                              itemBuilder: (context, index) {
                                final appliedJob = appliedJobs[index];
                                return Expanded(
                                  child: FutureBuilder<bool>(
                                    future: null,
                                    builder: (context, snapshot) {
                                      return GestureDetector(
                                        onTap: () async {
                                          PopupForm.show(
                                            context: context,
                                            title: 'View Application',
                                            btnSubmit: false,
                                            function: temp,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 20),
                                                Text(
                                                  appliedJob['job']['title'],
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  appliedJob['job']['company'],
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  appliedJob['job']['location'],
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  appliedJob['job']['workType'],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  appliedJob['job']['payRange'],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 30),
                                                Text(
                                                  'Submitted',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Icon(Icons.person),
                                                    const SizedBox(width: 20),
                                                    Text(
                                                      appliedJob['profile']['title'],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 30),
                                                Row(
                                                  children: [
                                                    RedButton(
                                                      text: 'Delete',
                                                      function:
                                                          () => removeApplication(
                                                            appliedJob['job']['jobId'],
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
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
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          color: AppColors.grey,
                                          child: Padding(
                                            padding: EdgeInsets.all(12),
                                            child: Row(
                                              children: [
                                                ClipOval(
                                                  child:
                                                      appliedJob['job']['logo']
                                                              .startsWith(
                                                                'assets/',
                                                              )
                                                          ? Image.asset(
                                                            appliedJob['job']['logo'],
                                                            width: 60,
                                                            height: 60,
                                                            fit: BoxFit.cover,
                                                          )
                                                          : Image.file(
                                                            File(
                                                              appliedJob['job']['logo'],
                                                            ),
                                                            width: 60,
                                                            height: 60,
                                                            fit: BoxFit.cover,
                                                          ),
                                                ),
                                                SizedBox(width: 20),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        appliedJob['job']['title'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        appliedJob['job']['location'],
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        appliedJob['job']['payRange'],
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.check_circle_rounded,
                                                  color: Colors.green,
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
