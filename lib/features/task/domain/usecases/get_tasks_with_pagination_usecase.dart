import 'package:task_manager_app/features/task/data/models/task_model.dart';

import '../repositories/task_repository.dart';

class GetTasksWithPaginationUseCase {
  final TaskRepository repository;

  GetTasksWithPaginationUseCase(this.repository);

  Future<List<TaskModel>> call({
    required int limit,
    required int offset,
  }) async {
    return await repository.getTasksWithPagination(
        limit: limit, offset: offset);
  }
}
