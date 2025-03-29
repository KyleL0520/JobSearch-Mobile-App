import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/screens/community.dart';
import 'package:frontend/src/ui/screens/employee/activity.dart';
import 'package:frontend/src/ui/screens/employee/home.dart';
import 'package:frontend/src/ui/screens/employee/profile.dart';

class EmployeeMainScreen extends StatefulWidget {
  const EmployeeMainScreen({super.key});

  @override
  State<EmployeeMainScreen> createState() => _EmployeeMainScreenState();
}

class _EmployeeMainScreenState extends State<EmployeeMainScreen> {
  Menus currentIndex = Menus.home;

  final screens = [
    EmployeeHomeScreen(),
    EmployeeActivityScreen(),
    CommunityScreen(),
    EmployeeProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex.index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.blue,
        selectedItemColor: AppColors.yellow,
        unselectedItemColor: AppColors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 12, color: AppColors.yellow),
        unselectedLabelStyle: TextStyle(fontSize: 12, color: AppColors.white),
        currentIndex: currentIndex.index,
        onTap: (int newIndex) {
          setState(() {
            currentIndex = Menus.values[newIndex];
          });
        },
        items: [
          _buildNavItem('assets/icons/home.svg', 'Home', Menus.home),
          _buildNavItem(
            'assets/icons/bookmark.svg',
            'Activity',
            Menus.activity,
          ),
          _buildNavItem('assets/icons/chat.svg', 'Community', Menus.community),
          _buildNavItem('assets/icons/person.svg', 'Profile', Menus.profile),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    String assetPath,
    String label,
    Menus menu,
  ) {
    bool isSelected = currentIndex == menu;
    return BottomNavigationBarItem(
      label: label,
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: SvgPicture.asset(
          assetPath,
          width: 28,
          height: 28,
          colorFilter: ColorFilter.mode(
            isSelected ? AppColors.yellow : AppColors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

enum Menus { home, activity, community, profile }
