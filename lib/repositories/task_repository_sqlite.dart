import 'dart:async';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../repositories/task_repository.dart';
import '../models/task.dart';

class TaskRepositorySqlite implements TaskRepository {
  late Database _db;
  final _dbLock = Completer<void>();

  TaskRepositorySqlite() {
    _init();
  }

  Future<void> _init() async {
    try {
      final dbPath =
          join((await getApplicationDocumentsDirectory()).path, 'tasks.db');
      _db = sqlite3.open(dbPath);

      _db.execute('''
        CREATE TABLE IF NOT EXISTS tasks(
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          description TEXT NOT NULL,
          deadline TEXT NOT NULL,
          priority INTEGER NOT NULL,
          status INTEGER NOT NULL
        )
      ''');

      print("Initialized SQLite Database");
      _dbLock.complete();
    } catch (e) {
      print("Error initializing SQLite Database: $e");
      _dbLock.completeError(e);
    }
  }

  @override
  Future<void> createTask(Task task) async {
    await _dbLock.future;
    _db.execute('''
      INSERT INTO tasks(id, name, description, deadline, priority, status)
      VALUES(?, ?, ?, ?, ?, ?)
    ''', [
      task.id,
      task.name,
      task.description,
      task.deadline.toIso8601String(),
      task.priority.index,
      task.status ? 1 : 0
    ]);
  }

  @override
  Future<List<Task>> readTasks() async {
    await _dbLock.future;
    final result = _db.select('SELECT * FROM tasks');
    return result.map((row) {
      return Task(
        id: row['id'] as String,
        name: row['name'] as String,
        description: row['description'] as String,
        deadline: DateTime.parse(row['deadline'] as String),
        priority: TaskPriority.values[row['priority'] as int],
        status: (row['status'] as int) == 1,
      );
    }).toList();
  }

  @override
  Future<void> updateTask(Task task) async {
    await _dbLock.future;
    _db.execute('''
      UPDATE tasks
      SET name = ?, description = ?, deadline = ?, priority = ?, status = ?
      WHERE id = ?
    ''', [
      task.name,
      task.description,
      task.deadline.toIso8601String(),
      task.priority.index,
      task.status ? 1 : 0,
      task.id,
    ]);
  }

  @override
  Future<void> deleteTask(Task task) async {
    await _dbLock.future;
    _db.execute('DELETE FROM tasks WHERE id = ?', [task.id]);
  }
}
