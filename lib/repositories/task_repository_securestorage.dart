import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../repositories/task_repository.dart';
import '../models/task.dart';

class TaskRepositorySecureStorage implements TaskRepository {
  final _storage = const FlutterSecureStorage();

  @override
  Future<void> createTask(Task task) async {
    final String? tasksJson = await _storage.read(key: 'tasks');
    final List<Task> tasks = tasksJson != null
        ? List<Task>.from(jsonDecode(tasksJson).map((task) => Task.fromJson(task)))
        : [];
    tasks.add(task);
    await _storage.write(key: 'tasks', value: jsonEncode(tasks.map((task) => task.toJson()).toList()));
  }

  @override
  Future<List<Task>> readTasks() async {
    final String? tasksJson = await _storage.read(key: 'tasks');
    if (tasksJson != null) {
      final List<dynamic> decoded = jsonDecode(tasksJson);
      return decoded.map((task) => Task.fromJson(task)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    final String? tasksJson = await _storage.read(key: 'tasks');
    if (tasksJson != null) {
      final List<dynamic> decoded = jsonDecode(tasksJson);
      final List<Task> tasks = decoded.map((task) => Task.fromJson(task)).toList();
      final int index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        tasks[index] = task;
        await _storage.write(key: 'tasks', value: jsonEncode(tasks.map((task) => task.toJson()).toList()));
      }
    }
  }

  @override
  Future<void> deleteTask(Task task) async {
    final String? tasksJson = await _storage.read(key: 'tasks');
    if (tasksJson != null) {
      final List<dynamic> decoded = jsonDecode(tasksJson);
      final List<Task> tasks = decoded.map((task) => Task.fromJson(task)).toList();
      tasks.removeWhere((t) => t.id == task.id);
      await _storage.write(key: 'tasks', value: jsonEncode(tasks.map((task) => task.toJson()).toList()));
    }
  }
}