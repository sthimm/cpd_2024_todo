import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_manager.dart';
import '../widgets/button_widget.dart'; 

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
          const SizedBox(height: 30),
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
          const SizedBox(height: 30),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Zentriert die Schaltflächen horizontal
              children: [
                Consumer<TaskManager>(
                  builder: (context, taskManager, child) {
                    return MyElevatedButton(
                      text: 'Save',
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          _formkey.currentState!.save();
                          taskManager.addTask(Task(taskName, taskDescription));
                          Navigator.pushNamed(context, '/');
                        }
                      },
                    );
                  },
                ),
                const SizedBox(width: 30),
                MyElevatedButton(
                  text: 'Cancel',
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

