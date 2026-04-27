import 'package:flutter/material.dart';
import '../views/task_list_view.dart';

class Cau3App extends StatelessWidget {
  const Cau3App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'To-do List',
      debugShowCheckedModeBanner: false,
      home: TaskListView(),
    );
  }
}
