import 'package:flutter/material.dart';
import '../../widgets/student_scaffold.dart';

class Cau7View extends StatelessWidget {
  const Cau7View({super.key});

  @override
  Widget build(BuildContext context) {
    return StudentScaffold(
      title: 'Câu 7',
      body: const Center(
        child: Text('Nội dung Câu 7'),
      ),
    );
  }
}
