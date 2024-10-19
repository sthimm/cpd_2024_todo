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
                            content: Text('${task.name} deleted'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      background: Container(
                        color: Theme.of(context).colorScheme.error,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          taskManager.toggleTask(index);
                        },
                        onDoubleTap: () {
                          _showTaskInfoDialog(context, taskManager.tasks[index]);
                        },
                        child: ListTile(
                          title: Text(taskManager.tasks[index].name),
                          leading: Checkbox(
                            value: taskManager.tasks[index].status,
                            onChanged: (bool? value) {
                              taskManager.toggleTask(index);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    taskManager.tasks[index].status
                                        ? '${taskManager.tasks[index].name} done'
                                        : '${taskManager.tasks[index].name} to be done',
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.info),
                                onPressed: () {
                                  _showTaskInfoDialog(context, taskManager.tasks[index]);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  Task task = taskManager.removeTask(index);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${task.name} deleted'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
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

  void _showTaskInfoDialog(BuildContext context, Task task) {
    Map<String, dynamic> taskInfo = task.getInfo(); // Aufruf der getInfo-Methode

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Task Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Minimale Höhe für den Dialog
            crossAxisAlignment: CrossAxisAlignment.start, // Ausrichtung links
            children: taskInfo.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Ausrichtung links
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0), // Abstand unten
                    child: Text(
                      '${entry.key}:',
                      style: const TextStyle(fontWeight: FontWeight.bold), // Fettdruck für den Schlüssel
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0), // Abstand unten
                    child: Text(entry.value.toString()), // Wert als Text
                  ),
                ],
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Schließt den Dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

}
