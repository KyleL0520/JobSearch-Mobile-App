import 'package:flutter/material.dart';
import 'package:frontend/src/provider/job.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/button/redButton.dart';
import 'package:frontend/src/ui/widgets/title/form_title.dart';
import 'package:frontend/src/ui/widgets/textfield/description.dart';
import 'package:frontend/src/ui/widgets/textfield/payRange.dart';
import 'package:frontend/src/ui/widgets/textfield/text.dart';
import 'package:frontend/src/ui/widgets/popupForm/radio_option.dart';
import 'package:provider/provider.dart';

class EmployerJobDetailsScreen extends StatefulWidget {
  final bool isView;
  const EmployerJobDetailsScreen({super.key, required this.isView});

  @override
  State<EmployerJobDetailsScreen> createState() =>
      _EmployerJobDetailsScreenState();
}

class _EmployerJobDetailsScreenState extends State<EmployerJobDetailsScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController minController = TextEditingController();
  final TextEditingController maxController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedWorkType = 'Full time';
  String? selectedPayType = 'Hourly rate';

  final List<String> currencies = ['RM', 'USD', 'EUR', 'GBP'];
  String selectedCurrency = 'RM';

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
    final job = Provider.of<JobProvider>(context).job;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Job Details',
        isCenterTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
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
                  regex: r'^(\b\w+\b\s*){1,24}$',
                  hintText: widget.isView ? job!.title : 'Title',
                  title: 'Title',
                  specifiedErrorMessage: 'Not more than 24 words',
                ),
                const SizedBox(height: 10),
                StringTextField(
                  textController: locationController,
                  hintText: widget.isView ? job!.location : 'Location',
                  title: 'Location',
                  specifiedErrorMessage: '',
                ),
                const SizedBox(height: 10),
                CustomFormTitle(title: 'Work Type'),
                const SizedBox(height: 10),
                RadioOptionGroup(options: ['Full time', 'Part time']),
                const SizedBox(height: 10),
                CustomFormTitle(title: 'Pay Type'),
                const SizedBox(height: 10),
                RadioOptionGroup(
                  options: ['Hourly rate', 'Monthly salary', 'Annual salary'],
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
                            regex: r'^\d+$',
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
                            regex: r'^\d+$',
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
                  hintText: 'Description...',
                  title: 'Description',
                  specifiedErrorMessage: '',
                ),
                const SizedBox(height: 20),
                Row(children: [RedButton(text: 'Delete')]),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
