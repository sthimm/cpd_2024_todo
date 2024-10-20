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

  void sortTasks(String sortType) {
    switch (sortType) {
      case 'Deadline':
        _tasks.sort((a, b) => a.deadline!.compareTo(b.deadline!));
        break;
      case 'Status':
        _tasks.sort((a, b) => a._status ? 1 : -1);
        break;
      case 'Priority': 
        _tasks.sort((a, b) => a.priority.index.compareTo(b.priority.index));
        break;
    }
    notifyListeners();
  }
}

class Task {
  final String _name;
  final String _description;
  final DateTime _deadline;
  final TaskPriority _priority;
  bool _status = false; 

  Task(this._name, this._description, this._deadline, this._priority);

  String get name => _name;
  String get description => _description;
  DateTime? get deadline => _deadline;
  TaskPriority get priority => _priority;
  bool get status => _status;

  void toggleStatus() {
    _status = !_status; 
  }

  Map<String, dynamic> getInfo() {
    return {
      'Name': _name,
      'Description': _description,
      'Deadline': _deadline.toString().substring(0, 10), 
      'Priority': _priority.toString().split('.').last,
      'Status': _status ? 'Closed' : 'Open',
    };
  }
}

enum TaskPriority { low, medium, high }