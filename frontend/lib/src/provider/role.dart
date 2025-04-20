import 'package:flutter/widgets.dart';
import 'package:frontend/src/class/role.dart';

class RoleProvider with ChangeNotifier {
  Role? _role;

  Role? get role => _role;

  void setRole(Role role) {
    _role = role;
    notifyListeners();
  }
}