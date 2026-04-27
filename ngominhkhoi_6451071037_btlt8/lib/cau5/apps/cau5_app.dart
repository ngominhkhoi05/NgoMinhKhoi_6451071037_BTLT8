import 'package:flutter/material.dart';
import '../views/dictionary_view.dart';

class Cau5App extends StatelessWidget {
  const Cau5App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Từ điển offline',
      debugShowCheckedModeBanner: false,
      home: DictionaryView(),
    );
  }
}
