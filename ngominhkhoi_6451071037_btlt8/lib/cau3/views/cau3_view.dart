import 'package:flutter/material.dart';
import '../../widgets/student_scaffold.dart';

class Cau3View extends StatelessWidget {
  const Cau3View({super.key});

  @override
  Widget build(BuildContext context) {
    return StudentScaffold(
      title: 'Câu 3',
      body: const Center(
        child: Text('Nội dung Câu 3'),
      ),
    );
  }
}
