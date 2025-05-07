import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/auth/auth_service.dart';
import 'package:frontend/database/database_service.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/button/yellowButton.dart';
import 'package:frontend/src/ui/widgets/snackbar/snack_bar.dart';
import 'package:frontend/src/ui/widgets/title/form_title.dart';

class EditPasswordScreen extends StatefulWidget {
  final String uid;
  const EditPasswordScreen({super.key, required this.uid});

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController currentPasswordContorller =
      TextEditingController();
  final TextEditingController newPasswordContorller = TextEditingController();
  final db = DatabaseService();
  bool _isObscure1 = true;
  bool _isObscure2 = true;

  String? _currentPasswordErrorText = '';
  String? _newPasswordErrorText = '';

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    super.dispose();
    currentPasswordContorller.dispose();
    newPasswordContorller.dispose();
  }

  @override
  void initState() {
    super.initState();
    getAvatar(uid).then((value) {
      setState(() {
        _avatar = value ?? 'assets/images/userAvatar.png';
      });
    });
  }

  String _avatar = 'assets/images/userAvatar.png';

  Future<String?> getAvatar(String uid) async {
    final employeeDoc =
        await FirebaseFirestore.instance.collection('Employee').doc(uid).get();

    String role = '';
    if (employeeDoc.exists) {
      role = 'Employee';
    } else {
      final employerDoc =
          await FirebaseFirestore.instance
              .collection('Employer')
              .doc(uid)
              .get();

      if (employerDoc.exists) {
        role = 'Employer';
      }
    }

    print(uid);
    final snapshot = await db.read(collectionPath: role, docId: uid);

    if (snapshot != null && snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return data['avatar'] as String?;
    }

    return null;
  }

  void updatePassword() async {
    final currentPassword = currentPasswordContorller.text;
    final newPassword = newPasswordContorller.text;

    if (currentPassword.isEmpty || newPassword.isEmpty) {
      setState(() {
        _currentPasswordErrorText =
            currentPassword.isEmpty ? 'Current password is required' : null;
        _newPasswordErrorText =
            newPassword.isEmpty ? 'New password is required' : null;
      });
      return;
    }

    if (!_isValidPassword(currentPassword)) {
      setState(() => _currentPasswordErrorText = 'Invalid password format');
      return;
    }

    if (!_isValidPassword(newPassword)) {
      setState(() => _newPasswordErrorText = 'Invalid password format');
      return;
    }

    try {
      await authService.value.resetPasswordFromCurrentPassword(
        currentPassword: currentPasswordContorller.text,
        newPassword: newPasswordContorller.text,
        email: user!.email!,
      );
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.successSnackBar(title: 'Password changed successfully!'),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Password change failed';

      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        errorMessage = 'Incorrect current password';
      } else if (e.code == 'password-same-as-current') {
        errorMessage = 'New password cannot be the same as current password';
      } else {
        errorMessage = e.message ?? errorMessage;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(CustomSnackBar.failedSnackBar(title: errorMessage));
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.failedSnackBar(title: 'An unexpected error occurred'),
      );
    }
  }

  bool _isValidPassword(String text) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,16}$');
    return regex.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Password', isCenterTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              ClipOval(
                child:
                    _avatar.startsWith('assets/')
                        ? Image.asset(
                          _avatar,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                        : Image.file(
                          File(_avatar),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
              ),
              const SizedBox(height: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFormTitle(title: 'Current Password'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: currentPasswordContorller,
                    style: TextStyle(color: AppColors.white, fontSize: 14),
                    obscureText: _isObscure1,
                    decoration: InputDecoration(
                      hintText: 'Enter current password',
                      hintStyle: TextStyle(color: AppColors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure1 = !_isObscure1;
                          });
                        },
                        icon: Icon(
                          _isObscure1 ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.white,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 10,
                      ),

                      errorText: null,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 20,
                    child:
                        _currentPasswordErrorText != null
                            ? Text(
                              _currentPasswordErrorText!,
                              style: TextStyle(
                                color: AppColors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8,
                              ),
                            )
                            : const SizedBox.shrink(),
                  ),

                  CustomFormTitle(title: 'New Password'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: newPasswordContorller,
                    style: TextStyle(color: AppColors.white, fontSize: 14),
                    obscureText: _isObscure2,
                    decoration: InputDecoration(
                      hintText: 'Enter new password',
                      hintStyle: TextStyle(color: AppColors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 10,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure2 = !_isObscure2;
                          });
                        },
                        icon: Icon(
                          _isObscure2 ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.white,
                        ),
                      ),
                      errorText: null,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 20,
                    child:
                        _newPasswordErrorText != null
                            ? Text(
                              _newPasswordErrorText!,
                              style: TextStyle(
                                color: AppColors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8,
                              ),
                            )
                            : const SizedBox.shrink(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: YellowButton(
                      text: 'Change Password',
                      function: updatePassword,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
