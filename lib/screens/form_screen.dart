import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_manager.dart';

class MyFormPage extends StatelessWidget {
  final String title;

  const MyFormPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    String taskName = '';
    String taskDescription = '';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: _MyForm(),
      ),
    );
  }
}

class _MyForm extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String taskName = '';
    String taskDescription = '';

    return Form(
      key: _formkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Task name',
              hintText: 'Enter a task name',
            ),
            validator: (String? value) {
              return (value == null || value.trim().isEmpty)
                  ? 'Please enter a task name'
                  : null;
            },
            onSaved: (String? value) {
              taskName = value ?? '';
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Task description',
              hintText: 'Enter a task description',
            ),
            validator: (String? value) {
              return (value == null || value.trim().isEmpty)
                  ? 'Please enter a task description'
                  : null;
            },
            onSaved: (String? value) {
              taskDescription = value ?? '';
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Zentriert die Schaltflächen horizontal
              children: [
                Consumer<TaskManager>(
                  builder: (context, taskManager, child) {
                    return ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          _formkey.currentState!.save();
                          taskManager.addTask(Task(taskName, taskDescription));
                          Navigator.pushNamed(context, '/');
                        }
                      },
                      child: const Text('Save'),
                    );
                  },
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

