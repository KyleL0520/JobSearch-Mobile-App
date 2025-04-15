import 'package:flutter/widgets.dart';
import 'package:frontend/src/class/job.dart';

class JobProvider with ChangeNotifier {
  Job? _job;

  Job? get job => _job;

  void setJob(Job newJob) {
    _job = newJob;
    notifyListeners();
  }
}