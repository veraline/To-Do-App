import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ToDoDataBase {
  List todoList = [];
  //reference the box
  final _myBox = Hive.box('mybox');

  //method running if this is the first time opening the app
  void createInitialData() {
    todoList = [
      ['Read the Bible', false],
      ['Watch Tutorials', false],
    ];
  }

  // load the data from the database
  void loadData() {
    todoList = _myBox.get('TODOLIST');
  }

  //Update the database
  void updateDataBase() {
    _myBox.put('TODOLIST', todoList);
  }
}
