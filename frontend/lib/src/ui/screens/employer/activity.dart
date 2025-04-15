import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/screens/employer/application_details.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';

class EmployerActivityScreen extends StatelessWidget {
  const EmployerActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Activity', isCenterTitle: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              _jobCard(context, 'William', 'Full Stack Web Developer'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _jobCard(BuildContext context, String title, String venue) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ApplicationDetailsScreen()),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 3, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColors.grey,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 55,
                height: 55,
                child: Image.asset(
                  'assets/images/userAvatar.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'William',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      'Full-Stack Web Developer',
                      style: TextStyle(fontSize: 13, color: AppColors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
