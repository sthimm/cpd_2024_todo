import '../models/task.dart';
import '../models/sort.dart';

class TaskRepository {
  final List<Task> tasks = [];
  SortType _currentsortType = SortType.byPriority;
  SortDirection _currentsortDirection = SortDirection.ascending;

  void addTask(Task task) {
    print('Adding task');
    tasks.add(task);
    _sortTasks(tasks); 
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
    _sortTasks(tasks);
  }

  SortType getSortType() => _currentsortType;

  void setSortDirection(SortDirection sortDirection) {
    _currentsortDirection = sortDirection;
    _sortTasks(tasks);
  }

  SortDirection getSortDirection() => _currentsortDirection;

  void _sortTasks(List<Task> tasks) {
    switch (_currentsortType) {
      case SortType.byPriority:
        tasks.sort((a, b) => a.priority.index.compareTo(b.priority.index));
        break;
      case SortType.byDeadline:
        tasks.sort((a, b) => a.deadline.compareTo(b.deadline));
        break;
      case SortType.byStatus:
        tasks.sort((a, b) => a.status ? 1 : -1);
        break;
    }

    if (_currentsortDirection == SortDirection.descending) {
      tasks.reversed.toList();
    }
  }
}
