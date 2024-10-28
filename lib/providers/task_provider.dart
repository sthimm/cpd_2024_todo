import 'package:flutter/foundation.dart';
import '../repositories/task_repository.dart';
import '../models/task.dart';
import '../models/sort.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _taskRepository;  
  List<Task> tasks = [];
  SortType _currentsortType = SortType.byPriority;

  TaskProvider(this._taskRepository); 

  List<Task> getTasks() => List<Task>.from(tasks);
  Task getTask(int index) => tasks[index];

  Future<void> loadTasks() async {
    tasks = await _taskRepository.readTasks();
    sortTasks();
    notifyListeners(); 
  }

  Future<void> addTask(Task task) async {
    tasks.add(task);
    await _taskRepository.createTask(task);
    sortTasks(); 
    notifyListeners();
  }

  Future<void> toggleTask(int index) async {
    final task = tasks[index]; 
    task.toggleStatus();
    await _taskRepository.updateTask(task);
    if (_currentsortType == SortType.byStatus) {
      sortTasks();
    }
    notifyListeners();
  }

  Future<void> removeTask(int index) async {
    Task removedTask = tasks.removeAt(index);
    await _taskRepository.deleteTask(removedTask);
    notifyListeners();
  }

  void setSortType(SortType sortType) {
    _currentsortType = sortType;
    sortTasks(); 
    notifyListeners();
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
    notifyListeners();
  }
}