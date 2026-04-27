import 'package:flutter/material.dart';

class StudentScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;

  const StudentScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: Container(
        height: 40,
        color: Colors.deepPurple,
        alignment: Alignment.center,
        child: const Text(
          '6451071037 - Ngô Minh Khôi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
