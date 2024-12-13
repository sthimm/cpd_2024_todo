import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/details_dialog.dart';
import '../widgets/infobar_widget.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Theme.of(context).colorScheme.primary,
          ),
          itemCount: taskProvider.getTasks().length,
          itemBuilder: (context, index) {
            final task = taskProvider.getTask(index);
            return Dismissible(
              key: Key(task.name),
              onDismissed: (direction) async {
                taskProvider.removeTask(index);
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
                // onTap: () => taskProvider.toggleTask(index),
                onDoubleTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => DetailsDialog(task: task),
                  );
                },
                child: ListTile(
                  title: Text(task.name),
                  subtitle: Text("due ${task.deadline.toString().substring(0, 10)}"),
                  leading: Checkbox(
                    value: task.status,
                    onChanged: (value) {
                      taskProvider.toggleTask(index);
                      taskProvider.sortTasks(); 
                    },
                  ),
                  trailing: InfoBarWidget(task: task),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
