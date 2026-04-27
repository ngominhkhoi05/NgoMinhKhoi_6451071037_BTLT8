import 'package:flutter/material.dart';
import '../views/gallery_view.dart';

class Cau6App extends StatelessWidget {
  const Cau6App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Gallery ảnh',
      debugShowCheckedModeBanner: false,
      home: GalleryView(),
    );
  }
}
