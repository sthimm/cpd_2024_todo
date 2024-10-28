import 'package:uuid/uuid.dart';

enum TaskPriority {
  low,
  medium,
  high,
}

class Task {
  final String id; // Optional
  final String name;
  final String description;
  final DateTime deadline;
  final TaskPriority priority;
  bool status;

  Task({
    String? id,
    required this.name,
    required this.description,
    required this.deadline,
    required this.priority,
    this.status = false,
  }) : id = id ?? const Uuid().v4();

  void toggleStatus() {
    status = !status;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'priority': priority.index, // Verwenden des Index für die Datenbank
      'status': status ? 1 : 0, // Integrierte Booleans
    };
  }

  static Task fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      deadline: DateTime.parse(json['deadline']),
      priority: TaskPriority.values[json['priority']], // Zugriff über Index
      status: json['status'] == 1, // Boolean Zustand aus int ableiten
    );
  }

  Map<String, dynamic> getInfo() {
    return {
      'Name': name,
      'Description': description,
      'Deadline': deadline.toString().substring(0, 10),
      'Priority': priority.toString().split('.').last,
      'Status': status ? 'Closed' : 'Open',
    };
  }
}
