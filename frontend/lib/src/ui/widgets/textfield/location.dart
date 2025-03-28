import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';

class LocationTextField extends StatefulWidget {
  final TextEditingController locationController;

  const LocationTextField({super.key, required this.locationController});

  @override
  State<LocationTextField> createState() => _LocationTextFieldState();
}

class _LocationTextFieldState extends State<LocationTextField> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: widget.locationController,
        style: TextStyle(color: AppColors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.black),
          hintText: 'Location',
          hintStyle: TextStyle(
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 2),
          errorText: _errorText,
          errorStyle: TextStyle(
            color: AppColors.darkRed,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        onChanged: (value) {
          setState(() {
            if (value.isEmpty) {
              _errorText = 'Location is required';
            } else {
              _errorText = null;
            }
          });
        },
      ),
    );
  }
}
