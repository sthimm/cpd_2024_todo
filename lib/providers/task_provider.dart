import 'package:flutter/foundation.dart';
import '../repositories/task_repository.dart';
import '../models/task.dart';
import '../models/sort.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _taskRepository;  

  TaskProvider(this._taskRepository){
    _initalize(); 
  }

  Future<void> _initalize() async {
    await _taskRepository.loadData();
    notifyListeners();
  }

  void addTask(Task task) {
    _taskRepository.addTask(task);
    notifyListeners();
  }

  void toggleTask(int index) {
    _taskRepository.toggleTask(index);
    notifyListeners();
  }

  Task removeTask(int index) {
    Task removedTask = _taskRepository.removeTask(index);
    notifyListeners();
    return removedTask;
  }

  Task getTask(int index) {
    return _taskRepository.getTask(index);
  }

  List<Task> getTasks() {
    return _taskRepository.getTasks();
  }

  void setSortType(SortType sortType) {
    _taskRepository.setSortType(sortType);
    notifyListeners();
  }

  SortType getSortType() {
    return _taskRepository.getSortType();
  }

  void sortTasks() {
    _taskRepository.sortTasks();
    notifyListeners();
  }
}