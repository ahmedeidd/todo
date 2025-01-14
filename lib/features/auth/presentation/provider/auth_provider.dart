import 'package:flutter/material.dart';
import 'package:task_manager_app/features/auth/domain/entities/user.dart';
import 'package:task_manager_app/features/auth/domain/usecases/login.dart';

class AuthProvider with ChangeNotifier {
  final Login loginUseCase;

  AuthProvider({required this.loginUseCase});

  User? _user;

  User? get user => _user;

  Future<void> login(String username, String password) async {
    _user = await loginUseCase(username, password);
    notifyListeners();
  }
}
