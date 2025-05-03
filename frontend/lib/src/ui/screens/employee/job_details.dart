import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/database_service.dart';
import 'package:frontend/database/service/job.dart';
import 'package:frontend/database/service/profile.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/snackbar/snack_bar.dart';
import 'package:frontend/src/ui/widgets/title/form_title.dart';
import 'package:frontend/src/ui/widgets/popupForm/popup_form.dart';
import 'package:frontend/src/ui/widgets/popupForm/radio_option.dart';

class EmployeeJobDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> job;
  const EmployeeJobDetailsScreen({super.key, required this.job});

  @override
  State<EmployeeJobDetailsScreen> createState() =>
      _EmployeeJobDetailsScreenState();
}

class _EmployeeJobDetailsScreenState extends State<EmployeeJobDetailsScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final db = DatabaseService();
  final profileService = ProfileService();
  final jobService = JobService();
  String employerName = '';
  String _avatar = 'assets/images/userAvatar.png';

  String? selectedProfileTitle;
  Map<String, dynamic>? selectedProfile;

  late Future<List<Map<String, dynamic>>> profilesFuture;

  Future<void> _getEmployerName() async {
    final employer = await db.read(
      collectionPath: 'Employer',
      docId: widget.job['createdBy'],
    );
    setState(() {
      employerName = employer!['name'] ?? 'Unknown';
    });
  }

  Future<void> _refreshProfile() async {
    final avatar = await getAvatar(uid);
    setState(() {
      _avatar = avatar ?? 'assets/images/userAvatar.png';
    });
  }

  Future<String?> getAvatar(String uid) async {
    final snapshot = await db.read(collectionPath: 'Employee', docId: uid);

    if (snapshot != null && snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return data['avatar'] as String?;
    }

    return null;
  }

  void submit() async {
    try {
      await jobService.applyJob(
        profile: selectedProfile!,
        job: widget.job,
        avatar: _avatar,
      );
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.successSnackBar(title: 'Profile submitted successfully'),
      );
    } catch (e) {
      print('Submitted failed : $e');
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _getEmployerName();
    profilesFuture = profileService.readAllProfile().then((profiles) {
      if (profiles.isNotEmpty) {
        selectedProfile = profiles.first;
        selectedProfileTitle = profiles.first['title'];
      }
      return profiles;
    });
    _refreshProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Job Details', isCenterTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 17),
              Center(
                child: ClipOval(
                  child:
                      widget.job['logo'].startsWith('assets/')
                          ? Image.asset(
                            widget.job['logo'],
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                          : Image.file(
                            File(widget.job['logo']),
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                widget.job['title'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                employerName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: AppColors.white,
                    size: 26,
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.job['location'],
                    style: TextStyle(fontSize: 15, color: AppColors.white),
                  ),
                ],
              ),
              SizedBox(height: 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.access_time, color: AppColors.white, size: 26),
                  SizedBox(width: 10),
                  Text(
                    widget.job['workType'],
                    style: TextStyle(fontSize: 15, color: AppColors.white),
                  ),
                ],
              ),
              SizedBox(height: 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.payment_outlined,
                    color: AppColors.white,
                    size: 26,
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.job['payType'],
                    style: TextStyle(fontSize: 15, color: AppColors.white),
                  ),
                ],
              ),
              SizedBox(height: 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.attach_money, color: AppColors.white, size: 26),
                  SizedBox(width: 10),
                  Text(
                    widget.job['payRange'],
                    style: TextStyle(fontSize: 15, color: AppColors.white),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.job['description'],
                      style: TextStyle(fontSize: 15, color: AppColors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: profilesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Somethign went wrong'));
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
                                  'There is no profile at the moment.\nThis is your chance to create something exciting!',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        } else {
                          final profiles = snapshot.data!;
                          if (profiles.isNotEmpty &&
                              selectedProfileTitle == null) {
                            selectedProfile = profiles.first;
                            selectedProfileTitle = profiles.first['title'];
                          }
                          return ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (context, setModalState) {
                                      return PopupForm(
                                        title: 'Upload Profile',
                                        btnSubmit: true,
                                        function: submit,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 30),
                                            CustomFormTitle(title: 'Profile'),
                                            SizedBox(height: 10),
                                            RadioOptionGroup(
                                              options:
                                                  profiles
                                                      .map(
                                                        (p) =>
                                                            p['title']
                                                                as String,
                                                      )
                                                      .toList(),
                                              initialValue:
                                                  selectedProfileTitle,
                                              onChanged: (value) {
                                                setModalState(() {
                                                  selectedProfileTitle = value;
                                                  selectedProfile = profiles
                                                      .firstWhere(
                                                        (p) =>
                                                            p['title'] ==
                                                            selectedProfileTitle,
                                                      );
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yellow,
                              padding: EdgeInsets.symmetric(vertical: 11),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Apply',
                              style: TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
