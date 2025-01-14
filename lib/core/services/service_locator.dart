import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:task_manager_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:task_manager_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_manager_app/features/auth/domain/usecases/login.dart';
import 'package:task_manager_app/features/auth/presentation/provider/auth_provider.dart';
import 'package:task_manager_app/features/task/data/datasources/task_local_data_source.dart';
import 'package:task_manager_app/features/task/data/datasources/task_remote_data_source.dart';
import 'package:task_manager_app/features/task/data/repositories/task_repository_impl.dart';
import 'package:task_manager_app/features/task/domain/repositories/task_repository.dart';
import 'package:task_manager_app/features/task/domain/usecases/add_task_usecase.dart';
import 'package:task_manager_app/features/task/domain/usecases/delete_task_usecase.dart';
import 'package:task_manager_app/features/task/domain/usecases/get_tasks_usecase.dart';
import 'package:task_manager_app/features/task/domain/usecases/get_tasks_with_pagination_usecase.dart';
import 'package:task_manager_app/features/task/domain/usecases/update_task_usecase.dart';
import 'package:task_manager_app/features/task/presentation/provider/task_provider.dart';

final GetIt serviceLocator = GetIt.instance;

class ServiceLocator {
  static void init() {
    // Http Client
    serviceLocator.registerLazySingleton(() => http.Client());
    // Register Base URL
    const String baseUrl = "https://dummyjson.com";
    serviceLocator.registerLazySingleton<String>(
      () => baseUrl,
    );

    // Auth Feature
    serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(serviceLocator<http.Client>()),
    );
    serviceLocator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: serviceLocator()),
    );
    serviceLocator.registerLazySingleton(() => Login(serviceLocator()));
    serviceLocator.registerLazySingleton(
      () => AuthProvider(
        loginUseCase: serviceLocator(),
      ),
    );

    // Register Data Sources
    serviceLocator.registerLazySingleton<TaskRemoteDataSource>(
      () => TaskRemoteDataSourceImpl(
        client: serviceLocator<http.Client>(),
        baseUrl: serviceLocator<String>(),
      ),
    );
    serviceLocator.registerLazySingleton<TaskLocalDataSource>(
      () => TaskLocalDataSourceImpl(),
    );

    // Register Repository
    serviceLocator.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(
        remoteDataSource: serviceLocator<TaskRemoteDataSource>(),
        localDataSource: serviceLocator<TaskLocalDataSource>(),
      ),
    );

    // Register Use Cases
    serviceLocator.registerLazySingleton<GetTasksUseCase>(
      () => GetTasksUseCase(serviceLocator<TaskRepository>()),
    );
    serviceLocator.registerLazySingleton<AddTaskUseCase>(
      () => AddTaskUseCase(serviceLocator<TaskRepository>()),
    );
    serviceLocator.registerLazySingleton<DeleteTaskUseCase>(
      () => DeleteTaskUseCase(serviceLocator<TaskRepository>()),
    );
    serviceLocator.registerLazySingleton<GetTasksWithPaginationUseCase>(
      () => GetTasksWithPaginationUseCase(serviceLocator<TaskRepository>()),
    );
    serviceLocator.registerLazySingleton<UpdateTaskUseCase>(
      () => UpdateTaskUseCase(serviceLocator<TaskRepository>()),
    );

    // Register Providers
    serviceLocator.registerLazySingleton<TaskProvider>(
      () => TaskProvider(
        getTasksUseCase: serviceLocator<GetTasksUseCase>(),
        addTaskUseCase: serviceLocator<AddTaskUseCase>(),
        updateTaskUseCase: serviceLocator<UpdateTaskUseCase>(),
        deleteTaskUseCase: serviceLocator<DeleteTaskUseCase>(),
        getTasksWithPaginationUseCase:
            serviceLocator<GetTasksWithPaginationUseCase>(),
      ),
    );
  }
}
