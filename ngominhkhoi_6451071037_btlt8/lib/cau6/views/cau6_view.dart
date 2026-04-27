import 'package:flutter/material.dart';
import '../../widgets/student_scaffold.dart';

class Cau6View extends StatelessWidget {
  const Cau6View({super.key});

  @override
  Widget build(BuildContext context) {
    return StudentScaffold(
      title: 'Câu 6',
      body: const Center(
        child: Text('Nội dung Câu 6'),
      ),
    );
  }
}
