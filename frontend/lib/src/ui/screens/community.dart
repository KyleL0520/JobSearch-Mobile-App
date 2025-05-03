import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/screens/thread.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/popupForm/popup_form.dart';
import 'package:frontend/src/ui/widgets/textfield/comment.dart';

class CommunityScreen extends StatelessWidget {
  final commentController = TextEditingController();
  CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Community', isCenterTitle: false),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
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
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: CommunityCard(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommunityCard extends StatefulWidget {
  const CommunityCard({super.key});

  @override
  State<CommunityCard> createState() => _CommunityCardState();
}

class _CommunityCardState extends State<CommunityCard> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThreadScreen()),
              );
            },
            child: Text(
              "Do companies really choose fresh graduates based on their university? I graduated from UUM, and my friend from UiTM Shah Alam. We both studied accounting and have a CGPA above 3.3. We applied to the same companies ...",
              style: TextStyle(color: AppColors.white, fontSize: 13),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
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
              Text(
                '120',
                style: TextStyle(color: AppColors.white, fontSize: 14),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThreadScreen()),
                  );
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
      ),
    );
  }
}
