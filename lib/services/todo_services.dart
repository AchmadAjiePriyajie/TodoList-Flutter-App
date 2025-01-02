import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/todo.dart';

class TodoService {
  final CollectionReference todoCollection =
      FirebaseFirestore.instance.collection('todos');

  // Create Todo
  Future<void> createTodo(Todo todo) async {
    try {
      await todoCollection.doc(todo.id).set(todo.toMap());
    } catch (e) {
      throw Exception("Error creating Todo: $e");
    }
  }

  Stream<List<Todo>> getTodosByUidStream(String uid) {
    return todoCollection
        .where('uid', isEqualTo: uid)
        .snapshots() // Firestore real-time stream
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Todo.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Read Todos
  Future<List<Todo>> getTodos(String uid) async {
    try {
      QuerySnapshot snapshot =
          await todoCollection.where('uid', isEqualTo: uid).get();

      return snapshot.docs.map((doc) {
        return Todo.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception("Error getting Todos: $e");
    }
  }

  // Update Todo
  Future<void> updateTodo(Todo todo) async {
    try {
      await todoCollection.doc(todo.id).update(todo.toMap());
    } catch (e) {
      throw Exception("Error updating Todo: $e");
    }
  }

  // Delete Todo
  Future<void> deleteTodo(String id) async {
    try {
      await todoCollection.doc(id).delete();
    } catch (e) {
      throw Exception("Error deleting Todo: $e");
    }
  }
}
