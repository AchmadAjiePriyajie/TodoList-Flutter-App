class Todo {
  String id;
  String todo;
  bool status;
  String uid;

  // Constructor untuk menginisialisasi variabel instance
  Todo({
    required this.id,
    required this.uid,
    required this.todo,
    required this.status,
  });

  // Method untuk mengubah data user menjadi map (misalnya untuk penyimpanan atau API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'todo': todo,
      'status': status,
    };
  }

  // Factory constructor untuk membuat user dari map (misalnya untuk parsing data JSON)
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      uid: map['uid'],
      todo: map['todo'],
      status: map['status'],
    );
  }
}
