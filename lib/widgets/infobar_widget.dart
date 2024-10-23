import 'package:flutter/material.dart';
import '../models/task.dart';
import '../widgets/details_dialog.dart';

class InfoBarWidget extends StatelessWidget {
  final Task task; 

  const InfoBarWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12, 
          decoration: BoxDecoration(
            shape: BoxShape.circle, 
            color: _getPriorityColor(),
          ),
        ),
        const SizedBox(width: 12), 
        IconButton(
          icon: const Icon(Icons.info), 
          tooltip: 'Task Info', 
          onPressed: () => DetailsDialog(task: task), 
        ),
      ],
    ); 
  }

  Color _getPriorityColor() {
    switch (task.priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}