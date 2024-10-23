import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskListProvider with ChangeNotifier {
  final List<Task> _tasks = [];
  List<Task> _sortedTasks = [];
  SortType _sortType = SortType.unsorted;

  TaskListProvider() {
    _loadTasks();
  }

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
    _saveTasks(); 
    _sortTasks(sortType);
    notifyListeners();
  }

  void toggleTask(int index) {
    if (_sortType == SortType.unsorted) {
      _tasks[index].toggleStatus();
    } else {
      _sortedTasks[index].toggleStatus();
    }
    _saveTasks(); 
    notifyListeners();
  }

  Task removeTask(int index) {
    Task removedTask = _sortType == SortType.unsorted ? _tasks.removeAt(index) : _sortedTasks.removeAt(index);
    if (_sortType != SortType.unsorted) {
      _tasks.remove(removedTask);
    } else {
      _sortedTasks.remove(removedTask);
    }
    
    _saveTasks(); 
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

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonTasks = _tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', jsonTasks);
    print('Saved tasks: $jsonTasks');
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonTasks = prefs.getStringList('tasks');
    if (jsonTasks != null) {
      _tasks.addAll(jsonTasks.map((json) => Task.fromJson(jsonDecode(json))).toList());
      print('Loaded tasks: $jsonTasks');
      notifyListeners(); 
    } else {
      print('No tasks found');
    }
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

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'description': _description,
      'deadline': _deadline.toIso8601String(),
      'priority': _priority.toString().split('.').last,
      'status': _status,
    };
  }

  static Task fromJson(Map<String, dynamic> json) {
    return Task(
      json['name'],
      json['description'],
      DateTime.parse(json['deadline']),
      TaskPriority.values.firstWhere((e) => e.toString() == 'TaskPriority.${json['priority']}'),
    ).._status = json['status']; // Status setzen
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
