import 'package:flutter/material.dart';
import 'package:todo_app/models/app_user.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/pages/auth_page.dart';
import 'package:todo_app/services/todo_services.dart';
import 'package:todo_app/services/user_service.dart';
import 'package:todo_app/util/dialog_box.dart';
import 'package:todo_app/util/todo_tile.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _controller = TextEditingController();
  final TodoService todoService = TodoService();
  final UserService userService = UserService();
  late AppUser? appUser;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  // Fetch user information
  void _fetchUser() async {
    appUser = await userService.getCurrentUser();
    setState(() {}); // Force the UI to rebuild when user data is loaded
  }

  // Add new task
  void addNewTask() async {
    if (_controller.text.trim().isEmpty) {
      _showErrorSnackbar('Isi semua field');
      return;
    }

    Todo newTodo = Todo(
      id: DateTime.now().toIso8601String(), // Use a unique ID
      uid: appUser!.uid,
      todo: _controller.text,
      status: false,
    );

    try {
      await todoService.createTodo(newTodo);
      Navigator.pop(context);
      _controller.clear();
    } catch (e) {
      _showErrorSnackbar("Error adding task: $e");
    }
  }

  // Update checkbox status
  void checkBoxChanged(Todo todo, bool? value) async {
    Todo updatedTodo = todo;
    updatedTodo.status = value ?? false;
    try {
      await todoService.updateTodo(updatedTodo);
    } catch (e) {
      _showErrorSnackbar("Error updating task: $e");
    }
  }

  // Show dialog to create a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
            controller: _controller,
            onSave: addNewTask,
            onCancel: () {
              _controller.clear();
              Navigator.of(context).pop();
            });
      },
    );
  }

  // Delete task
  void deleteTask(Todo todo) async {
    try {
      await todoService.deleteTodo(todo.id);
    } catch (e) {
      _showErrorSnackbar("Error deleting task: $e");
    }
  }

  void logout() {
    userService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AuthPage();
        },
      ),
    );
  }

  // Show error snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (appUser == null) {
      return const Center(
          child:
              CircularProgressIndicator()); // Show loading while fetching user data
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('E-List'),
            GestureDetector(
              onTap: () => logout(),
              child: Icon(Icons.logout),
            ),
          ],
        ),
        backgroundColor: Colors.amber,
        elevation: 20,
      ),
      body: StreamBuilder<List<Todo>>(
        stream: todoService.getTodosByUidStream(
            appUser!.uid), // Stream of todos for the current user
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No tasks yet!"));
          }

          List<Todo> todos = snapshot.data!;

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              Todo todo = todos[index];
              return TodoTile(
                onChanged: (value) => checkBoxChanged(todo, value),
                taskCompleted: todo.status,
                taskName: todo.todo,
                deleteFunction: (context) => deleteTask(todo),
              );
            },
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
