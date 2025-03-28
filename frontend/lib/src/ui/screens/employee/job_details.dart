import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/popupForm/cover_letter.dart';
import 'package:frontend/src/ui/widgets/popupForm/popup_form.dart';
import 'package:frontend/src/ui/widgets/popupForm/profile_option.dart';

class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Job Details', isCenterTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 17),
              Center(
                child: Image.asset(
                  'assets/images/shopee.jpg',
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Full-Stack Web Developer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Shopee',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: AppColors.white,
                    size: 26,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Kuala Lumpur',
                    style: TextStyle(fontSize: 15, color: AppColors.white),
                  ),
                ],
              ),
              SizedBox(height: 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.access_time, color: AppColors.white, size: 26),
                  SizedBox(width: 10),
                  Text(
                    'Full Time',
                    style: TextStyle(fontSize: 15, color: AppColors.white),
                  ),
                ],
              ),
              SizedBox(height: 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.attach_money, color: AppColors.white, size: 26),
                  SizedBox(width: 10),
                  Text(
                    'RM 5,000 - RM 7,000 per month',
                    style: TextStyle(fontSize: 15, color: AppColors.white),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'EMAX Beauté International is a leading beauty & wellness group specialising in skincare, aesthetics, slimming, and hair care. We are passionate about empowering confidence through science-backed treatments and cutting-edge innovations. As we expand our digital-first approach, we’re looking for a Full-Stack Developer to build, optimise, and scale our e-commerce, booking, and digital ecosystem across multiple brands. This is an exciting opportunity to shape the future of beauty, wellness, and retail tech while enjoying the stability and resources of an industry leader. EMAX Beauté International is a leading beauty & wellness group specialising in skincare, aesthetics, slimming, and hair care. We are passionate about empowering confidence through science-backed treatments and cutting-edge innovations. As we expand our digital-first approach, we’re looking for a Full-Stack Developer to build, optimise, and scale our e-commerce, booking, and digital ecosystem across multiple brands. This is an exciting opportunity to shape the future of beauty, wellness, and retail tech while enjoying the stability and resources of an industry leader.',
                      style: TextStyle(fontSize: 15, color: AppColors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        padding: EdgeInsets.symmetric(vertical: 11),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Save',
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
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return PopupForm(
                              title: 'Upload Profile',
                              btnSubmit: true,
                              child: Column(
                                children: [
                                  SizedBox(height: 30),
                                  ProfileOption(),
                                  SizedBox(height: 30),
                                  CoverLetter(),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        padding: EdgeInsets.symmetric(vertical: 11),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Apply',
                        style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
