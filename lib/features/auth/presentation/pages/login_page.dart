import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:task_manager_app/features/auth/presentation/provider/auth_provider.dart';
import 'package:task_manager_app/features/task/presentation/pages/task_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? password;
    String? userName;
    final formKey = GlobalKey<FormState>();
    final provider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          "Login",
          style: TextStyle(
            fontSize: 14.0.sp,
          ),
          minFontSize: 8,
          maxLines: 1,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 2.h,
          horizontal: 10.w,
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // username
              TextFormField(
                onSaved: (value) => userName = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Username'),
              ),
              // pass
              TextFormField(
                onSaved: (value) => password = value,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(
                height: 2.h,
              ),
              // Login
              ElevatedButton(
                onPressed: () async {
                  bool result = await InternetConnectionChecker().hasConnection;
                  if (result == true) {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      var success = provider.login(userName!, password!);
                      success.then((_) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TaskPage()),
                        );
                      }).catchError((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invalid username or password'),
                          ),
                        );
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No Internet'),
                      ),
                    );
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
