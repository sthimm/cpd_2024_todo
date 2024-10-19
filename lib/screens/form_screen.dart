import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_manager.dart';

class MyFormPage extends StatelessWidget {
  final String title;

  const MyFormPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: _MyForm(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Switch back to home screen
          Navigator.pushNamed(context, '/');
        },
        tooltip: 'Enter',
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}

class _MyForm extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();

  String _taskName = ''; 
  String _taskDescription = ''; 

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Task name',
            ),
            validator: (String? value) {
              return (value == null || value.trim().isEmpty) ? 
                'Please enter a task name' : null;
            },
            onSaved: (String? value) {
              _taskName = value ?? '';
            },
          ), 
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Task description',
            ),
            validator: (String? value) {
              return (value == null || value.trim().isEmpty) ? 
                'Please enter a task description' : null;
            },
            onSaved: (String? value) {
              _taskDescription = value ?? '';
            },
          ),
          const SizedBox(height: 20), 
          Consumer<TaskManager>(
            builder: (context, taskManager, child) {
              return ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    _formkey.currentState!.save();
                    taskManager.addTask(Task(_taskName, _taskDescription));
                    Navigator.pushNamed(context, '/');
                  }
                },
                child: const Text('Add task'),
              );
            },
          ),
        ],
      )
    ); 
  }
}
