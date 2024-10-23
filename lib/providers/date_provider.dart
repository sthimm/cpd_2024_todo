import 'package:flutter/foundation.dart';

class MyDatePicker with ChangeNotifier {
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void selectDate(DateTime newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }

  void resetDate() {
    _selectedDate = DateTime.now();
    notifyListeners();
  }
}