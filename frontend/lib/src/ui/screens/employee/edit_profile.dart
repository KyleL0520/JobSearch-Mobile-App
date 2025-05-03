import 'dart:io';

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

  final TextEditingController nameContorller = TextEditingController(
    text: authService.value.currentUser!.displayName,
  );
  final TextEditingController phoneNumberContorller = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final String namePattern = r'^(\b\w+\b[\s]*){1,20}$';
  final String phoneNumberPattern = r'^\+?[0-9]{7,15}$';

  final db = DatabaseService();

  String originalAvatar = 'assets/images/userAvatar.png';
  String _avatar = 'assets/images/userAvatar.png';
  String initialName = '';
  String initialPhoneNumber = '';
  String initialLocation = '';

  Future<String?> getAvatar(String uid) async {
    final snapshot = await db.read(collectionPath: 'Employee', docId: uid);

    if (snapshot != null && snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return data['avatar'] as String?;
    }

    return null;
  }

  Future<String?> getPhoneNumber(String uid) async {
    final snapshot = await db.read(collectionPath: 'Employee', docId: uid);

    if (snapshot != null && snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return data['phoneNumber'] as String?;
    }

    return null;
  }

  Future<String?> getLocation(String uid) async {
    final snapshot = await db.read(collectionPath: 'Employee', docId: uid);

    if (snapshot != null && snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return data['location'] as String?;
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    initialName = authService.value.currentUser?.displayName ?? '';
    nameContorller.text = initialName;

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
      await authService.value.updateUsername(username: nameContorller.text);
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Username change failed'),
          backgroundColor: AppColors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void updateProfile() async {
    final String currentAvatar = _avatar;
    final String currentName = nameContorller.text.trim();
    final String currentPhoneNumber = phoneNumberContorller.text.trim();
    final String currentLocation = locationController.text.trim();

    if (currentAvatar == originalAvatar &&
        currentName == initialName &&
        currentPhoneNumber == initialPhoneNumber &&
        currentLocation == initialLocation) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(CustomSnackBar.failedSnackBar(title: 'No changes update'));
      return;
    }

    if ((currentName == '' ||
            currentName.isEmpty ||
            !RegExp(namePattern).hasMatch(currentName)) ||
        (currentPhoneNumber == '' ||
            currentPhoneNumber.isEmpty ||
            !RegExp(phoneNumberPattern).hasMatch(currentPhoneNumber)) ||
        (currentLocation == '' || currentLocation.isEmpty)) {
      return;
    }

    Map<String, dynamic> updatedData = {};

    if (currentName != initialName) {
      updateUsername();
      updatedData['name'] = currentName;
      initialName = currentName;
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
          collectionPath: 'Employee',
          docId: uid,
          data: updatedData,
        );
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.successSnackBar(
          title: 'Profile details updated successfully',
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.failedSnackBar(
          title: 'Profile details failed to update',
        ),
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
              textController: nameContorller,
              hintText: '',
              title: 'Company',
              regex: namePattern,
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
              title: 'Location',
              specifiedErrorMessage: '',
            ),
            const SizedBox(height: 10),
            YellowButton(text: 'Edit', function: updateProfile),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
