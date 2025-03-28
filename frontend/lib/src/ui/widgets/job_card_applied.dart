import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/popupForm/popup_form.dart';

class JobCardApplied extends StatefulWidget {
  final String title;
  final String company;
  final String location;
  final String logoPath;
  final String formTitle;
  final Widget child;
  const JobCardApplied({
    super.key,
    required this.title,
    required this.company,
    required this.location,
    required this.logoPath,
    required this.formTitle,
    required this.child,
  });

  @override
  State<JobCardApplied> createState() => _JobCardAppliedState();
}

class _JobCardAppliedState extends State<JobCardApplied> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PopupForm.show(context, widget.formTitle, false, widget.child);
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
                child: Image.asset(widget.logoPath, fit: BoxFit.cover),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      widget.company,
                      style: TextStyle(fontSize: 13, color: AppColors.black),
                    ),
                    Text(
                      widget.location,
                      style: TextStyle(fontSize: 10, color: AppColors.black),
                    ),
                  ],
                ),
              ),
              Icon(Icons.check_circle_rounded, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}
