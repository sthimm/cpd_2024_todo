import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';
import '../models/sort.dart';

class TaskRepository {
  final List<Task> tasks = [];
  SortType _currentsortType = SortType.byPriority;

  void addTask(Task task) {
    tasks.add(task);
    sortTasks(); 
    saveData();
  }

  void toggleTask(int index) {
    tasks[index].toggleStatus();
    saveData();
  }

  Task removeTask(int index) {
    Task removedTask = tasks.removeAt(index);
    saveData();
    return removedTask;
  }

  Task getTask(int index) => tasks[index];

  List<Task> getTasks() => List<Task>.from(tasks);

  void setSortType(SortType sortType) {
    _currentsortType = sortType;
    sortTasks();
  }

  SortType getSortType() => _currentsortType;

  void sortTasks() {
    switch (_currentsortType) {
      case SortType.byPriority:
        tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case SortType.byDeadline:
        tasks.sort((a, b) => a.deadline.compareTo(b.deadline));
        break;
      case SortType.byStatus:
        tasks.sort((a, b) => a.status ? 1 : -1);
        break;
    }
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonTasks = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', jsonTasks);
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonTasks = prefs.getStringList('tasks');
    if (jsonTasks == null) return;
    tasks.addAll(jsonTasks.map((json) => Task.fromJson(jsonDecode(json))).toList()); 
  }
}
