import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_manager.dart';
import '../widgets/button_widget.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Consumer<MyTaskManager>(
          builder: (context, taskManager, child) {
            return IconButton(
              icon: const Icon(Icons.sort),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Sort Tasks'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text('Sort by Deadline'),
                            onTap: () {
                              taskManager.sortTasks('Deadline');
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: const Text('Sort by Status'),
                            onTap: () {
                              taskManager.sortTasks('Status');
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Consumer<MyTaskManager>(
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
                          _showTaskInfoDialog(
                              context, taskManager.tasks[index]);
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
                                        ? '${taskManager.tasks[index].name} closed'
                                        : '${taskManager.tasks[index].name} opened',
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    taskManager.tasks[index].deadline
                                        .toString()
                                        .substring(0, 10),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors
                                            .grey), // Kleinere Schriftgröße und graue Farbe für das Datum
                                  ),
                                ],
                              ),
                              const SizedBox(
                                  width: 8), // Abstand zwischen Datum und Icons
                              IconButton(
                                icon: const Icon(Icons.info),
                                tooltip: 'Task Info',
                                onPressed: () {
                                  _showTaskInfoDialog(
                                      context, taskManager.tasks[index]);
                                },
                              ),
                              const SizedBox(
                                  width: 8), // Abstand zwischen den Icons
                              IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'Delete Task',
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
    Map<String, dynamic> taskInfo =
        task.getInfo(); // Aufruf der getInfo-Methode

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
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Ausrichtung links
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8.0), // Abstand unten
                    child: Text(
                      '${entry.key}:',
                      style: const TextStyle(
                          fontWeight:
                              FontWeight.bold), // Fettdruck für den Schlüssel
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 16.0), // Abstand unten
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
