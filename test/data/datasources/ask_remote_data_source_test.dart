import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager_app/features/task/data/datasources/task_remote_data_source.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late TaskRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TaskRemoteDataSourceImpl(
        client: mockHttpClient, baseUrl: 'https://dummyjson.com');
  });

  test('should fetch tasks from remote API', () async {
    const url = 'https://dummyjson.com/todos?limit=10&skip=0';
    final response =
        '{"todos": [{"id": 1, "title": "Task 1", "completed": false}]}';

    when(mockHttpClient.get(Uri.parse(url)))
        .thenAnswer((_) async => http.Response(response, 200));

    final result = await dataSource.fetchTasks();

    expect(result.length, 1);
    expect(result.first.todo, 'Task 1');
    verify(mockHttpClient.get(Uri.parse(url))).called(1);
  });

  test('should throw exception if status code is not 200', () async {
    const url = 'https://dummyjson.com/todos?limit=10&skip=0';

    when(mockHttpClient.get(Uri.parse(url)))
        .thenAnswer((_) async => http.Response('Error', 400));

    expect(() => dataSource.fetchTasks(), throwsException);
    verify(mockHttpClient.get(Uri.parse(url))).called(1);
  });
}
