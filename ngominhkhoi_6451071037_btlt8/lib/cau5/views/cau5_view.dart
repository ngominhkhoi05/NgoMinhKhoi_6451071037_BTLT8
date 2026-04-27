import 'package:flutter/material.dart';
import '../../widgets/student_scaffold.dart';

class Cau5View extends StatelessWidget {
  const Cau5View({super.key});

  @override
  Widget build(BuildContext context) {
    return StudentScaffold(
      title: 'Câu 5',
      body: const Center(
        child: Text('Nội dung Câu 5'),
      ),
    );
  }
}
