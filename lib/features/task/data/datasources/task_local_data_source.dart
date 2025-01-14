import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<void> cacheTasks(List<TaskModel> tasks);
  Future<List<TaskModel>> getCachedTasks();
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  @override
  Future<void> cacheTasks(List<TaskModel> tasks) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString('cachedTasks', jsonString);
  }

  @override
  Future<List<TaskModel>> getCachedTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('cachedTasks');
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
