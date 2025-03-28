import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/popupForm/top_nav.dart';

class PopupForm extends StatefulWidget {
  final String title;
  final bool btnSubmit;
  final Widget child;
  const PopupForm({
    super.key,
    required this.title,
    required this.btnSubmit,
    required this.child,
  });

  @override
  State<PopupForm> createState() => _PopupFormState();

  static void show(
    BuildContext context,
    String title,
    bool btnSubmit,
    Widget child,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return PopupForm(title: title, btnSubmit: btnSubmit, child: child);
      },
    );
  }
}

class _PopupFormState extends State<PopupForm> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.89,
      maxChildSize: 0.89,
      minChildSize: 0.89,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.darkBlue,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              PopupFormTopNav(title: widget.title, btnSubmit: widget.btnSubmit),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: widget.child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
