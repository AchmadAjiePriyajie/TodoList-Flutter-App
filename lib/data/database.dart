import 'package:hive_flutter/hive_flutter.dart';

class TodoDatabase {
  List toDoList = [];

  // reference box
  final _myBox = Hive.box('mybox');

  void createInitialData() {
    toDoList = [
      ['Make Tutorial', false],
      ['Pray', false],
    ];
  }

  void loadData() {
    toDoList = _myBox.get('TodoList');
  }

  void updateDatabase() {
    _myBox.put('TodoList', toDoList);
  }
}
