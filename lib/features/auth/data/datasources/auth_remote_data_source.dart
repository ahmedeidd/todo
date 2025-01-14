import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/core/error/exceptions.dart';
import 'package:task_manager_app/core/utils/constants.dart';
import 'package:task_manager_app/features/auth/data/models/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSource(this.client);

  Future<UserModel> login(String username, String password) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    Map body = {'username': username, 'password': password};
    final response = await client.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: headers,
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      //print(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String v = "done";
      prefs.setString("saveLogin", v);
      return UserModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw ServerException();
    } else {
      throw ServerException();
    }
  }
}
