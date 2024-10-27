import '../models/task.dart';
import '../models/sort.dart';

class TaskRepository {
  final List<Task> tasks = [];
  SortType _currentsortType = SortType.byPriority;

  void addTask(Task task) {
    tasks.add(task);
    sortTasks(); 
  }

  void toggleTask(int index) {
    tasks[index].toggleStatus();
  }

  Task removeTask(int index) {
    return tasks.removeAt(index);
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
}
