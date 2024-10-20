import 'package:flutter/foundation.dart';

class MyTaskManager with ChangeNotifier {
  final List<Task> _tasks = [];
  List<Task> _sortedTasks = [];
  SortType _sortType = SortType.unsorted;

  SortType get sortType => _sortType;

  set sortType(SortType newSortType) {
    if (_sortType != newSortType) {
      _sortType = newSortType;
      _sortTasks(sortType); 
      notifyListeners(); 
    }
  }

  List<Task> get tasks {
    return _sortType == SortType.unsorted ? _tasks : _sortedTasks;
  }

  void addTask(Task task) {
    _tasks.add(task);
    _sortTasks(sortType);
    notifyListeners();
  }
  
  void toggleTask(int index) {
    if (_sortType == SortType.unsorted) {
      _tasks[index].toggleStatus();
    } else {
      _sortedTasks[index].toggleStatus();
    }
    notifyListeners();
  }

  Task removeTask(int index) {
    Task removedTask = _sortType == SortType.unsorted ? _tasks.removeAt(index) : _sortedTasks.removeAt(index);
    if (_sortType != SortType.unsorted) {
      _tasks.remove(removedTask);
    } else {
      _sortedTasks.remove(removedTask);
    }

    notifyListeners(); 
    return removedTask; 
  }

  Task getTask(int index) {
    return _sortType == SortType.unsorted ? _tasks[index] : _sortedTasks[index];
  }

  void _sortTasks(SortType sortType) {
    List<Task> sortedTasks = List.from(_tasks); 

    switch (sortType) {
      case SortType.deadline:
        sortedTasks.sort((a, b) => a.deadline.compareTo(b.deadline));
        break;
      case SortType.status:
        sortedTasks.sort((a, b) => a.status ? 1 : -1); 
        break;
      case SortType.priority:
        sortedTasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case SortType.unsorted:
      default:
        break;
    }
    _sortedTasks = sortedTasks; 
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
  DateTime get deadline => _deadline; // Deadline sollte nicht null sein
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
enum SortType { unsorted, deadline, status, priority }
