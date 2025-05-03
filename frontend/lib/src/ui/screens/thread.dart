import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/popupForm/popup_form.dart';
import 'package:frontend/src/ui/widgets/textfield/comment.dart';
import 'package:frontend/src/ui/widgets/title.dart';

enum Menu { edit, delete }

class ThreadScreen extends StatelessWidget {
  final commentController = TextEditingController();
  ThreadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Thread',
        isCenterTitle: true,
        actions: [
          PopupMenuButton<Menu>(
            onSelected: (value) {
              switch (value) {
                case Menu.edit:
                  PopupForm.show(
                    context,
                    'Comment',
                    true,
                    Column(
                      children: [
                        SizedBox(height: 30),
                        CommentTextField(commentController: commentController),
                      ],
                    ),
                  );
                  break;

                case Menu.delete:
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: Menu.edit,
                  child: Text('Edit', style: TextStyle(color: AppColors.white)),
                ),
                PopupMenuItem(
                  value: Menu.delete,
                  child: Text('Delete', style: TextStyle(color: AppColors.red)),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            SizedBox(height: 10),
            _buildThreadComment(),
            const SizedBox(height: 15),
            const Divider(color: AppColors.white),
            const SizedBox(height: 15),
            CustomTitle(title: 'Replies', isCenterTitle: true),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: CommentCard(),
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                PopupForm.show(
                  context,
                  'Reply to thread',
                  true,
                  Column(
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

Widget _buildThreadComment() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundImage: AssetImage("assets/images/userAvatar.png"),
            backgroundColor: Colors.transparent,
          ),
          SizedBox(width: 10),
          Text(
            'Ivan',
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
        "Do companies really choose fresh graduates based on their university? I graduated from UUM, and my friend from UiTM Shah Alam. We both studied accounting and have a CGPA above 3.3. We applied to the same companies because we planned to live together once we got a job. Unfortunately, I noticed that many companies rejected my application but accepted hers, even though our resumes weren’t that different.",
        style: TextStyle(color: AppColors.white, fontSize: 14),
      ),
      SizedBox(height: 10),
    ],
  );
}

class CommentCard extends StatefulWidget {
  const CommentCard({super.key});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundImage: AssetImage("assets/images/userAvatar.png"),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(width: 10),
            Text(
              'Kyle',
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ThreadScreen()),
            );
          },
          child: Text(
            "I'm not speaking on anyone's behalf, but this is just based on my own experience. Ever since I entered the working world, I’ve noticed that a lot of UiTM graduates get hired. I can say that almost every company I’ve joined has UiTM graduates for sure, and most of them are from UiTM Shah Alam. At first, I thought it might be because there are just a lot of UiTM graduates, but then again, there are many graduates from other universities too, so why don’t we hear about them as much? So, I feel like, secretly, yes… UiTM graduates are quite popular among employers. Why? Maybe because of a good reputation among them.",
            style: TextStyle(color: AppColors.white, fontSize: 13),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isLiked = !isLiked;
                });
              },
              child:
                  isLiked
                      ? Icon(Icons.favorite, color: AppColors.red, size: 18)
                      : Icon(
                        Icons.favorite_border,
                        color: AppColors.white,
                        size: 18,
                      ),
            ),
            SizedBox(width: 5),
            Text('120', style: TextStyle(color: AppColors.white, fontSize: 14)),
            SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ThreadScreen()),
                // );
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
                    '35',
                    style: TextStyle(color: AppColors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
