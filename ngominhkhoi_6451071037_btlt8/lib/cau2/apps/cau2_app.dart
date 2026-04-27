import 'package:flutter/material.dart';
import '../views/cau2_home_view.dart';

class Cau2App extends StatelessWidget {
  const Cau2App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Ghi chú có danh mục',
      debugShowCheckedModeBanner: false,
      home: Cau2HomeView(),
    );
  }
}
