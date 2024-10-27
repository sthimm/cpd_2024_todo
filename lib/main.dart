import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'providers/form_provider.dart';
import 'repositories/task_repository_sqlite.dart';
import 'screens/task_screen.dart';
import 'screens/form_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider(TaskRepositorySqlite())),
        ChangeNotifierProvider(create: (context) => FormProvider()),
      ],
      child: const ToDoListApp(),
    ),
  );
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
        '/': (context) => const MyTaskPage(),
        '/add-task': (context) => MyFormPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
