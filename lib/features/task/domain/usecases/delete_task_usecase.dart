import '../repositories/task_repository.dart';

class DeleteTaskUseCase {
  final TaskRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<bool> call(int taskId) async {
    return await repository.deleteTask(taskId);
  }
}
