import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/database/database_service.dart';
import 'package:uuid/uuid.dart';

class ProfileService extends DatabaseService {
  final String _uid = FirebaseAuth.instance.currentUser!.uid;
  final DatabaseService _dbService = DatabaseService();

  Future<void> createProfile({
    required String title,
    required List<Map<String, dynamic>> careerHistorys,
    required List<Map<String, dynamic>> educations,
    required List<Map<String, dynamic>> skills,
    required List<Map<String, dynamic>> languages,
  }) async {
    String profileId = 'profile_${Uuid().v4()}';
    final String collectionPath = 'Employee/$_uid/Profile';

    final Map<String, dynamic> data = {
      'profileId': profileId,
      'title': title,
      'careerHistorys': careerHistorys,
      'educations': educations,
      'skills': skills,
      'languages': languages,
    };

    await _dbService.create(
      collectionPath: collectionPath,
      docId: profileId,
      data: data,
    );
  }

  Future<List<Map<String, dynamic>>> readAllProfile() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('Employee/$_uid/Profile')
            .get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<DocumentSnapshot?> readProfileById({required String profileId}) async {
    final String collectionPath = 'Employee/$_uid/Profile';
    final snapshot = await _dbService.read(
      collectionPath: collectionPath,
      docId: profileId,
    );

    if (snapshot!.exists) {
      return snapshot;
    } else {
      return null;
    }
  }

  Future<void> updateProfile({
    required String profileId,
    required Map<String, dynamic> data,
  }) async {
    final String collectionPath = 'Employee/$_uid/Profile';
    await _dbService.set(
      collectionPath: collectionPath,
      docId: profileId,
      data: data,
    );
  }

  Future<void> deleteProfile({required String profileId}) async {
    final String collectionPath = 'Employee/$_uid/Profile';
    await _dbService.delete(collectionPath: collectionPath, docId: profileId);
  }
}
