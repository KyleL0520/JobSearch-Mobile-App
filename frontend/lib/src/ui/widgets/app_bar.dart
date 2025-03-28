import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/title.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool isCenterTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    required this.isCenterTitle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, left: 10.0, right: 10.0),
      child:
          isCenterTitle
              ? AppBar(
                backgroundColor: AppColors.blue,
                elevation: 0,
                automaticallyImplyLeading: true,
                title: CustomTitle(title: title, isCenterTitle: isCenterTitle),
                centerTitle: true,
                actions: actions,
              )
              : AppBar(
                backgroundColor: AppColors.blue,
                elevation: 0,
                automaticallyImplyLeading: false,
                title: CustomTitle(title: title, isCenterTitle: isCenterTitle),
                centerTitle: false,
                actions: actions,
              ),
    );
  }
}
