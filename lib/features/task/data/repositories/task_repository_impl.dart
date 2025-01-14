import 'package:task_manager_app/features/task/data/datasources/task_local_data_source.dart';
import 'package:task_manager_app/features/task/data/datasources/task_remote_data_source.dart';
import 'package:task_manager_app/features/task/data/models/task_model.dart';
import 'package:task_manager_app/features/task/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      // Try fetching tasks from the remote source
      final tasks = await remoteDataSource.fetchTasks();
      // Cache the tasks locally
      await localDataSource.cacheTasks(tasks);
      return tasks;
    } catch (e) {
      // Fallback to local data in case of an error
      return await localDataSource.getCachedTasks();
    }
  }

  @override
  Future<TaskModel> addTask(TaskModel task) async {
    try {
      // Add task to the remote source
      final createdTask = await remoteDataSource.addTask(task);
      // Update local cache
      final currentTasks = await localDataSource.getCachedTasks();
      currentTasks.add(createdTask);
      await localDataSource.cacheTasks(currentTasks);
      return createdTask;
    } catch (e) {
      rethrow; // Re-throw the error to be handled by the caller
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      // Update task in the remote source
      final updatedTask = await remoteDataSource.updateTask(task);
      // Update local cache
      final currentTasks = await localDataSource.getCachedTasks();
      final index = currentTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        currentTasks[index] = updatedTask;
        await localDataSource.cacheTasks(currentTasks);
      }
      return updatedTask;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteTask(int taskId) async {
    try {
      // Delete task from the remote source
      final success = await remoteDataSource.deleteTask(taskId);
      if (success) {
        // Update local cache
        final currentTasks = await localDataSource.getCachedTasks();
        currentTasks.removeWhere((task) => task.id == taskId);
        await localDataSource.cacheTasks(currentTasks);
      }
      return success;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TaskModel>> getTasksWithPagination({
    required int limit,
    required int offset,
  }) async {
    try {
      // Fetch paginated tasks from the remote source
      final tasks = await remoteDataSource.fetchTasksWithPagination(
        limit: limit,
        offset: offset,
      );
      return tasks;
    } catch (e) {
      rethrow;
    }
  }
}
