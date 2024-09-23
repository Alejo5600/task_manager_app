import 'package:flutter/material.dart';
import '../services/task_service.dart';
import 'task_card_page.dart';

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage>
    with SingleTickerProviderStateMixin {
  final TaskService taskService = TaskService();
  List<dynamic> tasks = [];
  List<dynamic> completedTasks = [];
  List<dynamic> pendingTasks = [];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchTasks();

    _tabController?.addListener(() {
      setState(() {}); // Forzamos la reconstrucción al cambiar de pestaña
    });
  }

  void fetchTasks() async {
    try {
      final data = await taskService.getTasks();
      setState(() {
        tasks = data;
        completedTasks = tasks.where((task) => task['status'] == 1).toList();
        pendingTasks = tasks.where((task) => task['status'] == 0).toList();
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Tareas',
            style: TextStyle(
                color:
                    Theme.of(context).colorScheme.onPrimary), // Texto en blanco
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh,
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimary), // Ícono en blanco
              onPressed: () {
                fetchTasks(); // Actualiza las tareas al refrescar
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: Theme.of(context)
                .colorScheme
                .onPrimary, // Texto blanco en pestaña seleccionada
            unselectedLabelColor: Theme.of(context)
                .colorScheme
                .onPrimary, // Texto blanco en no seleccionada
            tabs: [
              Tab(
                  icon: Icon(Icons.list,
                      color: Theme.of(context).colorScheme.onPrimary),
                  text: 'Todas'),
              Tab(
                  icon: Icon(Icons.check_circle,
                      color: Theme.of(context).colorScheme.onPrimary),
                  text: 'Completas'),
              Tab(
                  icon: Icon(Icons.cancel,
                      color: Theme.of(context).colorScheme.onPrimary),
                  text: 'Pendientes'),
            ],
            indicatorColor:
                Theme.of(context).colorScheme.onPrimary, // Color del indicador
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            taskGridView(tasks), // Muestra todas las tareas
            taskGridView(completedTasks), // Muestra las tareas completadas
            taskGridView(pendingTasks), // Muestra las tareas pendientes
          ],
        ),
      ),
    );
  }

  Widget taskGridView(List<dynamic> taskList) {
    return taskList.isEmpty
        ? Center(child: Text('No hay tareas'))
        : LayoutBuilder(
            builder: (context, constraints) {
              // Definir el número de columnas según el ancho de la pantalla
              final crossAxisCount = constraints.maxWidth > 800
                  ? 3
                  : (constraints.maxWidth > 600 ? 2 : 1);

              return Container(
                color: Theme.of(context)
                    .colorScheme
                    .surface, // Color de fondo según el tema
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: crossAxisCount == 1
                        ? 1.5
                        : (crossAxisCount == 2 ? 1.3 : 1),
                  ),
                  itemCount: taskList.length,
                  itemBuilder: (context, index) {
                    final task = taskList[index];
                    return TaskCard(
                      task: task,
                      refreshTasks: fetchTasks,
                    );
                  },
                ),
              );
            },
          );
  }
}
