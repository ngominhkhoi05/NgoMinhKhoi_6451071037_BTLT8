import 'package:flutter/material.dart';
import '../views/cau4_home_view.dart';

class Cau4App extends StatelessWidget {
  const Cau4App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Quản lý chi tiêu',
      debugShowCheckedModeBanner: false,
      home: Cau4HomeView(),
    );
  }
}
