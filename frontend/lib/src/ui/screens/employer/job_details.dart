import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/database_service.dart';
import 'package:frontend/database/service/job.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/button/redButton.dart';
import 'package:frontend/src/ui/widgets/snackbar/snack_bar.dart';
import 'package:frontend/src/ui/widgets/title/form_title.dart';
import 'package:frontend/src/ui/widgets/inputField/description.dart';
import 'package:frontend/src/ui/widgets/inputField/payRange.dart';
import 'package:frontend/src/ui/widgets/inputField/text.dart';
import 'package:frontend/src/ui/widgets/popupForm/radio_option.dart';
import 'package:intl/intl.dart';

class EmployerJobDetailsScreen extends StatefulWidget {
  final String? jobId;
  final String? title;
  final String? location;
  final String? workType;
  final String? payType;
  final String? payRange;
  final String? description;
  const EmployerJobDetailsScreen({
    super.key,
    this.jobId,
    this.title,
    this.location,
    this.workType,
    this.payType,
    this.payRange,
    this.description,
  });

  @override
  State<EmployerJobDetailsScreen> createState() =>
      _EmployerJobDetailsScreenState();
}

class _EmployerJobDetailsScreenState extends State<EmployerJobDetailsScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final jobService = JobService();
  final db = DatabaseService();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController minController = TextEditingController();
  final TextEditingController maxController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String rangeType = '';

  final String titlePattern = r'^(\b\w+\b\s*){1,24}$';
  final String intPattern = r'^\d+$';

  String selectedWorkType = 'Full time';
  String selectedPayType = 'Hourly rate';

  final List<String> currencies = ['RM', 'USD', 'EUR', 'GBP'];
  String selectedCurrency = 'RM';
  String _avatar = 'assets/images/userAvatar.png';

  String originalTitle = '';
  String originalLocation = '';
  String originalWorkType = '';
  String originalPayType = '';
  String originalPayRange = '';
  String originalDescription = '';

  @override
  void initState() {
    super.initState();
    getAvatar(uid).then((value) {
      setState(() {
        _avatar = value ?? 'assets/images/userAvatar.png';
      });
    });

    setState(() {
      originalTitle = widget.title ?? '';
      originalLocation = widget.location ?? '';
      originalWorkType = widget.workType ?? '';
      originalPayType = widget.payType ?? '';
      originalPayRange = widget.payRange ?? '';
      originalDescription = widget.description ?? '';

      titleController.text = originalTitle;
      locationController.text = originalLocation;
      if (originalWorkType == '') {
        selectedWorkType = 'Full time';
      } else {
        selectedWorkType = originalWorkType;
      }

      if (originalPayType == '') {
        selectedPayType = 'Hourly rate';
      } else {
        selectedPayType = originalPayType;
      }
      _extractPayRangeValues(originalPayRange);
      descriptionController.text = originalDescription;
    });
  }

  Future<String?> getAvatar(String uid) async {
    final snapshot = await db.read(collectionPath: 'Employer', docId: uid);

    if (snapshot != null && snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      return data['avatar'] as String?;
    }

    return null;
  }

  void _extractPayRangeValues(String payRange) {
    RegExp regExp = RegExp(
      r'(\D+)\s*(\d{1,3}(?:,\d{3})*)\s*-\s*(\d{1,3}(?:,\d{3})*)',
    );
    final match = regExp.firstMatch(payRange);
    if (match != null) {
      String currency = match.group(1) ?? '';
      String minValue = match.group(2) ?? '';
      String maxValue = match.group(3) ?? '';

      selectedCurrency = currency.trim();
      minController.text = minValue.replaceAll(',', '').trim();
      maxController.text = maxValue.replaceAll(',', '').trim();
    }
  }

  String _convertRangeType() {
    final formatter = NumberFormat('#,###');

    if (!RegExp(intPattern).hasMatch(minController.text.trim()) ||
        !RegExp(intPattern).hasMatch(minController.text.trim())) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.failedSnackBar(
          title: 'Min or Max pay range must be integer',
        ),
      );
      return '';
    }

    int min = int.tryParse(minController.text.trim()) ?? 0;
    int max = int.tryParse(maxController.text.trim()) ?? 0;

    return '$selectedCurrency ${formatter.format(min)} - ${formatter.format(max)}';
  }

  void addJob() async {
    final String currentTitle = titleController.text.trim();
    final String currentLocation = locationController.text.trim();
    final String currentWorkType = selectedWorkType;
    final String currentPayType = selectedPayType;
    final String currentPayRange = _convertRangeType();
    final String currentDescription = descriptionController.text.trim();
    final String currentLogo = _avatar;

    if ((currentTitle == '' ||
            currentTitle.isEmpty ||
            !RegExp(titlePattern).hasMatch(currentTitle)) ||
        (currentLocation == '' || currentLocation.isEmpty) ||
        (currentWorkType == '' || currentWorkType.isEmpty) ||
        (currentPayType == '' || currentPayType.isEmpty) ||
        (currentPayRange == '' || currentPayRange.isEmpty) ||
        (currentDescription == '' || currentDescription.isEmpty)) {
      return;
    }

    try {
      await jobService.createJob(
        title: currentTitle,
        location: currentLocation,
        workType: currentWorkType,
        payType: currentPayType,
        payRange: currentPayRange,
        description: currentDescription,
        logo: currentLogo,
      );
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.successSnackBar(title: 'Job created successfully'),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.failedSnackBar(title: 'Job failed to create'),
      );
    }

    Navigator.pop(context);
  }

  void editJob() async {
    final String currentTitle = titleController.text.trim();
    final String currentLocation = locationController.text.trim();
    final String currentWorkType = selectedWorkType;
    final String currentPayType = selectedPayType;
    final String currentPayRange = _convertRangeType();
    final String currentDescription = descriptionController.text.trim();

    if (currentTitle == originalTitle &&
        currentLocation == originalLocation &&
        currentWorkType == originalWorkType &&
        currentPayType == originalPayType &&
        currentPayRange == originalPayRange &&
        currentDescription == originalDescription) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(CustomSnackBar.failedSnackBar(title: 'No changes update'));
      return;
    }

    if ((currentTitle == '' ||
            currentTitle.isEmpty ||
            !RegExp(titlePattern).hasMatch(currentTitle)) ||
        (currentLocation == '' || currentLocation.isEmpty) ||
        (currentWorkType == '' || currentWorkType.isEmpty) ||
        (currentPayType == '' || currentPayType.isEmpty) ||
        (currentPayRange == '' || currentPayRange.isEmpty) ||
        (currentDescription == '' || currentDescription.isEmpty)) {
      return;
    }

    Map<String, dynamic> updatedData = {};
    updatedData['title'] = currentTitle;
    originalTitle = currentTitle;

    updatedData['location'] = currentLocation;
    originalLocation = currentLocation;

    updatedData['workType'] = currentWorkType;
    originalWorkType = currentWorkType;

    updatedData['payType'] = currentPayType;
    originalPayType = currentPayType;

    updatedData['payRange'] = currentPayRange;
    originalPayRange = currentPayRange;

    updatedData['description'] = currentDescription;
    originalDescription = currentDescription;

    try {
      if (updatedData.isNotEmpty) {
        await jobService.updateJob(widget.jobId!, updatedData);
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.successSnackBar(title: 'Job updated successfully'),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.failedSnackBar(title: 'Job failed to update'),
      );
    }

    Navigator.pop(context);
  }

  void removeJob() async {
    bool confirmDelete = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Confirm Deletion'),
            content: Text('Are you sure you want to delete this job?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.yellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );

    if (confirmDelete == true) {
      try {
        await jobService.deleteJob(widget.jobId!);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.successSnackBar(title: 'Job deleted successfully'),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.failedSnackBar(title: 'Job failed to delete'),
        );
      }
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    minController.dispose();
    maxController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Job Details',
        isCenterTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              widget.jobId == null ? addJob() : editJob();
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: AppColors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                StringTextField(
                  textController: titleController,
                  regex: titlePattern,
                  hintText: 'Enter title',
                  title: 'Title',
                  specifiedErrorMessage: 'No more than 24 words',
                ),
                const SizedBox(height: 10),
                StringTextField(
                  textController: locationController,
                  hintText: 'Enter location',
                  title: 'Location',
                  specifiedErrorMessage: '',
                ),
                const SizedBox(height: 10),
                CustomFormTitle(title: 'Work Type'),
                const SizedBox(height: 10),
                RadioOptionGroup(
                  options: ['Full time', 'Part time'],
                  initialValue: selectedWorkType,
                  onChanged: (value) {
                    setState(() {
                      selectedWorkType = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                CustomFormTitle(title: 'Pay Type'),
                const SizedBox(height: 10),
                RadioOptionGroup(
                  options: ['Hourly rate', 'Monthly salary', 'Annual salary'],
                  initialValue: selectedPayType,
                  onChanged: (value) {
                    setState(() {
                      selectedPayType = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                CustomFormTitle(title: 'Pay Range'),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Currency',
                          style: TextStyle(fontSize: 14, color: AppColors.grey),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 1,
                            horizontal: 8,
                          ),
                          width: 80,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            value: selectedCurrency,
                            dropdownColor: AppColors.blue,
                            borderRadius: BorderRadius.circular(12),
                            style: const TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            items:
                                currencies.map((currency) {
                                  return DropdownMenuItem<String>(
                                    value: currency,
                                    child: Text(currency),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedCurrency = value;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 23),
                          Text(
                            'From',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          PayRangeTextField(
                            textController: minController,
                            hintText: 'Minimum',
                            regex: intPattern,
                            specifiedErrorMessage: 'This field is incorrect',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(children: [const SizedBox(height: 23), Text('-')]),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 23),
                          Text(
                            'To',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          PayRangeTextField(
                            textController: maxController,
                            hintText: 'Maximum',
                            regex: intPattern,
                            specifiedErrorMessage: 'This field is incorrect',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DescriptionTextField(
                  textController: descriptionController,
                  hintText: 'Enter description',
                  title: 'Description',
                  maxLength: 600,
                  specifiedErrorMessage: '',
                ),
                const SizedBox(height: 20),
                widget.jobId == null
                    ? SizedBox()
                    : Row(
                      children: [
                        Expanded(child: RedButton(text: 'Delete', function: removeJob)),
                      ],
                    ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
