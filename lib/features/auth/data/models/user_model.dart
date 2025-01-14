import 'package:task_manager_app/features/auth/domain/entities/user.dart';

class UserModel extends User {
  final String token;

  UserModel({required this.token}) : super(token: token);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(token: json["accessToken"]);
  }
}
