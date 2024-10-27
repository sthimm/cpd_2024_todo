import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/form_provider.dart';
import '../models/task.dart';

class MyFormPage extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController = TextEditingController();
  final TextEditingController _taskDeadlineController = TextEditingController();

  MyFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final formProvider = Provider.of<FormProvider>(context);

    _taskNameController.text = formProvider.taskName;
    _taskDescriptionController.text = formProvider.taskDescription;
    _taskDeadlineController.text = formProvider.taskDeadline.toString().substring(0, 10);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _taskNameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter a task name',
                ),
                validator: (String? value) {
                  return (value == null || value.trim().isEmpty)
                      ? 'Please enter a task name'
                      : null;
                },
                onChanged: (value) {
                  formProvider.setTaskName(value);
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _taskDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter a task description',
                ),
                validator: (String? value) {
                  return (value == null || value.trim().isEmpty)
                      ? 'Please enter a task description'
                      : null;
                },
                onChanged: (value) {
                  formProvider.setTaskDescription(value);
                },
              ),
              const SizedBox(height: 30),
              DropdownButtonFormField<TaskPriority>(
                decoration: const InputDecoration(
                  labelText: 'Priority',
                ),
                value: formProvider.taskPriority,
                onChanged: (TaskPriority? value) {
                  if (value != null) {
                    formProvider.setTaskPriority(value);
                  }
                },
                items: TaskPriority.values.map((TaskPriority priority) {
                  return DropdownMenuItem<TaskPriority>(
                    value: priority,
                    child: Text(priority.toString().split('.').last),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _taskDeadlineController,
                decoration: const InputDecoration(
                  labelText: 'Deadline',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _showDatePicker(context, formProvider),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    taskProvider.addTask(
                      Task(
                        name: formProvider.taskName,
                        description: formProvider.taskDescription,
                        deadline: formProvider.taskDeadline,
                        priority: formProvider.taskPriority,
                      ),
                    );

                    formProvider.setTaskName('');
                    formProvider.setTaskDescription('');

                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context, FormProvider formProvider) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Confirm'),
                    onPressed: () {
                      _taskDeadlineController.text = formProvider.taskDeadline.toString().substring(0, 10);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                initialDateTime: formProvider.taskDeadline,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime newDate) {
                  formProvider.setTaskDeadline(newDate);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}