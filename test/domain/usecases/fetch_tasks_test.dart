import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_manager_app/features/task/data/models/task_model.dart';
import 'package:task_manager_app/features/task/domain/repositories/task_repository.dart';
import 'package:task_manager_app/features/task/domain/usecases/get_tasks_usecase.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late GetTasksUseCase getTasksUseCase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    getTasksUseCase = GetTasksUseCase(mockTaskRepository);
  });

  test('should fetch tasks from the repository', () async {
    final List<TaskModel> tasks = [
      TaskModel(id: 1, todo: 'Task 1', completed: false),
      TaskModel(id: 2, todo: 'Task 2', completed: true),
    ];

    when(mockTaskRepository.getTasks()).thenAnswer((_) async => tasks);

    final result = await getTasksUseCase();

    expect(result, tasks);
    verify(mockTaskRepository.getTasks()).called(1);
    verifyNoMoreInteractions(mockTaskRepository);
  });
}
