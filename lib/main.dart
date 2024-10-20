import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/task_manager.dart';
import 'models/date_picker.dart'; 
import 'screens/home_screen.dart';
import 'screens/form_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyTaskManager()),
        ChangeNotifierProvider(create: (context) => MyDatePicker()),
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
        '/': (context) => const MyHomePage(),
        '/add-task': (context) => const MyFormPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
