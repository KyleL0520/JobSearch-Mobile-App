import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/service/community.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/screens/thread.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/inputField/comment.dart';
import 'package:frontend/src/ui/widgets/popupForm/popup_form.dart';
import 'package:frontend/src/ui/widgets/snackbar/snack_bar.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final String _uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final commentController = TextEditingController();
  final communityService = CommunityService();
  Map<String, bool> likedComments = {};

  late Future<List<Map<String, dynamic>>> communityFuture;

  void _clearCareerHistoryForm() {
    commentController.clear();
  }

  Future<void> loadLikeStates(List<Map<String, dynamic>> comments) async {
    for (var comment in comments) {
      final commentId = comment['commentId'];
      final isLiked = await isCommentLiked(commentId);
      likedComments[commentId] = isLiked;
    }
    setState(() {});
  }

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final User? user = _auth.currentUser;
    if (user == null) return null;

    final DocumentSnapshot employeeDoc =
        await _firestore.collection('Employee').doc(_uid).get();

    if (employeeDoc.exists) {
      return employeeDoc.data() as Map<String, dynamic>;
    }
    final DocumentSnapshot employerDoc =
        await _firestore.collection('Employer').doc(_uid).get();

    if (employerDoc.exists) {
      return employerDoc.data() as Map<String, dynamic>;
    }

    return null;
  }

  void submit() async {
    final String currentComment = commentController.text.trim();

    if (currentComment == '' || currentComment.isEmpty) {
      return;
    }

    try {
      final userData = await getCurrentUserData();
      if (userData == null) {
        print('User data not found');
        return;
      }

      final String email = userData['email'];
      final String username = userData['name'];
      final String avatar = userData['avatar'];
      final String role = userData['role'];
      final String comment = currentComment;

      await communityService.createThread(
        email: email,
        username: username,
        avatar: avatar,
        comment: comment,
        role: role,
      );
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.successSnackBar(title: 'Comment created successfully'),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.failedSnackBar(title: 'Comment failed to create'),
      );
      print('Created failed : $e');
    }
    Navigator.pop(context);
    _clearCareerHistoryForm();
    refreshComments();
  }

  @override
  void initState() {
    super.initState();
    communityFuture = communityService.readAllComment().then((comments) async {
      await loadLikeStates(comments);
      return comments;
    });
  }

  void refreshComments() {
    setState(() {
      communityFuture = communityService.readAllComment().then((
        comments,
      ) async {
        await loadLikeStates(comments);
        return comments;
      });
    });
  }

  Future<bool> isCommentLiked(String commentId) async {
    final data = await communityService.readCommentById(commentId: commentId);

    final List<dynamic> likes = data['like'] ?? [];

    return likes.contains(_uid);
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Community', isCenterTitle: false),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          PopupForm.show(
            context: context,
            title: 'Comment',
            btnSubmit: true,
            function: submit,
            child: Column(
              children: [
                SizedBox(height: 30),
                CommentTextField(commentController: commentController),
              ],
            ),
          );
        },
        backgroundColor: AppColors.yellow,
        child: Icon(Icons.add, color: AppColors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: communityFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print('Error in communityFuture: ${snapshot.error}');
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
                            'There are no comment yet',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  } else {
                    final comments = snapshot.data!;
                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        final commentId = comment['commentId'];
                        bool isLiked = likedComments[commentId] ?? false;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 3,
                          ),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.white),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  ClipOval(
                                    child:
                                        comment['avatar'].startsWith('assets/')
                                            ? Image.asset(
                                              comment['avatar'],
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                            )
                                            : Image.file(
                                              File(comment['avatar']),
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                            ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    comment['username'],
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              ThreadScreen(comment: comment),
                                    ),
                                  );
                                  refreshComments();
                                },
                                child: Text(
                                  comment['comment'],
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 13,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      final newIsLiked = !isLiked;
                                      if (newIsLiked) {
                                        comment['like'].add(_uid);
                                      } else {
                                        comment['like'].remove(_uid);
                                      }

                                      await communityService.toggleLikeComment(
                                        commentId,
                                        newIsLiked,
                                      );

                                      setState(() {
                                        likedComments[commentId] = newIsLiked;
                                      });
                                    },
                                    icon:
                                        isLiked
                                            ? Icon(
                                              Icons.favorite,
                                              color: AppColors.red,
                                              size: 18,
                                            )
                                            : Icon(
                                              Icons.favorite_border,
                                              color: AppColors.white,
                                              size: 18,
                                            ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    comment['like'].length.toString(),
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  GestureDetector(
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => ThreadScreen(
                                                comment: comment,
                                              ),
                                        ),
                                      );
                                      refreshComments();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.chat_bubble_outline,
                                          color: AppColors.white,
                                          size: 18,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          comment['reply'].toString(),
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
