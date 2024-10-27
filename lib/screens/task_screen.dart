import 'package:flutter/material.dart';
import '../widgets/sort_dialog.dart';
import '../widgets/task_list_widget.dart';

class MyTaskPage extends StatelessWidget {
  const MyTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return const SortDialog();
              },
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: TaskListWidget(),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add-task');
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
