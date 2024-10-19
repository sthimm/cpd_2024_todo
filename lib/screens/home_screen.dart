import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_manager.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: _MyListView()
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Switch to form to add a new task
          Navigator.pushNamed(context, '/add-task');
        },
        tooltip: 'Hinzufügen',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _MyListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskManager>(
      builder: (context, taskManager, child) {
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Theme.of(context).colorScheme.primary,
          ),
          itemCount: taskManager.tasks.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(taskManager.tasks[index].name),
              subtitle: Text(taskManager.tasks[index].description),
              leading: Checkbox(
                value: taskManager.tasks[index].status,
                onChanged: (bool? value) {
                  taskManager.toggleTask(index); // Update the task's status
                },
              ),
            ); 
          },
        );
      },
    );
  }
}

