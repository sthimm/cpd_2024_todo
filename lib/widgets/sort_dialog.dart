import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../providers/task_provider.dart';
import '../models/sort.dart';

class SortDialog extends StatelessWidget {
  const SortDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sort by'),
      content: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Priority'),
                selected: taskProvider.getSortType() == SortType.byPriority,
                onTap: () => taskProvider.setSortType(SortType.byPriority),
              ),
              ListTile(
                title: const Text('Deadline'),
                selected: taskProvider.getSortType() == SortType.byDeadline,
                onTap: () => taskProvider.setSortType(SortType.byDeadline),
              ),
              ListTile(
                title: const Text('Status'),
                selected: taskProvider.getSortType() == SortType.byStatus,
                onTap: () => taskProvider.setSortType(SortType.byStatus),
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}