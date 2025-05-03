import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/database/database_service.dart';
import 'package:uuid/uuid.dart';

class JobService extends DatabaseService {
  final String _uid = FirebaseAuth.instance.currentUser!.uid;
  final DatabaseService _dbService = DatabaseService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createJob({
    required String title,
    required String location,
    required String workType,
    required String payType,
    required String payRange,
    required String description,
    required String logo,
  }) async {
    String jobId = 'job_${Uuid().v4()}';
    final String collectionPath = 'Employer/$_uid/Job';

    final Map<String, dynamic> data = {
      'title': title,
      'location': location,
      'workType': workType,
      'payType': payType,
      'payRange': payRange,
      'description': description,
      'createdBy': _uid,
      'logo': logo,
      'jobId': jobId,
      'company': FirebaseAuth.instance.currentUser!.displayName,
    };

    await _dbService.create(
      collectionPath: collectionPath,
      docId: jobId,
      data: data,
    );
  }

  Future<List<Map<String, dynamic>>> readAllJob() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collectionGroup('Job').get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> readJobById() async {
    final String collectionPath = 'Employer/$_uid/Job';

    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection(collectionPath).get();

    final List<Map<String, dynamic>> jobs =
        snapshot.docs.map((doc) {
          return {'jobId': doc.id, ...doc.data() as Map<String, dynamic>};
        }).toList();

    return jobs;
  }

  Future<void> updateJob(String jobId, Map<String, dynamic> data) async {
    final String collectionPath = 'Employer/$_uid/Job';
    await _dbService.set(
      collectionPath: collectionPath,
      docId: jobId,
      data: data,
    );

    await _dbService.set(
      collectionPath: 'Employer/$_uid/JobApplied',
      docId: jobId,
      data: data,
    );

    final employees = await _firestore.collection('Employee').get();

    for (var emp in employees.docs) {
      final employeeId = emp.id;
      final savedJobDoc = await _dbService.read(
        collectionPath: 'Employee/$employeeId/SavedJob',
        docId: jobId,
      );

      final appliedJobDoc = await _dbService.read(
        collectionPath: 'Employee/$employeeId/JobApplied',
        docId: jobId,
      );

      if (savedJobDoc != null) {
        await _dbService.set(
          collectionPath: 'Employee/$employeeId/SavedJob',
          docId: jobId,
          data: data,
        );
      }

      if (appliedJobDoc != null) {
        await _dbService.set(
          collectionPath: 'Employee/$employeeId/JobApplied',
          docId: jobId,
          data: data,
        );
      }
    }
  }

  Future<void> applyJob({
    required Map<String, dynamic> profile,
    required Map<String, dynamic> job,
    required String avatar,
  }) async {
    final String employerId = job['createdBy'];

    final Map<String, dynamic> data = {
      'profile': profile,
      'job': job,
      'employee': FirebaseAuth.instance.currentUser!.displayName,
      'email': FirebaseAuth.instance.currentUser!.email,
      'avatar': avatar,
    };

    await _dbService.create(
      collectionPath: 'Employer/$employerId/JobApplied',
      docId: job['jobId'],
      data: data,
    );

    await _dbService.create(
      collectionPath: 'Employee/$_uid/JobApplied',
      docId: job['jobId'],
      data: data,
    );
  }

  Future<void> saveJob(Map<String, dynamic> job) async {
    final String collectionPath = 'Employee/$_uid/SavedJob';
    final String jobId = job['jobId'];
    await _dbService.create(
      collectionPath: collectionPath,
      docId: jobId,
      data: job,
    );
  }

  Future<List<Map<String, dynamic>>> readSavedJob() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('Employee/$_uid/SavedJob')
            .get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> readAppliedJobByEmployee() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('Employee/$_uid/JobApplied')
            .get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> readAppliedJobByEmployer() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('Employer/$_uid/JobApplied')
            .get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> deleteSavedJob(String jobId) async {
    final String collectionPath = 'Employee/$_uid/SavedJob';
    await _dbService.delete(collectionPath: collectionPath, docId: jobId);
  }

  Future<void> deleteAppliedJob(String jobId) async {
    await _dbService.delete(
      collectionPath: 'Employee/$_uid/JobApplied',
      docId: jobId,
    );

    final employers = await _firestore.collection('Employer').get();

    for (var emp in employers.docs) {
      final employerId = emp.id;
      final appliedJobDoc = await _dbService.read(
        collectionPath: 'Employer/$employerId/JobApplied',
        docId: jobId,
      );

      if (appliedJobDoc != null) {
        await _dbService.delete(
          collectionPath: 'Employer/$employerId/JobApplied',
          docId: jobId,
        );
      }
    }
  }

  Future<void> deleteJob(String jobId) async {
    final String collectionPath = 'Employer/$_uid/Job';
    await _dbService.delete(collectionPath: collectionPath, docId: jobId);

    final employees = await _firestore.collection('Employee').get();

    for (var emp in employees.docs) {
      final employeeId = emp.id;
      final savedJobDoc = await _dbService.read(
        collectionPath: 'Employee/$employeeId/SavedJob',
        docId: jobId,
      );

      final appliedJobDoc = await _dbService.read(
        collectionPath: 'Employee/$employeeId/JobApplied',
        docId: jobId,
      );

      if (savedJobDoc != null) {
        await _dbService.delete(
          collectionPath: 'Employee/$employeeId/SavedJob',
          docId: jobId,
        );
      }

      if (appliedJobDoc != null) {
        await _dbService.delete(
          collectionPath: 'Employee/$employeeId/JobApplied',
          docId: jobId,
        );
      }
    }

    final employers = await _firestore.collection('Employer').get();

    for (var empr in employers.docs) {
      final employerId = empr.id;
      final appliedJobDoc = await _dbService.read(
        collectionPath: 'Employer/$employerId/JobApplied',
        docId: jobId,
      );

      if (appliedJobDoc != null) {
        await _dbService.delete(
          collectionPath: 'Employer/$employerId/JobApplied',
          docId: jobId,
        );
      }
    }
  }
}
