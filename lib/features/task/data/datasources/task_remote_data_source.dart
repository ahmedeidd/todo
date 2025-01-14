import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  // Fetches a list of tasks from the remote server.
  Future<List<TaskModel>> fetchTasks();

  // Fetches tasks with pagination.
  Future<List<TaskModel>> fetchTasksWithPagination({
    required int limit,
    required int offset,
  });

  // Adds a new task to the remote server.
  Future<TaskModel> addTask(TaskModel task);

  // Updates an existing task on the remote server.
  Future<TaskModel> updateTask(TaskModel task);

  // Deletes a task from the remote server by its ID.
  Future<bool> deleteTask(int taskId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  TaskRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<List<TaskModel>> fetchTasks() async {
    final response = await client.get(Uri.parse('$baseUrl/todos'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['todos'];
      return jsonList.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  @override
  Future<List<TaskModel>> fetchTasksWithPagination({
    required int limit,
    required int offset,
  }) async {
    final response = await client.get(
      Uri.parse('$baseUrl/todos?limit=$limit&skip=$offset'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['todos'];
      return jsonList.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch paginated tasks');
    }
  }

  @override
  Future<TaskModel> addTask(TaskModel task) async {
    Map body = {'todo': task.todo, 'completed': task.completed, 'userId': 5};
    final response = await client.post(
      Uri.parse('$baseUrl/todos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return TaskModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to add task');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await client.put(
      Uri.parse('$baseUrl/todos/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return TaskModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to update task');
    }
  }

  @override
  Future<bool> deleteTask(int taskId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/todos/$taskId'),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete task');
    }
  }
}
