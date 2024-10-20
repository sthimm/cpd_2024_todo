import 'package:flutter/foundation.dart';

class MyTaskManager with ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }
  
  void toggleTask(int index) {
    _tasks[index].toggleStatus();
    notifyListeners();
  }

  Task removeTask(int index) {
    Task task = _tasks[index];
    _tasks.removeAt(index);
    notifyListeners();
    return task; 
  }
}

class Task {
  final String _name;
  final String _description;
  final DateTime _deadline;
  bool _status = false; 

  Task(this._name, this._description, this._deadline);

  String get name => _name;
  String get description => _description;
  DateTime? get deadline => _deadline;
  bool get status => _status;

  void toggleStatus() {
    _status = !_status; 
  }

  Map<String, dynamic> getInfo() {
    return {
      'Name': _name,
      'Description': _description,
      'Deadline': _deadline.toString().substring(0, 10), 
      'Status': _status ? 'Closed' : 'Open',
    };
  }
}