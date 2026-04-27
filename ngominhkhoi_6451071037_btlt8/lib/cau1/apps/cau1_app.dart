import 'package:flutter/material.dart';
import '../views/note_list_view.dart';

class Cau1App extends StatelessWidget {
  const Cau1App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Ứng dụng Ghi chú',
      debugShowCheckedModeBanner: false,
      home: NoteListView(),
    );
  }
}
