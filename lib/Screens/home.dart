import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list/data/database.dart';
import 'package:to_do_list/utils/dialog.dart';
import 'package:to_do_list/utils/todolist.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //refernce the hive box
  final _myBox = Hive.box('mybox');

  final _controller = TextEditingController();
  //list of todolist
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    //if this is the first time ever opening the app, then create a default data
    if(_myBox.get('TODOLIST') == null){
      db.createInitialData();
    }else
      //there already exist data
      db.loadData();
    super.initState();
  }
// boxcheck
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.todoList[index][1] = !db.todoList[index][1];
    });
    db.updateDataBase();
  }

  // save new task
void saveNewTask (){
    setState(() {
      db.todoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
}
// create new task
  void createNewTask (){
    showDialog(context: context, builder: (context)
    {
      return DialogBox(
        controller: _controller,
        onSaved: saveNewTask,
        onCancel: () => Navigator.of(context).pop(),
      );
    }
    );
  }

  //To delete task
  void deleteTask(int index){
 setState(() {
   db.todoList.removeAt(index);
 });
 db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[200],
      appBar: AppBar(
        elevation: 0,
        title: const Center(child: Text('To Do')),
      ),
      body: ListView.builder(
        itemCount: db.todoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
              taskName: db.todoList[index][0],
              taskCompleted: db.todoList[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
    );
  }
}
