import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/auth/auth_service.dart';
import 'package:frontend/database/database_service.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/button/yellowButton.dart';
import 'package:frontend/src/ui/widgets/inputField/text.dart';
import 'package:frontend/src/ui/widgets/snackbar/snack_bar.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  final TextEditingController companyContorller = TextEditingController(
    text: authService.value.currentUser!.displayName,
  );
  final TextEditingController phoneNumberContorller = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final String companyNamePattern = r'^(\b\w+\b[\s]*){1,20}$';
  final String phoneNumberPattern = r'^\+?[0-9]{7,15}$';

  final db = DatabaseService();

  String originalAvatar = 'assets/images/userAvatar.png';
  String _avatar = 'assets/images/userAvatar.png';
  String initialCompany = '';
  String initialPhoneNumber = '';
  String initialLocation = '';

  Future<String?> getAvatar(String uid) async {
    final snapshot = await db.read(collectionPath: 'Employer', docId: uid);

    if (snapshot != null && snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return data['avatar'] as String?;
    }

    return null;
  }

  Future<String?> getPhoneNumber(String uid) async {
    final snapshot = await db.read(collectionPath: 'Employer', docId: uid);

    if (snapshot != null && snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return data['phoneNumber'] as String?;
    }

    return null;
  }

  Future<String?> getLocation(String uid) async {
    final snapshot = await db.read(collectionPath: 'Employer', docId: uid);

    if (snapshot != null && snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return data['location'] as String?;
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    initialCompany = authService.value.currentUser?.displayName ?? '';
    companyContorller.text = initialCompany;

    getAvatar(uid).then((value) {
      setState(() {
        originalAvatar = value ?? 'assets/images/userAvatar.png';
        _avatar = originalAvatar;
      });
    });

    getPhoneNumber(uid).then((value) {
      setState(() {
        initialPhoneNumber = value ?? '';
        phoneNumberContorller.text = initialPhoneNumber;
      });
    });
    getLocation(uid).then((value) {
      setState(() {
        initialLocation = value ?? '';
        locationController.text = initialLocation;
      });
    });
  }

  Future pickImageFromGallery() async {
    final selectedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (selectedImage != null) {
      setState(() {
        _avatar = selectedImage.path;
      });
    }
  }

  void updateUsername() async {
    try {
      await authService.value.updateUsername(username: companyContorller.text);
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Company name change failed'),
          backgroundColor: AppColors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void updateProfile() async {
    final String currentAvatar = _avatar;
    final String currentCompanyName = companyContorller.text.trim();
    final String currentPhoneNumber = phoneNumberContorller.text.trim();
    final String currentLocation = locationController.text.trim();
    final firebaseFirestore = FirebaseFirestore.instance;

    if (currentAvatar == originalAvatar &&
        currentCompanyName == initialCompany &&
        currentPhoneNumber == initialPhoneNumber &&
        currentLocation == initialLocation) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(CustomSnackBar.failedSnackBar(title: 'No changes update'));
      return;
    }

    if ((currentCompanyName == '' ||
            currentCompanyName.isEmpty ||
            !RegExp(companyNamePattern).hasMatch(currentCompanyName)) ||
        (currentPhoneNumber == '' ||
            currentPhoneNumber.isEmpty ||
            !RegExp(phoneNumberPattern).hasMatch(currentPhoneNumber)) ||
        (currentLocation == '' || currentLocation.isEmpty)) {
      return;
    }

    Map<String, dynamic> updatedData = {};

    if (currentCompanyName != initialCompany) {
      updateUsername();
      updatedData['name'] = currentCompanyName;
      initialCompany = currentCompanyName;
    }

    updatedData['avatar'] = currentAvatar;
    originalAvatar = currentAvatar;

    updatedData['phoneNumber'] = currentPhoneNumber;
    initialPhoneNumber = currentPhoneNumber;

    updatedData['location'] = currentLocation;
    initialLocation = currentLocation;

    try {
      if (updatedData.isNotEmpty) {
        await db.update(
          collectionPath: 'Employer',
          docId: uid,
          data: updatedData,
        );

        final jobsSnapshot =
            await firebaseFirestore
                .collection('Employer')
                .doc(uid)
                .collection('Job')
                .get();

        for (var doc in jobsSnapshot.docs) {
          await db.update(
            collectionPath: 'Employer/$uid/Job',
            docId: doc.id,
            data: {'logo': currentAvatar},
          );
        }
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.successSnackBar(title: 'Profile updated successfully'),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.failedSnackBar(title: 'Profile failed to update'),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Profile', isCenterTitle: true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: pickImageFromGallery,
              child: Stack(
                children: [
                  ClipOval(
                    child:
                        _avatar.startsWith('assets/')
                            ? Image.asset(
                              _avatar,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                            : Image.file(
                              File(_avatar),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(Icons.edit, color: AppColors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            StringTextField(
              textController: companyContorller,
              hintText: '',
              title: 'Company',
              regex: companyNamePattern,
              specifiedErrorMessage:
                  'Company name cannot be more than 20 words',
            ),
            StringTextField(
              textController: phoneNumberContorller,
              hintText: '',
              title: 'Phone Number',
              regex: phoneNumberPattern,
              specifiedErrorMessage: 'Invalid phone number format',
            ),
            StringTextField(
              textController: locationController,
              hintText: '',
              title: 'Company Location',
              specifiedErrorMessage: '',
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: YellowButton(text: 'Edit', function: updateProfile),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
