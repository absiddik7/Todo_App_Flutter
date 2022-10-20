import 'package:flutter/material.dart';
import 'package:todolist/todo/todoScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialApp(
        title: 'To Do',
        theme: ThemeData(
          
          primarySwatch: Colors.blue,
        ),
        home: const TodoScreen(),
      ),
    );
  }
}
