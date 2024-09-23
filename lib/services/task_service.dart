import 'package:http/http.dart' as http;
import 'dart:convert';

class TaskService {
  final String baseUrl = 'http://localhost:8000/api/tasks';

  Future<List<dynamic>> getTasks() async {
    final response = await http.get(Uri.parse(baseUrl));
    return json.decode(response.body);
  }

  Future<void> updateTaskStatus(int id, int status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar la tarea');
    }
  }
}
