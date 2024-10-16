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
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(title: 'To Do List App'),
        '/form': (context) => const FormScreen(title: 'Add a new task'),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
