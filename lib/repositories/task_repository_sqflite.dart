import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../repositories/task_repository.dart';
import '../models/task.dart';

class TaskRepositorySqflite implements TaskRepository {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE tasks(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            deadline TEXT NOT NULL,
            priority INTEGER NOT NULL,
            status INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<void> createTask(Task task) async {
    final db = await database;
    await db.insert(
      'tasks',
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<Task>> readTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return Task.fromJson(maps[i]);
    });
  }

  @override
  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      task.toJson(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  @override
  Future<void> deleteTask(Task task) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: "id = ?",
      whereArgs: [task.id],
    );
  }
}