import 'package:flutter/material.dart';
import '../views/cau7_home_view.dart';

class Cau7App extends StatelessWidget {
  const Cau7App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Quản lý SV - Môn học',
      debugShowCheckedModeBanner: false,
      home: Cau7HomeView(),
    );
  }
}
