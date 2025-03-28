import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/job_card.dart';
import 'package:frontend/src/ui/widgets/job_card_applied.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  bool isSavedSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Activity', isCenterTitle: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isSavedSelected = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSavedSelected ? AppColors.yellow : AppColors.white,
                      padding: EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Saved',
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isSavedSelected = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSavedSelected ? AppColors.white : AppColors.yellow,
                      padding: EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Applied',
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return isSavedSelected
                      ? JobCard(
                        title: "Full-Stack Web Developer",
                        company: "Shopee",
                        location: "Mid valley, Kuala Lumpur",
                        logoPath: "assets/images/shopee.jpg",
                        isShowBookmark: true,
                      )
                      : JobCardApplied(
                        title: "Full-Stack Web Developer",
                        company: "Shopee",
                        location: "Mid valley, Kuala Lumpur",
                        logoPath: "assets/images/shopee.jpg",
                        formTitle: 'View Application',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 30),
                            Text(
                              'Full-Stack Web Developer',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              'Shopee',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              'Kuala Lumpur',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              'RM 5,000 - RM 7,000 per month',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 40),
                            Text(
                              'Submitted',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity(vertical: -4),
                              leading: Icon(
                                Icons.person_outline_rounded,
                                size: 25,
                              ),
                              title: Text(
                                'Web Dev Profile',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.white,
                                size: 19,
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity(vertical: -4),
                              leading: Icon(
                                Icons.insert_drive_file_outlined,
                                size: 25,
                              ),
                              title: Text(
                                'Cover Letter.pdf',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.white,
                                size: 19,
                              ),
                            ),
                            SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.darkRed,
                                padding: EdgeInsets.symmetric(vertical: 11),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
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
