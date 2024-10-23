import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/task_provider.dart';
import '../widgets/sort_dialog.dart';
import '../widgets/task_list.dart';

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
                return SortDialog();
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
              child: TaskList(),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add_task');
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
