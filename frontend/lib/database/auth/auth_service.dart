import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createAccount({
    required String name,
    required String email,
    required String phoneNumber,
    required String location,
    required String password,
    required bool isEmployee,
  }) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    String uid = userCredential.user!.uid;

    final user = {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'location': location,
      'role' : isEmployee ? 'Employee' : 'Employer',
      'avatar' : 'assets/images/userAvatar.png',
      'createdAt': DateTime.now().toIso8601String(),
    };

    await firestore.collection('User').doc(uid).set(user);

    if(isEmployee) {
      await firestore.collection('Employee').doc(uid).set({
        'user': user,
        'profile': null,
        'jobApply': null,
        'jobSaved': null
      });
    } else {
      await firestore.collection('Employer').doc(uid).set({
        'user': user,
        'job': null
      });
    }

    return userCredential;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUsername({required String username}) async {
    await currentUser!.updateDisplayName(username);
  }
}
