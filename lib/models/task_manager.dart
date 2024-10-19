import 'package:flutter/foundation.dart';

class TaskManager with ChangeNotifier {
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
  bool _status = false; 

  Task(this._name, this._description);

  String get name => _name;
  String get description => _description;
  bool get status => _status;

  void toggleStatus() {
    _status = !_status; 
  }

  Map<String, dynamic> getInfo() {
    return {
      'Name': _name,
      'Description': _description,
      'Status': _status ? 'Done' : 'Open',
    };
  }
}