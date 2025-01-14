import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/features/auth/presentation/pages/login_page.dart';
import 'package:task_manager_app/features/task/data/models/task_model.dart';
import 'package:task_manager_app/features/task/presentation/provider/task_provider.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final formKey = GlobalKey<FormState>();
  int offset = 1;
  String? todo;
  final TextEditingController _todoController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Fetch initial tasks
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().fetchTasks();
    });

    // Add listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !context.read<TaskProvider>().isLoading) {
        print("before $offset");
        context.read<TaskProvider>().fetchTasksWithPagination(10, offset);
        setState(() {
          offset++;
          print("after++ $offset");
        });
      }
    });
  }

  @override
  void dispose() {
    _todoController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showTaskDialog({TaskModel? task}) {
    if (task != null) {
      _todoController.text = task.todo;
    } else {
      _todoController.clear();
    }

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(task == null ? 'Add Task' : 'Edit Task'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _todoController,
                  onSaved: (value) => todo = value,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                  decoration:
                      const InputDecoration(labelText: 'Task Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  if (task == null) {
                    bool result =
                        await InternetConnectionChecker().hasConnection;
                    if (result == true) {
                      context.read<TaskProvider>().addTask(
                            TaskModel(
                              id: DateTime.now().millisecondsSinceEpoch,
                              completed: false,
                              todo: todo!,
                            ),
                          );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No Internet'),
                        ),
                      );
                    }
                  } else {
                    bool result =
                        await InternetConnectionChecker().hasConnection;
                    if (result == true) {
                      context.read<TaskProvider>().updateTask(
                            TaskModel(
                              id: task.id,
                              completed: true,
                              todo: todo!,
                            ),
                          );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No Internet'),
                        ),
                      );
                    }
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text(task == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            onPressed: () {
              taskProvider.fetchTasks();
              setState(() {
                offset = 1;
                print("offset: $offset");
              });
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("saveLogin");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const LoginPage(),
                ),
                (Route<dynamic> route) => false,
              );
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: taskProvider.isLoading && taskProvider.tasks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : taskProvider.errorMessage != null
              ? Center(child: Text(taskProvider.errorMessage!))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller:
                            _scrollController, // Attach ScrollController
                        itemCount: taskProvider.tasks.length,
                        itemBuilder: (context, index) {
                          final task = taskProvider.tasks[index];
                          return ListTile(
                            subtitle: Text(task.todo),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _showTaskDialog(task: task),
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    taskProvider.deleteTask(task.id);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    if (taskProvider.isLoading)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
