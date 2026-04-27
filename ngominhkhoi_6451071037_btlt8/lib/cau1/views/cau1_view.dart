import 'package:flutter/material.dart';
import '../../widgets/student_scaffold.dart';

class Cau1View extends StatelessWidget {
  const Cau1View({super.key});

  @override
  Widget build(BuildContext context) {
    return StudentScaffold(
      title: 'Câu 1',
      body: const Center(
        child: Text('Nội dung Câu 1'),
      ),
    );
  }
}
