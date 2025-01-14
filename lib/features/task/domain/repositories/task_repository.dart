import 'package:task_manager_app/features/task/data/models/task_model.dart';

abstract class TaskRepository {
  /// Fetches a list of tasks.
  Future<List<TaskModel>> getTasks();

  /// Adds a new task.
  Future<TaskModel> addTask(TaskModel task);

  /// Updates an existing task.
  Future<TaskModel> updateTask(TaskModel task);

  /// Deletes a task by its ID.
  Future<bool> deleteTask(int taskId);

  /// Fetches tasks using pagination.
  Future<List<TaskModel>> getTasksWithPagination(
      {required int limit, required int offset});
}
