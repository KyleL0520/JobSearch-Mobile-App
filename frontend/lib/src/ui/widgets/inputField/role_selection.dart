import 'package:flutter/material.dart';
import 'package:frontend/src/styles/app_colors.dart';

class RoleSelection extends StatefulWidget {
  final Function(String) onRoleChanged;
  const RoleSelection({super.key, required this.onRoleChanged});

  @override
  State<RoleSelection> createState() => _RoleSelectionState();
}

class _RoleSelectionState extends State<RoleSelection> {
  String _selectedRole = 'employee';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedRole,
          icon: Icon(Icons.arrow_drop_down, color: AppColors.black),
          style: TextStyle(color: AppColors.black, fontSize: 14),
          dropdownColor: AppColors.white,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.settings_outlined, color: AppColors.black),
            hintText: 'Select your role',
            hintStyle: TextStyle(
              color: AppColors.grey,
              fontWeight: FontWeight.w600,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            filled: true,
            fillColor: AppColors.white,
          ),
          items: const [
            DropdownMenuItem(
              value: 'employee',
              child: Text('Employee', style: TextStyle(color: AppColors.black)),
            ),
            DropdownMenuItem(
              value: 'employer',
              child: Text('Employer', style: TextStyle(color: AppColors.black)),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedRole = value!;
              widget.onRoleChanged(_selectedRole);
            });
          },
        ),
        const SizedBox(height: 29),
      ],
    );
  }
}
