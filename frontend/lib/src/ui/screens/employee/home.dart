import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/job_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'JobSearch', isCenterTitle: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 7,
                ),
                suffixIcon: Icon(Icons.search, color: AppColors.black),
                hintText: 'Search',
                hintStyle: TextStyle(color: AppColors.black),
                filled: true,
                fillColor: AppColors.grey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return JobCard(
                    title: "Full-Stack Web Developer",
                    company: "Shopee",
                    location: "Mid valley, Kuala Lumpur",
                    logoPath: "assets/images/shopee.jpg",
                    isShowBookmark: true,
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
