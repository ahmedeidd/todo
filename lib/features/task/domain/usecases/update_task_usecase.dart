import 'package:task_manager_app/features/task/data/models/task_model.dart';
import '../repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository repository;

  UpdateTaskUseCase(this.repository);

  Future<TaskModel> call(TaskModel task) async {
    return await repository.updateTask(task);
  }
}
