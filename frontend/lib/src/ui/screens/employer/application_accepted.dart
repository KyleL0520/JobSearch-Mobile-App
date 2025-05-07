import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/database/service/job.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/screens/employer/application_details.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';

class ApplicationAcceptedScreen extends StatefulWidget {
  const ApplicationAcceptedScreen({super.key});

  @override
  State<ApplicationAcceptedScreen> createState() =>
      _ApplicationAcceptedScreenState();
}

class _ApplicationAcceptedScreenState extends State<ApplicationAcceptedScreen> {
  final jobService = JobService();
  late Future<List<Map<String, dynamic>>> applicationAcceptedFuture;

  @override
  void initState() {
    super.initState();
    applicationAcceptedFuture = jobService.readAcceptedApplication();
  }

  void refreshJobs() {
    setState(() {
      applicationAcceptedFuture = jobService.readAcceptedApplication();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Application', isCenterTitle: true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: applicationAcceptedFuture,
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
                            'There are no job accepted at the moment',
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
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ApplicationDetailsScreen(
                                      isAccepted: true,
                                      appliedJob: appliedJob,
                                    ),
                              ),
                            );
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
                                        appliedJob['avatar'].startsWith(
                                              'assets/',
                                            )
                                            ? Image.asset(
                                              appliedJob['avatar'],
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            )
                                            : Image.file(
                                              File(appliedJob['avatar']),
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          appliedJob['employeeName'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: AppColors.black,
                                          ),
                                        ),
                                        Text(
                                          appliedJob['profile']['title'],
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
