// ignore: file_names
import 'package:flutter/material.dart';
import 'package:todolist/todo/tabs/dailyTodoTab.dart';
import 'package:todolist/todo/tabs/monthlyTodoTab.dart';
import 'package:todolist/todo/tabs/weeklyTodoTab.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Task Manager'),
          shadowColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[300]),
                child: TabBar(
                  isScrollable: true,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  labelStyle: const TextStyle(fontSize: 18),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 30),
                  indicator: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(20)),
                  tabs: const [
                    Tab(
                      child: Text('Daily'),
                    ),
                    Tab(
                      child: Text('Weekly'),
                    ),
                    Tab(
                      child: Text('Monthly'),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: TabBarView(children: [
                DailyTodoScreen(),
                WeeklyTodoScreen(),
                MonthlyTodoScreen(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
