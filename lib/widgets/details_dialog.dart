import 'package:flutter/material.dart';
import '../models/task.dart';

class DetailsDialog extends StatelessWidget {
  final Task task;

  const DetailsDialog({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Task Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min, // Minimale Höhe für den Dialog
        crossAxisAlignment: CrossAxisAlignment.start, // Ausrichtung links
        children: task.getInfo().entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Ausrichtung links
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0), // Abstand unten
                child: Text(
                  '${entry.key}:',
                  style: const TextStyle(
                      fontWeight:
                          FontWeight.bold), // Fettdruck für den Schlüssel
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
  }
}
