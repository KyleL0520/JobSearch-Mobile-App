import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/database/database_service.dart';
import 'package:uuid/uuid.dart';

class CommunityService extends DatabaseService {
  final String _uid = FirebaseAuth.instance.currentUser!.uid;
  final String collectionPath = 'Comment';

  Future<void> createThread({
    required String email,
    required String username,
    required String avatar,
    required String comment,
    required String role,
  }) async {
    String commentId = 'comment_${Uuid().v4()}';

    final Map<String, dynamic> data = {
      'username': username,
      'userId': _uid,
      'role': role,
      'avatar': avatar,
      'comment': comment,
      'like': [],
      'reply': 0,
      'commentId': commentId,
      'replyId': null,
      'threadId': null,
      'isThread': true,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await create(collectionPath: collectionPath, docId: commentId, data: data);
  }

  Future<List<Map<String, dynamic>>> readAllComment() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection('Comment')
            .where('isThread', isEqualTo: true)
            .orderBy('timestamp', descending: true)
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['commentId'] = doc.id;
      return data;
    }).toList();
  }

  Future<Map<String, dynamic>> readCommentById({
    required String commentId,
  }) async {
    final DocumentSnapshot? doc = await read(
      collectionPath: collectionPath,
      docId: commentId,
    );

    if (doc == null || !doc.exists || doc.data() == null) {
      throw Exception('Comment not found');
    }

    return doc.data() as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> readReply({
    required String commentId,
  }) async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection(collectionPath)
            .where('threadId', isEqualTo: commentId)
            .orderBy('timestamp', descending: true)
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['commentId'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> updateThread({
    required String commentId,
    required String comment,
  }) async {
    await set(
      collectionPath: collectionPath,
      docId: commentId,
      data: {'comment': comment},
    );
  }

  Future<void> reply({
    required email,
    required username,
    required avatar,
    required comment,
    required role,
    required replyId,
    required threadId,
  }) async {
    String commentId = 'comment_${Uuid().v4()}';

    final Map<String, dynamic> data = {
      'username': username,
      'userId': _uid,
      'role': role,
      'avatar': avatar,
      'comment': comment,
      'like': [],
      'reply': 0,
      'commentId': commentId,
      'replyId': replyId,
      'threadId': threadId,
      'isThread': false,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await create(collectionPath: collectionPath, docId: commentId, data: data);

    await set(
      collectionPath: collectionPath,
      docId: replyId,
      data: {'reply': FieldValue.increment(1)},
    );

    if (replyId != threadId) {
      await set(
        collectionPath: collectionPath,
        docId: threadId,
        data: {'reply': FieldValue.increment(1)},
      );
    }
  }

  Future<void> toggleLikeComment(String commentId, bool like) async {
    final ref = FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(commentId);
    await ref.update({
      'like':
          like ? FieldValue.arrayUnion([_uid]) : FieldValue.arrayRemove([_uid]),
    });
  }

  Future<void> removeThread({required String commentId}) async {
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection(collectionPath)
            .where('threadId', isEqualTo: commentId)
            .get();
    for (var doc in querySnapshot.docs) {
      await delete(collectionPath: collectionPath, docId: doc.id);
    }
    await delete(collectionPath: collectionPath, docId: commentId);
  }

  Future<void> removeReply({
    required String commentId,
    required String replyId,
    required String threadId,
  }) async {
    await delete(collectionPath: collectionPath, docId: commentId);
    await set(
      collectionPath: collectionPath,
      docId: threadId,
      data: {'reply': FieldValue.increment(-1)},
    );

    if (replyId != threadId) {
      await set(
        collectionPath: collectionPath,
        docId: replyId,
        data: {'reply': FieldValue.increment(-1)},
      );
    }
  }
}
