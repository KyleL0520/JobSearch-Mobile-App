import 'package:frontend/src/ui/screens/employee/main_screen.dart';
import 'package:frontend/src/ui/screens/employer/main_screen.dart';
import 'package:frontend/src/ui/screens/login.dart';

class AppRoutes {
  static const login = '/login';
  static const employeeMain = '/employeeMain';
  static const employerMain = '/employerMain';

  static final routes = {
    login: (context) => LoginScreen(),
    employeeMain: (context) => EmployeeMainScreen(),
    employerMain: (context) => EmployerMainScreen(),
  };
}
