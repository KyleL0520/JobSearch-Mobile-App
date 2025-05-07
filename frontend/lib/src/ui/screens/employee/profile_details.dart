import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/service/profile.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/app_bar.dart';
import 'package:frontend/src/ui/widgets/button/redButton.dart';
import 'package:frontend/src/ui/widgets/card.dart';
import 'package:frontend/src/ui/widgets/inputField/date.dart';
import 'package:frontend/src/ui/widgets/inputField/description.dart';
import 'package:frontend/src/ui/widgets/inputField/text.dart';
import 'package:frontend/src/ui/widgets/popupForm/popup_form.dart';
import 'package:frontend/src/ui/widgets/snackbar/snack_bar.dart';
import 'package:frontend/src/ui/widgets/title/form_title.dart';
import 'package:uuid/uuid.dart';

class ProfileDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? profile;
  const ProfileDetailsScreen({super.key, this.profile});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  final TextEditingController titleController = TextEditingController();
  final profileService = ProfileService();

  List<Map<String, dynamic>> careerHistorys = [];
  List<Map<String, dynamic>> educations = [];
  List<Map<String, dynamic>> skills = [];
  List<Map<String, dynamic>> languages = [];

  final String twentyFourPattern = r'^(\b\w+\b\s*){1,24}$';

  //Career History
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  String startDate = '';
  bool _stillInThisRole = false;
  String? endDate;
  final TextEditingController careerHistoryDescriptionController =
      TextEditingController();

  //Education
  final TextEditingController courseOrQualificationController =
      TextEditingController();
  final TextEditingController institutionController = TextEditingController();
  bool _isQualificationComplete = false;
  String? finishDate;

  //Skill
  final TextEditingController skillController = TextEditingController();

  //Language
  final TextEditingController languageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
    titleController.text = widget.profile?['title'] ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    jobTitleController.dispose();
    companyController.dispose();
    careerHistoryDescriptionController.dispose();
    courseOrQualificationController.dispose();
    institutionController.dispose();
    skillController.dispose();
    languageController.dispose();
  }

  void _loadProfile() async {
    setState(() {
      careerHistorys =
          (widget.profile?['careerHistorys'] as List<dynamic>?)
              ?.map((item) => item as Map<String, dynamic>)
              .toList() ??
          [];
      educations =
          (widget.profile?['educations'] as List<dynamic>?)
              ?.map((item) => item as Map<String, dynamic>)
              .toList() ??
          [];
      skills =
          (widget.profile?['skills'] as List<dynamic>?)
              ?.map((item) => item as Map<String, dynamic>)
              .toList() ??
          [];
      languages =
          (widget.profile?['languages'] as List<dynamic>?)
              ?.map((item) => item as Map<String, dynamic>)
              .toList() ??
          [];
    });
  }

  void _clearCareerHistoryForm() {
    jobTitleController.clear();
    companyController.clear();
    careerHistoryDescriptionController.clear();
    startDate = '';
    endDate = null;
    _stillInThisRole = false;
  }

  void _clearEducationForm() {
    courseOrQualificationController.clear();
    institutionController.clear();
    finishDate = null;
    _isQualificationComplete = false;
  }

  void _clearSkillForm() {
    skillController.clear();
  }

  void _clearLanguageForm() {
    languageController.clear();
  }

  void addCareerHistory() {
    final String currentJobTitle = jobTitleController.text.trim();
    final String currentCompany = companyController.text.trim();
    final String currentCareerHistoryDescription =
        careerHistoryDescriptionController.text.trim();

    if ((currentJobTitle == '' ||
            currentJobTitle.isEmpty ||
            !RegExp(twentyFourPattern).hasMatch(currentJobTitle)) ||
        (currentCompany == '' ||
            currentCompany.isEmpty ||
            !RegExp(twentyFourPattern).hasMatch(currentCompany)) ||
        (currentCareerHistoryDescription == '' ||
            currentCareerHistoryDescription.isEmpty) ||
        (startDate == '' || startDate.isEmpty) ||
        (!_stillInThisRole && (endDate == null || endDate == ''))) {
      return;
    }

    if (_stillInThisRole) {
      endDate = null;
    }

    String careerHistoryId = 'careerHistory_${Uuid().v4()}';

    Map<String, dynamic> data = {
      'careerHistoryId': careerHistoryId,
      'jobTitle': currentJobTitle,
      'company': currentCompany,
      'startDate': startDate,
      'endDate': endDate,
      'stillInThisRole': _stillInThisRole,
      'description': currentCareerHistoryDescription,
    };

    setState(() {
      careerHistorys.add(data);
      print(careerHistorys);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar.successSnackBar(
        title: 'Career history created successfully',
      ),
    );

    Navigator.pop(context);
    _clearCareerHistoryForm();
  }

  void editCareerHistory(String careerHistoryId) {
    final String currentJobTitle = jobTitleController.text.trim();
    final String currentCompany = companyController.text.trim();
    final String currentCareerHistoryDescription =
        careerHistoryDescriptionController.text.trim();

    if ((currentJobTitle == '' ||
            currentJobTitle.isEmpty ||
            !RegExp(twentyFourPattern).hasMatch(currentJobTitle)) ||
        (currentCompany == '' ||
            currentCompany.isEmpty ||
            !RegExp(twentyFourPattern).hasMatch(currentCompany)) ||
        (currentCareerHistoryDescription == '' ||
            currentCareerHistoryDescription.isEmpty) ||
        (startDate == '' || startDate.isEmpty) ||
        (!_stillInThisRole && (endDate == null || endDate == ''))) {
      return;
    }

    if (_stillInThisRole) {
      endDate = null;
    }

    Map<String, dynamic> updatedData = {
      'careerHistoryId': careerHistoryId,
      'jobTitle': currentJobTitle,
      'company': currentCompany,
      'startDate': startDate,
      'endDate': endDate,
      'stillInThisRole': _stillInThisRole,
      'description': currentCareerHistoryDescription,
    };

    setState(() {
      final index = careerHistorys.indexWhere(
        (element) => element['careerHistoryId'] == careerHistoryId,
      );

      if (index != -1) {
        careerHistorys[index] = updatedData;
      }
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar.successSnackBar(
        title: 'Career history updated successfully',
      ),
    );

    Navigator.pop(context);
    _clearCareerHistoryForm();
  }

  void removeCareerHistory(String careerHistoryId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Confirm Deletion'),
            content: Text(
              'Are you sure you want to delete this career history?',
            ),
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
      setState(() {
        final index = careerHistorys.indexWhere(
          (element) => element['careerHistoryId'] == careerHistoryId,
        );

        if (index != -1) {
          careerHistorys.removeAt(index);
        }
      });

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.successSnackBar(
          title: 'Career history deleted successfully',
        ),
      );
    }

    Navigator.pop(context);
    _clearCareerHistoryForm();
  }

  void addEducation() {
    final currentCourseOrQualification =
        courseOrQualificationController.text.trim();
    final currentInstitution = institutionController.text.trim();

    if ((currentCourseOrQualification == '' ||
            currentCourseOrQualification.isEmpty) ||
        (currentInstitution == '' || currentInstitution.isEmpty) ||
        (_isQualificationComplete &&
            (finishDate == null || finishDate == ''))) {
      return;
    }

    if (!_isQualificationComplete) {
      finishDate = null;
    }

    String educationId = 'educationId_${Uuid().v4()}';

    final Map<String, dynamic> data = {
      'educationId': educationId,
      'courseOfQualification': currentCourseOrQualification,
      'institution': currentInstitution,
      'isComplete': _isQualificationComplete,
      'finishDate': finishDate,
    };

    setState(() {
      educations.add(data);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar.successSnackBar(
        title: 'Education record created successfully',
      ),
    );

    Navigator.pop(context);
    _clearEducationForm();
  }

  void editEducation(String educationId) {
    final currentCourseOrQualification =
        courseOrQualificationController.text.trim();
    final currentInstitution = institutionController.text.trim();

    if ((currentCourseOrQualification == '' ||
            currentCourseOrQualification.isEmpty) ||
        (currentInstitution == '' || currentInstitution.isEmpty) ||
        (_isQualificationComplete &&
            (finishDate == null || finishDate == ''))) {
      return;
    }

    if (!_isQualificationComplete) {
      finishDate = null;
    }

    final Map<String, dynamic> updatedData = {
      'educationId': educationId,
      'courseOfQualification': currentCourseOrQualification,
      'institution': currentInstitution,
      'isComplete': _isQualificationComplete,
      'finishDate': finishDate,
    };

    setState(() {
      final index = educations.indexWhere(
        (element) => element['educationId'] == educationId,
      );

      if (index != -1) {
        educations[index] = updatedData;
      }
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar.successSnackBar(
        title: 'Education record updated successfully',
      ),
    );

    Navigator.pop(context);
    _clearEducationForm();
  }

  void removeEducation(String educationId) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Confirm Deletion'),
            content: Text(
              'Are you sure you want to delete this education record?',
            ),
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
      setState(() {
        final index = educations.indexWhere(
          (element) => element['educationId'] == educationId,
        );

        if (index != -1) {
          educations.removeAt(index);
        }
      });

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.successSnackBar(
          title: 'Education record deleted successfully',
        ),
      );
    }

    Navigator.pop(context);
    _clearEducationForm();
  }

  void addSkill() {
    final String currentSkill = skillController.text.trim();

    if ((currentSkill == '' || currentSkill.isEmpty)) {
      return;
    }

    Map<String, dynamic> data = {'label': currentSkill};

    setState(() {
      skills.add(data);
      print(skills);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar.successSnackBar(title: 'Skill created successfully'),
    );

    Navigator.pop(context);
    _clearSkillForm();
  }

  void removeSkill(String skill) {
    setState(() {
      final index = skills.indexWhere(
        (element) => element['label'] == skill.trim(),
      );

      if (index != -1) {
        skills.removeAt(index);
      }
    });
    _clearSkillForm();
  }

  void addLanguage() {
    final String currentLanguage = languageController.text.trim();

    if ((currentLanguage == '' || currentLanguage.isEmpty)) {
      return;
    }

    Map<String, dynamic> data = {'label': currentLanguage};

    setState(() {
      languages.add(data);
      print(languages);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar.successSnackBar(title: 'Language created successfully'),
    );

    Navigator.pop(context);
    _clearLanguageForm();
  }

  void removeLanguage(String language) {
    setState(() {
      final index = languages.indexWhere(
        (element) => element['label'] == language.trim(),
      );

      if (index != -1) {
        languages.removeAt(index);
      }
    });
    _clearLanguageForm();
  }

  void addProfile() async {
    final String currentTitle = titleController.text.trim();

    if ((currentTitle == '' ||
            currentTitle.isEmpty ||
            !RegExp(twentyFourPattern).hasMatch(currentTitle)) ||
        (careerHistorys == []) ||
        (skills == []) ||
        (languages == [])) {
      return;
    }

    try {
      await profileService.createProfile(
        title: currentTitle,
        careerHistorys: careerHistorys,
        educations: educations,
        skills: skills,
        languages: languages,
      );
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.successSnackBar(title: 'Profile created successfully'),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.failedSnackBar(title: 'Profile failed to create'),
      );
    }
    Navigator.pop(context);
  }

  void editProfile() async {
    final String currentTitle = titleController.text.trim();

    if ((currentTitle == '' ||
            currentTitle.isEmpty ||
            !RegExp(twentyFourPattern).hasMatch(currentTitle)) ||
        (careerHistorys == []) ||
        (skills == []) ||
        (languages == [])) {
      return;
    }

    Map<String, dynamic> updatedData = {};
    updatedData['profileId'] = widget.profile?['profileId'];
    updatedData['title'] = currentTitle;
    updatedData['careerHistorys'] = careerHistorys;
    updatedData['educations'] = educations;
    updatedData['skills'] = skills;
    updatedData['languages'] = languages;

    try {
      await profileService.updateProfile(
        profileId: widget.profile?['profileId'],
        data: updatedData,
      );
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.successSnackBar(title: 'Profile updated successfully'),
      );
    } catch (e) {
      print('Updated failed: $e');
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar.failedSnackBar(title: 'Profile failed to update'),
      );
    }
    Navigator.pop(context);
  }

  void removeProfile() async {
    bool confirmDelete = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Confirm Deletion'),
            content: Text('Are you sure you want to delete this profile?'),
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
        await profileService.deleteProfile(
          profileId: widget.profile?['profileId'],
        );
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.successSnackBar(title: 'Profile deleted successfully'),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar.failedSnackBar(title: 'Profile failed to delete'),
        );
      }
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile Details',
        isCenterTitle: true,
        actions: [
          TextButton(
            onPressed: widget.profile == null ? addProfile : editProfile,
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
                  regex: twentyFourPattern,
                  hintText: 'Enter title',
                  title: 'Title',
                  specifiedErrorMessage: 'No more than 24 words and symbol',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomFormTitle(title: 'Career History'),
                    TextButton(
                      onPressed: () {
                        PopupForm.show(
                          context: context,
                          title: 'Career Details',
                          btnSubmit: true,
                          function: addCareerHistory,
                          child: StatefulBuilder(
                            builder: (
                              BuildContext context,
                              StateSetter setmodalState,
                            ) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 20),
                                  StringTextField(
                                    textController: jobTitleController,
                                    hintText: 'Enter job title',
                                    title: 'Job title',
                                    regex: twentyFourPattern,
                                    specifiedErrorMessage:
                                        'No more than 24 words and symbol',
                                  ),
                                  const SizedBox(height: 10),
                                  StringTextField(
                                    textController: companyController,
                                    hintText: 'Enter company',
                                    title: 'Company',
                                    regex: twentyFourPattern,
                                    specifiedErrorMessage:
                                        'No more than 24 words and symbol',
                                  ),
                                  const SizedBox(height: 10),
                                  DatePickerField(
                                    hintText: 'Select start date',
                                    title: 'Start Date',
                                    isRequired: true,
                                    initialValue: startDate,
                                    onChanged: (String? date) {
                                      setmodalState(() {
                                        startDate = date ?? '';
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "I'm still in this role",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      CupertinoSwitch(
                                        value: _stillInThisRole,
                                        onChanged: (bool value) {
                                          setmodalState(() {
                                            _stillInThisRole = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  _stillInThisRole
                                      ? SizedBox()
                                      : DatePickerField(
                                        hintText: 'Select end date',
                                        title: 'End Date',
                                        isRequired: _stillInThisRole,
                                        initialValue: endDate,
                                        onChanged: (String? date) {
                                          setmodalState(() {
                                            endDate = date;
                                          });
                                        },
                                      ),
                                  DescriptionTextField(
                                    textController:
                                        careerHistoryDescriptionController,
                                    hintText: 'Enter description...',
                                    title: 'Description',
                                    maxLength: 200,
                                    specifiedErrorMessage: '',
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            },
                          ),
                        );
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: AppColors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                ...(careerHistorys.isNotEmpty)
                    ? careerHistorys.map((Map<String, dynamic> careerHistory) {
                      return GestureDetector(
                        onTap: () {
                          jobTitleController.text =
                              careerHistory['jobTitle'] ?? '';
                          companyController.text =
                              careerHistory['company'] ?? '';
                          careerHistoryDescriptionController.text =
                              careerHistory['description'] ?? '';
                          startDate = careerHistory['startDate'] ?? '';
                          endDate = careerHistory['endDate'] ?? '';
                          _stillInThisRole =
                              careerHistory['stillInThisRole'] ?? false;

                          PopupForm.show(
                            context: context,
                            title: 'Career Details',
                            btnSubmit: true,
                            function:
                                () => editCareerHistory(
                                  careerHistory['careerHistoryId'],
                                ),
                            child: StatefulBuilder(
                              builder: (
                                BuildContext context,
                                StateSetter setmodalState,
                              ) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 20),
                                    StringTextField(
                                      textController: jobTitleController,
                                      hintText: 'Enter job title',
                                      title: 'Job title',
                                      regex: twentyFourPattern,
                                      specifiedErrorMessage:
                                          'No more than 24 words and symbol',
                                    ),
                                    const SizedBox(height: 10),
                                    StringTextField(
                                      textController: companyController,
                                      hintText: 'Enter company',
                                      title: 'Company',
                                      regex: twentyFourPattern,
                                      specifiedErrorMessage:
                                          'No more than 24 words and symbol',
                                    ),
                                    const SizedBox(height: 10),
                                    DatePickerField(
                                      hintText: 'Select start date',
                                      title: 'Start Date',
                                      isRequired: true,
                                      initialValue: startDate,
                                      onChanged: (String? date) {
                                        setmodalState(() {
                                          startDate = date ?? '';
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "I'm still in this role",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        CupertinoSwitch(
                                          value: _stillInThisRole,
                                          onChanged: (bool value) {
                                            setmodalState(() {
                                              _stillInThisRole = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    _stillInThisRole
                                        ? SizedBox()
                                        : DatePickerField(
                                          hintText: 'Select end date',
                                          title: 'End Date',
                                          isRequired: _stillInThisRole,
                                          initialValue: endDate,
                                          onChanged: (String? date) {
                                            setmodalState(() {
                                              endDate = date;
                                            });
                                          },
                                        ),
                                    DescriptionTextField(
                                      textController:
                                          careerHistoryDescriptionController,
                                      hintText: 'Enter description...',
                                      title: 'Description',
                                      maxLength: 200,
                                      specifiedErrorMessage: '',
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RedButton(
                                            text: 'Delete',
                                            function:
                                                () => removeCareerHistory(
                                                  careerHistory['careerHistoryId'],
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            CardWidget(
                              first: careerHistory['jobTitle'] ?? '',
                              second: careerHistory['company'] ?? '',
                              third:
                                  careerHistory['stillInThisRole'] == true
                                      ? '${careerHistory['startDate']} - Still in this role'
                                      : '${careerHistory['startDate']} - ${careerHistory['endDate']}',
                            ),
                          ],
                        ),
                      );
                    }).toList()
                    : [
                      Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 3,
                          vertical: 7,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: AppColors.grey,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "What's your career history",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(width: 17),
                              Image.asset(
                                'assets/icons/arrow.png',
                                width: 35,
                                height: 35,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomFormTitle(title: 'Education'),
                    TextButton(
                      onPressed: () {
                        PopupForm.show(
                          context: context,
                          title: 'Education',
                          btnSubmit: true,
                          function: addEducation,
                          child: StatefulBuilder(
                            builder: (
                              BuildContext context,
                              StateSetter setmodalState,
                            ) {
                              return Column(
                                children: [
                                  const SizedBox(height: 20),
                                  StringTextField(
                                    textController:
                                        courseOrQualificationController,
                                    hintText: 'Enter course or qualification',
                                    title: 'Course or qualification',
                                    specifiedErrorMessage: '',
                                  ),
                                  const SizedBox(height: 10),
                                  StringTextField(
                                    textController: institutionController,
                                    hintText: 'Enter institution',
                                    title: 'Institution',
                                    specifiedErrorMessage: '',
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Qualification complete"),
                                      CupertinoSwitch(
                                        value: _isQualificationComplete,
                                        onChanged: (bool value) {
                                          setmodalState(() {
                                            _isQualificationComplete = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  _isQualificationComplete
                                      ? DatePickerField(
                                        hintText: 'Select finish date',
                                        title: 'Finish Date',
                                        isRequired: true,
                                        initialValue: finishDate,
                                        onChanged: (String? date) {
                                          setmodalState(() {
                                            finishDate = date;
                                          });
                                        },
                                      )
                                      : SizedBox(),
                                ],
                              );
                            },
                          ),
                        );
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: AppColors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                ...(educations.isNotEmpty)
                    ? educations.map((Map<String, dynamic> education) {
                      return GestureDetector(
                        onTap: () {
                          courseOrQualificationController.text =
                              education['courseOfQualification'] ?? '';
                          institutionController.text =
                              education['institution'] ?? '';
                          _isQualificationComplete =
                              education['isComplete'] ?? false;
                          finishDate = education['finishDate'] ?? '';
                          PopupForm.show(
                            context: context,
                            title: 'Education',
                            btnSubmit: true,
                            function:
                                () => editEducation(education['educationId']),
                            child: StatefulBuilder(
                              builder: (
                                BuildContext context,
                                StateSetter setmodalState,
                              ) {
                                return Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    StringTextField(
                                      textController:
                                          courseOrQualificationController,
                                      hintText: 'Enter course or qualification',
                                      title: 'Course or qualification',
                                      specifiedErrorMessage: '',
                                    ),
                                    const SizedBox(height: 10),
                                    StringTextField(
                                      textController: institutionController,
                                      hintText: 'Enter institution',
                                      title: 'Institution',
                                      specifiedErrorMessage: '',
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Qualification complete"),
                                        CupertinoSwitch(
                                          value: _isQualificationComplete,
                                          onChanged: (bool value) {
                                            setmodalState(() {
                                              _isQualificationComplete = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    _isQualificationComplete
                                        ? DatePickerField(
                                          hintText: 'Select finish date',
                                          title: 'Finish date',
                                          isRequired: true,
                                          initialValue: finishDate,
                                          onChanged: (String? date) {
                                            setmodalState(() {
                                              finishDate = date;
                                            });
                                          },
                                        )
                                        : SizedBox(),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: RedButton(
                                            text: 'Delete',
                                            function:
                                                () => removeEducation(
                                                  education['educationId'],
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            CardWidget(
                              first: education['courseOfQualification'] ?? '',
                              second: education['institution'] ?? '',
                              third:
                                  education['isComplete'] == true
                                      ? 'Finished in ${education['finishDate']}'
                                      : 'Currently Studying',
                            ),
                          ],
                        ),
                      );
                    }).toList()
                    : [
                      Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 3,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: AppColors.grey,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Where you study at',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(width: 30),
                              Image.asset(
                                'assets/icons/arrow.png',
                                width: 35,
                                height: 35,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                const SizedBox(height: 20),
                CustomFormTitle(title: 'Skills'),
                const SizedBox(height: 10),
                if (skills.isNotEmpty)
                  Wrap(
                    spacing: 2,
                    children:
                        skills.map((Map<String, dynamic> skill) {
                          return _smallCard(title: skill['label']);
                        }).toList(),
                  ),
                _seeAll(() {
                  PopupForm.show(
                    context: context,
                    title: 'Skills',
                    btnSubmit: true,
                    function: addSkill,
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          children: [
                            const SizedBox(height: 20),
                            _notRequiredField(
                              title: 'Skill',
                              hintText: 'Enter skill',
                              textEditingController: skillController,
                            ),
                            const SizedBox(height: 20),
                            CustomFormTitle(title: 'Added skills'),
                            const SizedBox(height: 10),
                            if (skills.isNotEmpty)
                              Wrap(
                                spacing: 2,
                                children:
                                    skills.map((skill) {
                                      return _smallCard(
                                        title: skill['label'],
                                        remove: () {
                                          this.setState(() {
                                            removeSkill(skill['label']);
                                          });
                                          setState(() {});
                                        },
                                      );
                                    }).toList(),
                              ),
                          ],
                        );
                      },
                    ),
                  );
                }),
                const SizedBox(height: 20),
                CustomFormTitle(title: 'Languages'),
                const SizedBox(height: 10),
                if (languages.isNotEmpty)
                  Wrap(
                    spacing: 2,
                    children:
                        languages.map((Map<String, dynamic> language) {
                          return _smallCard(title: language['label']);
                        }).toList(),
                  ),
                _seeAll(() {
                  PopupForm.show(
                    context: context,
                    title: 'Languages',
                    btnSubmit: true,
                    function: addLanguage,
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          children: [
                            const SizedBox(height: 20),
                            _notRequiredField(
                              title: 'Language',
                              hintText: 'Enter language',
                              textEditingController: languageController,
                            ),
                            const SizedBox(height: 20),
                            CustomFormTitle(title: 'Added languages'),
                            const SizedBox(height: 10),
                            if (languages.isNotEmpty)
                              Wrap(
                                spacing: 2,
                                children:
                                    languages.map((language) {
                                      return _smallCard(
                                        title: language['label'],
                                        remove: () {
                                          this.setState(() {
                                            removeLanguage(language['label']);
                                          });
                                          setState(() {});
                                        },
                                      );
                                    }).toList(),
                              ),
                          ],
                        );
                      },
                    ),
                  );
                }),
                const SizedBox(height: 20),
                widget.profile == null
                    ? SizedBox()
                    : Row(
                      children: [
                        Expanded(
                          child: RedButton(
                            text: 'Delete',
                            function: removeProfile,
                          ),
                        ),
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

  Widget _smallCard({required String title, VoidCallback? remove}) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 3, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.grey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.black,
              ),
            ),
            remove == null
                ? SizedBox()
                : Row(
                  children: [
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: remove,
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }

  Widget _seeAll(VoidCallback onPressed) {
    return SizedBox(
      height: 42,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColors.darkBlue,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              'See All',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _notRequiredField({
    required String title,
    required String hintText,
    required TextEditingController textEditingController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomFormTitle(title: title),
        const SizedBox(height: 10),
        TextField(
          controller: textEditingController,
          style: TextStyle(color: AppColors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.grey,
              fontWeight: FontWeight.w600,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            errorText: null,
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
