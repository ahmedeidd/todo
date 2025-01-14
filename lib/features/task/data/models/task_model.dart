import 'package:task_manager_app/features/task/domain/entities/task.dart';

class TaskModel extends Task {
  final int id;
  final String todo;
  final bool completed;
  TaskModel({
    required this.id,
    required this.todo,
    required this.completed,
  }) : super(id: id, todo: todo, completed: completed);

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      todo: json["todo"],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todo': todo,
      'completed': completed,
    };
  }
}
