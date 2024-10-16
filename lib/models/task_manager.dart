import 'package:flutter/foundation.dart';

class TaskManager with ChangeNotifier {
  int value = 0; 

  void increment() {
    value++;
    notifyListeners();
  }
}