import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/database/database_service.dart';
import 'package:uuid/uuid.dart';

class JobService extends DatabaseService {
  final String? username = FirebaseAuth.instance.currentUser!.displayName;
  final String _uid = FirebaseAuth.instance.currentUser!.uid;
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

    await create(collectionPath: collectionPath, docId: jobId, data: data);
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
          return {...doc.data() as Map<String, dynamic>};
        }).toList();

    return jobs;
  }

  Future<void> updateJob(String jobId, Map<String, dynamic> data) async {
    final String collectionPath = 'Employer/$_uid/Job';
    await set(collectionPath: collectionPath, docId: jobId, data: data);

    final employees = await _firestore.collection('Employee').get();

    for (var emp in employees.docs) {
      final employeeId = emp.id;
      final savedJobDoc = await read(
        collectionPath: 'Employee/$employeeId/SavedJob',
        docId: jobId,
      );

      if (savedJobDoc != null) {
        await set(
          collectionPath: 'Employee/$employeeId/SavedJob',
          docId: jobId,
          data: data,
        );
      }
    }

    final applications = await _firestore.collection('Application').get();
    for (var app in applications.docs) {
      final appData = app.data();
      final job = appData['job'];

      if (job != null && job['id'] == jobId) {
        final updatedAppData = {...appData, 'job': data};

        await _firestore
            .collection('Application')
            .doc(app.id)
            .set(updatedAppData);
      }
    }
  }

  Future<void> applyJob({
    required Map<String, dynamic> profile,
    required Map<String, dynamic> job,
    required String avatar,
  }) async {
    String applicationId = 'application_${Uuid().v4()}';

    final Map<String, dynamic> data = {
      'applicationId': applicationId,
      'profile': profile,
      'job': job,
      'employer': job['createdBy'],
      'employee': _uid,
      'employeeName': username,
      'email': FirebaseAuth.instance.currentUser!.email,
      'avatar': avatar,
      'isAccept': null,
    };

    await create(
      collectionPath: 'Application',
      docId: applicationId,
      data: data,
    );
  }

  Future<void> saveJob(Map<String, dynamic> job) async {
    final String collectionPath = 'Employee/$_uid/SavedJob';
    final String jobId = job['jobId'];
    await create(collectionPath: collectionPath, docId: jobId, data: job);
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

  Future<List<Map<String, dynamic>>> readApplication() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Application').get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .where((data) => data['employee'] == _uid || data['employer'] == _uid)
        .toList();
  }

  Future<void> deleteSavedJob(String jobId) async {
    final String collectionPath = 'Employee/$_uid/SavedJob';
    await delete(collectionPath: collectionPath, docId: jobId);
  }

  Future<void> deleteApplication({required String applicationId}) async {
    await delete(collectionPath: 'Application', docId: applicationId);
  }

  Future<void> deleteJob(String jobId) async {
    final String collectionPath = 'Employer/$_uid/Job';
    await delete(collectionPath: collectionPath, docId: jobId);

    final employees = await _firestore.collection('Employee').get();

    for (var emp in employees.docs) {
      final employeeId = emp.id;
      final savedJobDoc = await read(
        collectionPath: 'Employee/$employeeId/SavedJob',
        docId: jobId,
      );

      final appliedJobDoc = await read(
        collectionPath: 'Employee/$employeeId/JobApplied',
        docId: jobId,
      );

      if (savedJobDoc != null) {
        await delete(
          collectionPath: 'Employee/$employeeId/SavedJob',
          docId: jobId,
        );
      }

      if (appliedJobDoc != null) {
        await delete(
          collectionPath: 'Employee/$employeeId/JobApplied',
          docId: jobId,
        );
      }
    }

    final employers = await _firestore.collection('Employer').get();

    for (var empr in employers.docs) {
      final employerId = empr.id;
      final appliedJobDoc = await read(
        collectionPath: 'Employer/$employerId/JobApplied',
        docId: jobId,
      );

      if (appliedJobDoc != null) {
        await delete(
          collectionPath: 'Employer/$employerId/JobApplied',
          docId: jobId,
        );
      }
    }
  }

  Future<void> acceptApplication({required String applicationId}) async {
    await set(
      collectionPath: 'Application',
      docId: applicationId,
      data: {'isAccept': true, 'employer': _uid},
    );
  }

  Future<void> rejectApplication({required String applicationId}) async {
    await set(
      collectionPath: 'Application',
      docId: applicationId,
      data: {'isAccept': false},
    );
  }

  Future<List<Map<String, dynamic>>> readAcceptedApplication() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Application').get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .where(
          (data) =>
              (data['employee'] == _uid || data['employer'] == _uid) &&
              data['isAccept'] == true,
        )
        .toList();
  }
}
