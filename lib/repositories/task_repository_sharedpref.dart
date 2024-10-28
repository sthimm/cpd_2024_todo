import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../repositories/task_repository.dart';
import '../models/task.dart';

class TaskRepositorySharedPref implements TaskRepository {
  
  @override
  Future<void> createTask(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> tasks = prefs.getStringList('tasks') ?? [];
    tasks.add(jsonEncode(task.toJson()));
    prefs.setStringList('tasks', tasks);
  }

  @override
  Future<List<Task>> readTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> tasks = prefs.getStringList('tasks') ?? [];
    return tasks.map((task) => Task.fromJson(jsonDecode(task))).toList();
  }

  @override
  Future<void> updateTask(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> tasks = prefs.getStringList('tasks') ?? [];
    final index = tasks.indexWhere((element) => Task.fromJson(jsonDecode(element)).id == task.id);
    tasks[index] = jsonEncode(task.toJson());
    prefs.setStringList('tasks', tasks);
  }

  @override
  Future<void> deleteTask(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> tasks = prefs.getStringList('tasks') ?? [];
    tasks.removeWhere((element) => Task.fromJson(jsonDecode(element)).id == task.id);
    prefs.setStringList('tasks', tasks);
  }

}
