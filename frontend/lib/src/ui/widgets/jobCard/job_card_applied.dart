import 'package:flutter/material.dart';
import 'package:frontend/src/provider/job.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/popupForm/popup_form.dart';
import 'package:provider/provider.dart';

class JobCardApplied extends StatefulWidget {
  final String formTitle;
  final Widget child;
  const JobCardApplied({
    super.key,
    required this.formTitle,
    required this.child,
  });

  @override
  State<JobCardApplied> createState() => _JobCardAppliedState();
}

class _JobCardAppliedState extends State<JobCardApplied> {
  @override
  Widget build(BuildContext context) {
    final job = Provider.of<JobProvider>(context).job;

    void temp() {}

    return GestureDetector(
      onTap: () {
        PopupForm.show(
          context: context,
          title: widget.formTitle,
          btnSubmit: false,
          child: widget.child,
          function: temp,
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
                child: Image.asset(job!.logoPath, fit: BoxFit.cover),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      job.company,
                      style: TextStyle(fontSize: 13, color: AppColors.black),
                    ),
                    Text(
                      job.location,
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
