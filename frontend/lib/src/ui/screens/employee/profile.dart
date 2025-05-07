import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/auth/auth_service.dart';
import 'package:frontend/database/database_service.dart';
import 'package:frontend/database/service/profile.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/screens/edit_password.dart';
import 'package:frontend/src/ui/screens/employee/profile_details.dart';
import 'package:frontend/src/ui/screens/employee/edit_profile.dart';
import 'package:frontend/src/ui/screens/login.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';

enum Menu { profileDetails, editPassword, logout }

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({super.key});

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final db = DatabaseService();
  final profileService = ProfileService();

  late Future<List<Map<String, dynamic>>> profilesFuture;

  String _displayName = 'Profile';

  Future<void> _refreshProfile() async {
    await FirebaseAuth.instance.currentUser?.reload();
    final displayName = authService.value.currentUser!.displayName ?? 'Profile';

    setState(() {
      profilesFuture = profileService.readAllProfile();
      _displayName = displayName;
    });
  }

  @override
  void initState() {
    super.initState();
    profilesFuture = profileService.readAllProfile();
    _refreshProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _displayName,
        isCenterTitle: false,
        actions: [
          PopupMenuButton<Menu>(
            onSelected: (value) {
              switch (value) {
                case Menu.profileDetails:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ),
                  );
                  break;

                case Menu.editPassword:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPasswordScreen(uid: uid),
                    ),
                  );
                  break;

                case Menu.logout:
                  () async {
                    await authService.value.signOut();
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }();
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: Menu.profileDetails,
                  child: Text(
                    'Profile Details',
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
                PopupMenuItem(
                  value: Menu.editPassword,
                  child: Text(
                    'Edit Password',
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
                PopupMenuItem(
                  value: Menu.logout,
                  child: Row(
                    children: [
                      Text('Logout', style: TextStyle(color: AppColors.red)),
                      Icon(Icons.logout_outlined, color: AppColors.red),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileDetailsScreen()),
          );
          _refreshProfile();
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
                future: profilesFuture,
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
                            'There is no profile at the moment.\nThis is your chance to create something exciting!',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else {
                    final profiles = snapshot.data!;
                    return ListView.builder(
                      itemCount: profiles.length,
                      itemBuilder: (context, index) {
                        final profile = profiles[index];

                        return GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        ProfileDetailsScreen(profile: profile),
                              ),
                            );
                            _refreshProfile();
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile['title'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: AppColors.black,
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
