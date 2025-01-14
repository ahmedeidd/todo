import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:task_manager_app/core/services/service_locator.dart';
import 'package:task_manager_app/features/auth/presentation/provider/auth_provider.dart';
import 'package:task_manager_app/features/splash/splash_screen.dart';
import 'package:task_manager_app/features/task/presentation/provider/task_provider.dart';

void main() {
  // Initialize service locator for dependency injection
  ServiceLocator.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            // Register AuthProvider
            ChangeNotifierProvider(
              create: (_) => serviceLocator.get<AuthProvider>(),
            ),
            // Register TaskProvider
            ChangeNotifierProvider<TaskProvider>(
              create: (_) => serviceLocator.get<TaskProvider>(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Task Manager App',
            theme: ThemeData(primarySwatch: Colors.blue),
            home: SplashScreen(),
          ),
        );
      },
    );
  }
}
