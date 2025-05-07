import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/database/service/job.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/screens/employer/application_details.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';

class EmployerActivityScreen extends StatefulWidget {
  const EmployerActivityScreen({super.key});

  @override
  State<EmployerActivityScreen> createState() => _EmployerActivityScreenState();
}

class _EmployerActivityScreenState extends State<EmployerActivityScreen> {
  final jobService = JobService();
  late Future<List<Map<String, dynamic>>> appliedJobsFuture;

  @override
  void initState() {
    super.initState();
    appliedJobsFuture = jobService.readApplication();
  }

  void refreshJobs() {
    setState(() {
      appliedJobsFuture = jobService.readApplication();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Activity', isCenterTitle: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: appliedJobsFuture,
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
                            'There are no job applied at the moment',
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
                        if (appliedJob['isAccept'] == null) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ApplicationDetailsScreen(
                                        isAccepted: false,
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
                        } else {
                          return SizedBox.shrink();
                        }
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
