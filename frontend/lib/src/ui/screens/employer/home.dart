import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/service/job.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/screens/employer/job_details.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/card.dart';

class EmployerHomeScreen extends StatefulWidget {
  const EmployerHomeScreen({super.key});

  @override
  State<EmployerHomeScreen> createState() => _EmployerHomeScreenState();
}

class _EmployerHomeScreenState extends State<EmployerHomeScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final jobService = JobService();

  late Future<List<Map<String, dynamic>>> jobsFuture;

  @override
  void initState() {
    super.initState();
    jobsFuture = jobService.readJobById();
  }

  void refreshJobs() {
    setState(() {
      jobsFuture = jobService.readJobById();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'JobSearch', isCenterTitle: false),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EmployerJobDetailsScreen()),
          );
          refreshJobs();
        },
        backgroundColor: AppColors.yellow,
        child: Icon(Icons.add, color: AppColors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: jobsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Somethign went wrong'));
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
                            'There is no job at the moment.\nThis is your chance to create something exciting!',
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

                        return GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => EmployerJobDetailsScreen(
                                      jobId: job['jobId'],
                                      title: job['title'],
                                      location: job['location'],
                                      workType: job['workType'],
                                      payType: job['payType'],
                                      payRange: job['payRange'],
                                      description: job['description'],
                                    ),
                              ),
                            );
                            refreshJobs();
                          },
                          child: CardWidget(
                            first: job['title'],
                            second: job['location'],
                            third: job['payRange'],
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
