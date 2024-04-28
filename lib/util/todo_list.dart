import 'package:hive/hive.dart';

part 'todo_list.g.dart';

@HiveType(typeId: 1)
class Todo {
  Todo({
    required this.todo,
    required this.isCompleted,
  });

  @HiveField(0)
  String todo;

  @HiveField(1)
  bool isCompleted;
}
