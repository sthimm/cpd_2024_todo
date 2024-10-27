import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';
import '../models/sort.dart';
import 'task_repository.dart';

class TaskRepositorySqlite implements TaskRepository {
  late final Database db;
  final List<Task> tasks = [];
  SortType _currentsortType = SortType.byPriority;

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'tasks.db');

    db = sqlite3.open(path);

    db.execute('''
      CREATE TABLE IF NOT EXISTS tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        priority INTEGER NOT NULL,
        deadline TEXT NOT NULL,
        status INTEGER NOT NULL
      )
    ''');

    await loadData();
  }

  @override
  Future<void> addTask(Task task) async {
    final stmt = db.prepare('''
      INSERT INTO tasks (name, description, priority, deadline, status)
      VALUES (?, ?, ?, ?, ?)
    ''');
    stmt.execute([
      task.name,
      task.description,
      task.priority.index,
      task.deadline.toIso8601String(),
      task.status ? 1 : 0,
    ]);
    stmt.dispose();

    tasks.add(task);
    sortTasks();
  }

  @override
  Future<void> toggleTask(int id) async {
    final task = getTaskById(id);
    if (task != null) {
      final newStatus = !task.status;
      final stmt = db.prepare('''
        UPDATE tasks
        SET status = ?
        WHERE id = ?
      ''');
      stmt.execute([newStatus ? 1 : 0, id]);
      stmt.dispose();

      task.toggleStatus();
    }
  }

  @override
  Task removeTask(int id) {
    final task = getTaskById(id);
    if (task == null) {
      throw Exception('Task with id $id not found');
    }
    final deleteStmt = db.prepare('DELETE FROM tasks WHERE id = ?');
    deleteStmt.execute([id]);
    deleteStmt.dispose();
    tasks.remove(task);
    return task;
  }

  Task? getTaskById(int id) {
    try {
      return tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null; 
    }
  }

  @override
  Task getTask(int id) {
    final task = getTaskById(id);
    if (task == null) {
      throw Exception('Task with id $id not found');
    }
    return task;
  }

  @override
  List<Task> getTasks() {
    return List<Task>.from(tasks);
  }

  @override
  void setSortType(SortType sortType) {
    _currentsortType = sortType;
    sortTasks();
  }

  @override
  SortType getSortType() => _currentsortType;

  @override
  void sortTasks() {
    switch (_currentsortType) {
      case SortType.byPriority:
        tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case SortType.byDeadline:
        tasks.sort((a, b) => a.deadline.compareTo(b.deadline));
        break;
      case SortType.byStatus:
        tasks.sort((a, b) => a.status ? -1 : 1);
        break;
    }
  }

  @override
  Future<void> loadData() async {
    tasks.clear();
    final result = db.select('SELECT * FROM tasks');
    tasks.addAll(result.map((row) {
      return Task(
        id: row['id'] as int,
        name: row['name'] as String,
        description: row['description'] as String,
        priority: TaskPriority.values[row['priority'] as int],
        deadline: DateTime.parse(row['deadline'] as String),
        status: (row['status'] as int) == 1,
      );
    }).toList());
  }

  @override
  Future<void> saveData() {
    throw UnimplementedError();
  }
}