import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:miniproject/todo.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'To-Do List', home: TodoList());
  }
}

class TodoList extends StatefulWidget {
  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  final List<ToDo> _todoList = <ToDo>[];
  final TextEditingController _textFieldController = TextEditingController();
  var listlength = 0;
  var todoLeft = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: _getItems(),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          hoverColor: Colors.green[500],
          onPressed: () => _displayDialog(context),
          tooltip: 'Add Item',
          child: Icon(Icons.add)),
    );
  }

  void _addTodoItem(String title, String date, int duration) {
    duration++;
    setState(() {
      ToDo t1 = ToDo();
      t1.todo_title = title;
      t1.todo_date = date;
      t1.todo_duration = duration.toString();
      _todoList.add(t1);
    });
    _textFieldController.clear();
  }

  _todoLeft() {
    var num = 0;
    for (ToDo k in _todoList) {
      if (k.todo_duration != 'done') {
        num++;
      }
    }
    return num;
  }

  Widget _buildTodoItem(ToDo k, int ii) {
    var title = k.todo_title;
    var date = k.todo_date;
    var duration = k.todo_duration;

    if (duration != 'done') {
      if (date == DateTime.now().toString().split(' ')[0]) {
        return ListTile(
          leading: Icon(Icons.notifications_outlined, color: Colors.red),
          title: Text(title),
          subtitle: Text('$date'),
          trailing: const Text('วันนี้', style: TextStyle(color: Colors.red)),
          onTap: () => displayDialog2(context, ii),
        );
      } else {
        return ListTile(
          leading: Icon(Icons.notifications_outlined, color: Colors.black),
          title: Text(title),
          subtitle: Text('$date'),
          trailing: Text('เหลืออีก $duration วัน'),
          onTap: () => displayDialog2(context, ii),
        );
      }
    } else {
      return ListTile(
        leading: Icon(
          Icons.task_alt_outlined,
          color: Colors.grey,
        ),
        title: Text(title, style: TextStyle(color: Colors.grey)),
        subtitle: Text('$date'),
        trailing: Text('เสร็จแล้ว', style: TextStyle(color: Colors.grey)),
      );
    }
  }

  Future<dynamic> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task to your list'),
            content: TextField(
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: 'Enter task here'),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('NEXT'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _DateDialog(context, _textFieldController.text);
                },
              ),
            ],
          );
        });
  }

  Future<dynamic> displayDialog2(context, iii) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                child: const Text('Mark as done'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _todoList[iii].duration = 'done';
                  });
                },
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _todoList.removeAt(iii);
                  });
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<dynamic> _DateDialog(BuildContext context, todonow) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          _textFieldController.clear();
          return AlertDialog(
            title: const Text('Add the due date'),
            content: Container(
              height: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select date'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('ADD'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addTodoItem(todonow, selectedDate.toString().split(' ')[0],
                      selectedDate.difference(DateTime.now()).inDays);
                  selectedDate = DateTime.now();
                },
              ),
            ],
          );
        });
  }

  List<Widget> _getItems() {
    setState(() {
      listlength = _todoList.length;
      todoLeft = _todoLeft();
    });
    var today = DateTime.now().toString().split(' ')[0];
    final List<Widget> _todoWidgets = <Widget>[
      ListTile(
        tileColor: Colors.black,
        title: const Text(
          'To Do List',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        subtitle: Text('Today is $today',
            style: TextStyle(color: Colors.purple[100])),
        leading: Icon(
          Icons.format_list_bulleted_outlined,
          color: Colors.lightGreenAccent,
        ),
      ),
      ListTile(
        tileColor: Colors.grey,
        title: Text(
          'ทั้งหมด $listlength งาน',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        leading: Icon(
          Icons.add_task_outlined,
          color: Colors.black,
        ),
      ),
      ListTile(
        tileColor: Colors.pink[100],
        title: Text(
          'เหลืออีก $todoLeft งาน',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        leading: Icon(
          Icons.notifications_outlined,
          color: Colors.black,
        ),
      ),
    ];

    _todoList.sort((a, b) => a.todo_date.compareTo(b.todo_date));

    for (var i = 0; i < _todoList.length; i++) {
      _todoWidgets.add(_buildTodoItem(_todoList[i], i));
    }

    return _todoWidgets;
  }
}
