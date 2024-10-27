import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/task.dart';

class FormProvider with ChangeNotifier {
  String _taskName = '';
  String _taskDescription = '';
  TaskPriority _taskPriority = TaskPriority.low;
  DateTime _taskDeadline = DateTime.now();

  String get taskName => _taskName;
  String get taskDescription => _taskDescription;
  TaskPriority get taskPriority => _taskPriority;
  DateTime get taskDeadline => _taskDeadline;

  void setTaskName(String taskName) {
    _taskName = taskName;
  }

  void setTaskDescription(String taskDescription) {
    _taskDescription = taskDescription;
  }

  void setTaskPriority(TaskPriority taskPriority) {
    _taskPriority = taskPriority;
  }

  void setTaskDeadline(DateTime taskDeadline) {
    _taskDeadline = taskDeadline;
  }
}