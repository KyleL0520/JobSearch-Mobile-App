import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend/database/service/community.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/inputField/comment.dart';
import 'package:frontend/src/ui/widgets/popupForm/popup_form.dart';
import 'package:frontend/src/ui/widgets/snackbar/snack_bar.dart';
import 'package:frontend/src/ui/widgets/title/title.dart';

enum Menu { edit, delete }

class ThreadScreen extends StatefulWidget {
  final Map<String, dynamic> comment;
  const ThreadScreen({super.key, required this.comment});

  @override
  State<ThreadScreen> createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  final String _uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<Map<String, dynamic>>> replysFuture;
  final commentController = TextEditingController();
  final communityService = CommunityService();
  Map<String, bool> likedComments = {};

  String originalComment = '';

  @override
  void initState() {
    super.initState();
    replysFuture = communityService
        .readReply(commentId: widget.comment['commentId'])
        .then((replys) async {
          await loadLikeStates(replys);
          return replys;
        });
    setState(() {
      originalComment = widget.comment['comment'] ?? '';
    });
  }

  void refreshComments() {
    setState(() {
      replysFuture = communityService
          .readReply(commentId: widget.comment['commentId'])
          .then((replys) async {
            await loadLikeStates(replys);
            return replys;
          });
    });
  }

  void _clearCareerHistoryForm() {
    commentController.clear();
  }

  Future<void> loadLikeStates(List<Map<String, dynamic>> comments) async {
    for (var comment in comments) {
      final commentId = comment['commentId'];
      final isLiked = await isReplyLiked(commentId);
      likedComments[commentId] = isLiked;
    }
    setState(() {});
  }

  Future<bool> isReplyLiked(String commentId) async {
    final data = await communityService.readCommentById(commentId: commentId);

    final List<dynamic> likes = data['like'] ?? [];

    return likes.contains(_uid);
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

  void editThread() async {
    final String currentComment = commentController.text.trim();

    if (currentComment == '' || currentComment.isEmpty) {
      return;
    }

    if (currentComment == originalComment) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(CustomSnackBar.failedSnackBar(title: 'No changes update'));
      return;
    }

    try {
      await communityService.updateThread(
        commentId: widget.comment['commentId'],
        comment: currentComment,
      );

      setState(() {
        widget.comment['comment'] = currentComment;
        originalComment = currentComment;
      });

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.successSnackBar(title: 'Thread updated successfully'),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.failedSnackBar(title: 'Thread failed to update'),
      );
    }
    Navigator.pop(context);
    refreshComments();
  }

  void deleteThread() async {
    bool confirmDelete = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Confirm Deletion'),
            content: Text('Are you sure you want to delete this thread?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.yellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );

    if (confirmDelete == true) {
      try {
        await communityService.removeThread(
          commentId: widget.comment['commentId'],
        );
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.successSnackBar(title: 'Thread deleted successfully'),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.failedSnackBar(title: 'Thread failed to delete'),
        );
      }
    }
    Navigator.pop(context);
    refreshComments();
  }

  void submitReply(String replyId) async {
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
      final String comment = commentController.text.trim();

      await communityService.reply(
        email: email,
        username: username,
        avatar: avatar,
        comment: comment,
        role: role,
        replyId: replyId,
        threadId: widget.comment['commentId'],
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

  void deleteReply(String commentId, String threadId, String replyId) async {
    try {
      await communityService.removeReply(
        commentId: commentId,
        threadId: threadId,
        replyId: replyId,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.failedSnackBar(title: 'Failed to delete reply'),
      );
      print('Delete failed: $e');
    }
    refreshComments();
  }

  Future<String?> readReplyName(String replyId) async {
    final snapshot = await communityService.read(
      collectionPath: 'Comment',
      docId: replyId,
    );

    if (snapshot != null && snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return data['username'];
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Thread',
        isCenterTitle: true,
        actions:
            widget.comment['userId'] == _uid
                ? [
                  PopupMenuButton<Menu>(
                    onSelected: (value) {
                      switch (value) {
                        case Menu.edit:
                          commentController.text =
                              widget.comment['comment'] ?? '';
                          PopupForm.show(
                            context: context,
                            title: 'Comment',
                            btnSubmit: true,
                            function: editThread,
                            child: Column(
                              children: [
                                SizedBox(height: 30),
                                CommentTextField(
                                  commentController: commentController,
                                ),
                              ],
                            ),
                          );
                          break;
                        case Menu.delete:
                          deleteThread();
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: Menu.edit,
                          child: Text(
                            'Edit',
                            style: TextStyle(color: AppColors.white),
                          ),
                        ),
                        PopupMenuItem(
                          value: Menu.delete,
                          child: Text(
                            'Delete',
                            style: TextStyle(color: AppColors.red),
                          ),
                        ),
                      ];
                    },
                  ),
                ]
                : [],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child:
                          widget.comment['avatar'].startsWith('assets/')
                              ? Image.asset(
                                widget.comment['avatar'],
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              )
                              : Image.file(
                                File(widget.comment['avatar']),
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.comment['username'],
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  widget.comment['comment'],
                  style: TextStyle(color: AppColors.white, fontSize: 14),
                ),
                SizedBox(height: 10),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(color: AppColors.white),
            const SizedBox(height: 15),
            CustomTitle(title: 'Replies', isCenterTitle: true),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: replysFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print('Error in threadFuture: ${snapshot.error}');
                    return Center(child: Text('Something went wrong'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return SizedBox();
                  } else {
                    final replys = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: replys.length,
                      itemBuilder: (context, index) {
                        final reply = replys[index];
                        final commentId = reply['commentId'];
                        bool isLiked = likedComments[commentId] ?? false;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: const BehindMotion(),
                              children: [
                                SlidableAction(
                                  onPressed:
                                      (context) => deleteReply(
                                        reply['commentId'],
                                        reply['threadId'],
                                        reply['replyId'],
                                      ),
                                  backgroundColor: AppColors.red,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    ClipOval(
                                      child:
                                          reply['avatar'].startsWith('assets/')
                                              ? Image.asset(
                                                reply['avatar'],
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.cover,
                                              )
                                              : Image.file(
                                                File(reply['avatar']),
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.cover,
                                              ),
                                    ),
                                    SizedBox(width: 10),
                                    FutureBuilder<String?>(
                                      future:
                                          reply['replyId'] !=
                                                  widget.comment['commentId']
                                              ? readReplyName(reply['replyId'])
                                              : Future.value(reply['username']),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Text(
                                            'Replied to ...',
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        } else if (snapshot.hasError ||
                                            !snapshot.hasData) {
                                          return Text(
                                            'Replied to Unknown',
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        } else {
                                          return Text(
                                            reply['replyId'] !=
                                                    widget.comment['commentId']
                                                ? "Replied to ${snapshot.data}"
                                                : "${snapshot.data}",
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),

                                SizedBox(height: 10),
                                Text(
                                  reply['comment'],
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 14,
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
                                          reply['like'].add(_uid);
                                        } else {
                                          reply['like'].remove(_uid);
                                        }

                                        await communityService
                                            .toggleLikeComment(
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
                                      reply['like'].length.toString(),
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            PopupForm.show(
                                              context: context,
                                              title:
                                                  "Reply to ${reply['username']}",
                                              btnSubmit: true,
                                              function:
                                                  () => submitReply(
                                                    reply['commentId'],
                                                  ),
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 30),
                                                  CommentTextField(
                                                    commentController:
                                                        commentController,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.chat_bubble_outline,
                                            color: AppColors.white,
                                            size: 18,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          reply['reply'].toString(),
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                PopupForm.show(
                  context: context,
                  title: 'Reply to thread',
                  btnSubmit: true,
                  function: () => submitReply(widget.comment['commentId']),
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      CommentTextField(commentController: commentController),
                    ],
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.white, width: 1),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.transparent,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Reply to thread',
                    style: TextStyle(color: AppColors.white),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
