import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';
import 'package:frontend/src/ui/widgets/title/form_title.dart';

class PopupForm extends StatefulWidget {
  final String title;
  final bool btnSubmit;
  final Widget child;
  final VoidCallback function;
  const PopupForm({
    super.key,
    required this.title,
    required this.btnSubmit,
    required this.child,
    required this.function,
  });

  @override
  State<PopupForm> createState() => _PopupFormState();

  static void show({
    required BuildContext context,
    required String title,
    required bool btnSubmit,
    required Widget child,
    required VoidCallback function,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return PopupForm(
          title: title,
          btnSubmit: btnSubmit,
          function: function,
          child: child,
        );
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      '<  back',
                      style: TextStyle(
                        color: AppColors.darkRed,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CustomFormTitle(title: widget.title),
                  widget.btnSubmit
                      ? GestureDetector(
                        onTap: widget.function,
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: AppColors.yellow,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                      : Text('       '),
                ],
              ),
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
