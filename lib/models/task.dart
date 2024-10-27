enum TaskPriority {
  low,
  medium,
  high,
}

class Task {
  final int? id; // Optional 
  final String name;
  final String description;
  final DateTime deadline;
  final TaskPriority priority;
  bool status;

  Task({
    this.id,
    required this.name,
    required this.description,
    required this.deadline,
    required this.priority, 
    this.status = false, 
  });

  void toggleStatus() {
    status = !status;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'priority': priority.toString().split('.').last,
      'status': status,
    };
  }

  static Task fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name'],
      description: json['description'],
      deadline: DateTime.parse(json['deadline']),
      priority: TaskPriority.values.firstWhere(
          (e) => e.toString() == 'TaskPriority.${json['priority']}'),
      status: json['status'], // Korrekte Zuordnung
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
