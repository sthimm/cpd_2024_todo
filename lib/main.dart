import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/task_manager.dart';
import 'screens/home_screen.dart';
import 'screens/form_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => TaskManager(),
    child: const ToDoListApp(),
  ));
}

class ToDoListApp extends StatelessWidget {
  const ToDoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: 'To Do List App'),
        '/add-task': (context) => const MyFormPage(title: 'Add a new task'),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
