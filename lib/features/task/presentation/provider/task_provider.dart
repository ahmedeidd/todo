import 'package:flutter/foundation.dart';
import 'package:task_manager_app/features/task/data/models/task_model.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import '../../domain/usecases/get_tasks_with_pagination_usecase.dart';

class TaskProvider with ChangeNotifier {
  final GetTasksUseCase getTasksUseCase;
  final AddTaskUseCase addTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final GetTasksWithPaginationUseCase getTasksWithPaginationUseCase;

  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  TaskProvider({
    required this.getTasksUseCase,
    required this.addTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
    required this.getTasksWithPaginationUseCase,
  });

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTasks() async {
    _setLoading(true);
    try {
      _tasks = await getTasksUseCase();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load tasks';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchTasksWithPagination(int limit, int offset) async {
    _setLoading(true);
    try {
      final paginatedTasks = await getTasksWithPaginationUseCase(
        limit: limit,
        offset: offset,
      );
      _tasks.addAll(paginatedTasks);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load more tasks';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addTask(TaskModel task) async {
    _setLoading(true);
    try {
      final newTask = await addTaskUseCase(task);
      _tasks.add(newTask);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add task';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateTask(TaskModel task) async {
    _setLoading(true);
    try {
      final updatedTask = await updateTaskUseCase(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to update task';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTask(int taskId) async {
    _setLoading(true);
    try {
      final success = await deleteTaskUseCase(taskId);
      if (success) {
        _tasks.removeWhere((task) => task.id == taskId);
        notifyListeners();
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to delete task';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
