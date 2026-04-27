import 'package:flutter/material.dart';
import '../../widgets/student_scaffold.dart';

class Cau2View extends StatelessWidget {
  const Cau2View({super.key});

  @override
  Widget build(BuildContext context) {
    return StudentScaffold(
      title: 'Câu 2',
      body: const Center(
        child: Text('Nội dung Câu 2'),
      ),
    );
  }
}
