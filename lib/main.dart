import 'package:flutter/material.dart';
import 'pages/task_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            primary: Colors.blue, // Asegúrate de definir el color primario
            onPrimary: Colors.white, // Color del texto en el AppBar
            secondary: Colors.blueAccent, // Color secundario opcional
            surface: Colors.grey[200]),
      ),
      home: TaskListPage(), // Página de la lista de tareas
    );
  }
}
