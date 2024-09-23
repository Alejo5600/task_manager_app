import 'package:flutter/material.dart';
import '../services/task_service.dart';

class TaskCard extends StatelessWidget {
  final dynamic task;
  final TaskService taskService = TaskService();
  final Function refreshTasks;

  TaskCard({required this.task, required this.refreshTasks});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTaskDetails(context),
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    task['status'] == 1 ? Icons.check_circle : Icons.cancel,
                    color: task['status'] == 1 ? Colors.green : Colors.red,
                    size: 30,
                  ),
                  SizedBox(width: 8), // Espacio entre el ícono y el título
                  Expanded(
                    child: Text(
                      task['title'],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow
                          .ellipsis, // Para truncar el texto si es largo
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Spacer(),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Alinea el botón a la derecha
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await toggleTaskStatus(context);
                    },
                    child: Text(task['status'] == 1
                        ? 'Marcar como Pendiente'
                        : 'Completar Tarea'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> toggleTaskStatus(BuildContext context) async {
    try {
      // Cambiar el estado de la tarea
      await taskService.updateTaskStatus(
          task['id'], task['status'] == 1 ? 0 : 1);
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Estado de la tarea actualizado')),
      );
      refreshTasks();
    } catch (e) {
      print('Error al cambiar el estado: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar la tarea')),
      );
    }
  }

  void _showTaskDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              task['status'] == 1 ? "Tarea Completa" : "Tarea sin completar"),
          content: Text(task['title']),
          actions: [
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
