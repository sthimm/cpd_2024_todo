import '../models/task.dart';

abstract class TaskRepository {
  Future<void> createTask(Task task);
  Future<List<Task>> readTasks();
  Future<void> updateTask(Task task);
  Future<void> deleteTask(Task task); 
}