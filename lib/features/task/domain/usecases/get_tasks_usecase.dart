import 'package:task_manager_app/features/task/data/models/task_model.dart';

import '../repositories/task_repository.dart';

class GetTasksUseCase {
  final TaskRepository repository;

  GetTasksUseCase(this.repository);

  Future<List<TaskModel>> call() async {
    return await repository.getTasks();
  }
}
