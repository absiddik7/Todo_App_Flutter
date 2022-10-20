import 'package:flutter/material.dart';
import 'package:todolist/db/databaseHelper.dart';
import 'package:todolist/model/todo_model.dart';

class MonthlyTodoScreen extends StatefulWidget {
  const MonthlyTodoScreen({super.key});

  @override
  State createState() => MonthlyTodoScreenState();
}

class MonthlyTodoScreenState extends State<MonthlyTodoScreen> {
  List<Todo> monthlyAllTask = [];
  Todo _todoData = Todo();
  static const String tableMonthlyTodo = 'monthlyTodo';
  late DatabaseHelper _dbHelper;

  _refreshTodoList() async {
    List<Todo> task = await _dbHelper.getAllData(tableMonthlyTodo);
    setState(() {
      monthlyAllTask = task;
    });
  }

    @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshTodoList();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController taskController = TextEditingController();

    Future<void> showMyDialog(String status, String task) async {
      if (status == 'UPDATE') {
        taskController.text = task;
      }

      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add Task'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: taskController,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.blue),
                      ),
                      hintText: 'Enter task',
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter task';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  taskController.clear();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () async {
                  if (_todoData.id == null) {
                    if (taskController.text.isNotEmpty) {
                      _todoData.task = taskController.text;
                      await _dbHelper.insertMonthlyTask(_todoData);
                      _refreshTodoList();
                    }
                  } else {
                    if (status == 'UPDATE') {
                      _todoData.task = taskController.text;
                      await _dbHelper.update(_todoData, tableMonthlyTodo);
                      _todoData = Todo();
                      _refreshTodoList();
                    }
                  }
                  _todoData.id == null;

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Expanded(
            child: ListView.builder(
                itemCount: monthlyAllTask.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.blueGrey[50],
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          _todoData = monthlyAllTask[index];
                        });

                        showMyDialog(
                            "UPDATE", monthlyAllTask[index].task.toString());
                      },
                      title: Text(
                        monthlyAllTask[index].task.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await _dbHelper.delete(
                              (monthlyAllTask[index].id), tableMonthlyTodo);
                          _refreshTodoList();
                        },
                      ),
                    ),
                  );
                }),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMyDialog("INSERT", '');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
