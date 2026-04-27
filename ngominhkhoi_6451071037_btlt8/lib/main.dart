import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'apps/menu_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await databaseFactory; // Khởi tạo sqflite factory
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BTLT - Ngô Minh Khôi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MenuView(),
    );
  }
}
