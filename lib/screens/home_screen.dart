import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_manager.dart';
import '../widgets/button_widget.dart'; 

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Consumer<TaskManager>(
              builder: (context, taskManager, child) {
                return ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  itemCount: taskManager.tasks.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(taskManager.tasks[index].name),
                      onDismissed: (direction) {
                        Task task = taskManager.removeTask(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${task.name} dismissed'),
                          ),
                        );
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        title: Text(taskManager.tasks[index].name),
                        subtitle: Text(taskManager.tasks[index].description),
                        leading: Checkbox(
                          value: taskManager.tasks[index].status,
                          onChanged: (bool? value) {
                            taskManager.toggleTask(index);
                          },
                        ),
                      ),
                    ); 
                  },
                );
              },
            )),
            const SizedBox(height: 30),
            MyElevatedButton(
              text: 'Add a new task',
              onPressed: () {
                Navigator.pushNamed(context, '/add-task');
              },
            ),
          ],
        ),
      ),
    );
  }
}
