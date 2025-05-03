import 'package:flutter/material.dart';
import 'package:frontend/src/class/job.dart';
import 'package:frontend/src/provider/job.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/screens/employer/job_details.dart';
import 'package:provider/provider.dart';

class JobCard extends StatefulWidget {
  final bool isShowBookmark;
  const JobCard({super.key, required this.isShowBookmark});

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JobProvider>(context, listen: false).setJob(
        Job(
          title: "Full-Stack Web Developer",
          company: "Shopee",
          location: "Mid valley, Kuala Lumpur",
          logoPath: "assets/images/shopee.jpg",
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final job = Provider.of<JobProvider>(context).job;

    if (job == null) {
      return Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () {
        //  Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => EmployeeJobDetailsScreen()),
        // );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployerJobDetailsScreen(),
          ),
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
                child: Image.asset(job.logoPath, fit: BoxFit.cover),
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
              widget.isShowBookmark
                  ? IconButton(
                    onPressed: () {
                      setState(() {
                        isBookmarked = !isBookmarked;
                      });
                    },
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: AppColors.black,
                      size: 24,
                    ),
                  )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
