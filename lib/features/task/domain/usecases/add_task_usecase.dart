import 'package:task_manager_app/features/task/data/models/task_model.dart';

import '../repositories/task_repository.dart';

class AddTaskUseCase {
  final TaskRepository repository;

  AddTaskUseCase(this.repository);

  Future<TaskModel> call(TaskModel task) async {
    return await repository.addTask(task);
  }
}
