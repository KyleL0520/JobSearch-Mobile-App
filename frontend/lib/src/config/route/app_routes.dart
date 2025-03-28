import 'package:frontend/src/ui/screens/employee/main_screen.dart';
import 'package:frontend/src/ui/screens/start.dart';

class AppRoutes {
  static const start = '/';
  static const main = '/main';

  static final screens = {
    start: (context) => StartScreen(),
    main: (context) => EmployeeMainScreen(),
  };
}
