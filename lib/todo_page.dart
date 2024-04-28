import 'package:flutter/material.dart';
import 'package:todo_app/util/boxes.dart';
import 'package:todo_app/util/dialog_box.dart';
import 'package:todo_app/util/todo_list.dart';
import 'package:todo_app/util/todo_tile.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _controller = TextEditingController();

  void addNewTask() {
    setState(() {
      boxTodo.put(
        'key_${_controller.text}',
        Todo(
          todo: _controller.text,
          isCompleted: false,
        ),
      );
      _controller.clear();
    });
    Navigator.of(context).pop();
  }

  void checkBoxChanged(int index, bool? value) {
    Todo todo = boxTodo.getAt(index);
    setState(() {
      boxTodo.putAt(
        index,
        Todo(
          todo: todo.todo,
          isCompleted: !todo.isCompleted,
        ),
      );
    });
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: addNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      boxTodo.deleteAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    if (boxTodo.isEmpty) {
      boxTodo.put(
        'key_${_controller.text}',
        Todo(
          todo: 'create todolist',
          isCompleted: false,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('To Do'),
        ),
        backgroundColor: Colors.amber,
        elevation: 20,
      ),
      body: ListView.builder(
        itemCount: boxTodo.length,
        itemBuilder: (context, index) {
          Todo todo = boxTodo.getAt(index);
          return TodoTile(
            onChanged: (value) => checkBoxChanged(index, value),
            taskCompleted: todo.isCompleted,
            taskName: todo.todo,
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }
}
