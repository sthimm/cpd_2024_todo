import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../widgets/details_dialog.dart';
import '../widgets/infobar_widget.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

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
            return Dismissible(
              key: Key(taskProvider.getTask(index).name),
              onDismissed: (direction) {
                Task task = taskProvider.removeTask(index);
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
                onTap: () => taskProvider.toggleTask(index),
                onDoubleTap: () => DetailsDialog(task: taskProvider.getTask(index)),
                child: ListTile(
                  title: Text(taskProvider.getTask(index).name),
                  subtitle: Text(taskProvider.getTask(index).deadline.toString()),
                  leading: Checkbox(
                    value: taskProvider.getTask(index).status,
                    onChanged: (value) => taskProvider.toggleTask(index),
                  ),
                  trailing: InfoBarWidget(task: taskProvider.getTask(index)),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
