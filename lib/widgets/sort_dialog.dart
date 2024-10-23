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
                title: const Text('By Priority'),
                selected: taskProvider.getSortType() == SortType.byPriority,
                onTap: () => taskProvider.setSortType(SortType.byPriority),
              ),
              ListTile(
                title: const Text('By Deadline'),
                selected: taskProvider.getSortType() == SortType.byDeadline,
                onTap: () => taskProvider.setSortType(SortType.byDeadline),
              ),
              ListTile(
                title: const Text('By Status'),
                selected: taskProvider.getSortType() == SortType.byStatus,
                onTap: () => taskProvider.setSortType(SortType.byStatus),
              ),
              const Divider(),
              ListTile(
                title: const Text('Ascending'),
                selected: taskProvider.getSortDirection() == SortDirection.ascending,
                onTap: () =>
                    taskProvider.setSortDirection(SortDirection.ascending),
              ),
              ListTile(
                title: const Text('Descending'),
                selected: taskProvider.getSortDirection() == SortDirection.descending,
                onTap: () =>
                    taskProvider.setSortDirection(SortDirection.descending),
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