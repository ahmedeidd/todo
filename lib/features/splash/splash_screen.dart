import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/features/auth/presentation/pages/login_page.dart';
import 'package:task_manager_app/features/task/presentation/pages/task_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Animation<double>? opacity;
  AnimationController? controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    opacity = Tween<double>(begin: 1.0, end: 0.0).animate(controller!)
      ..addListener(() {
        setState(() {});
      });
    controller!.forward().then((_) {
      navigationPage();
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var saveLogin = prefs.getString("saveLogin");
    if (saveLogin != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const TaskPage(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Image.asset(
            "assets/icons/todo.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
