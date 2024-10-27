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
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TaskListWidget(),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-task');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
