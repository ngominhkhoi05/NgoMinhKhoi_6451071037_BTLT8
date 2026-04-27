import 'package:flutter/material.dart';
import '../../widgets/student_scaffold.dart';

class Cau4View extends StatelessWidget {
  const Cau4View({super.key});

  @override
  Widget build(BuildContext context) {
    return StudentScaffold(
      title: 'Câu 4',
      body: const Center(
        child: Text('Nội dung Câu 4'),
      ),
    );
  }
}
