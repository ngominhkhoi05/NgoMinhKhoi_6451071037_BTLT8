import 'package:flutter/material.dart';
import '../views/note_list_view.dart';
import '../views/category_list_view.dart';
import '../../widgets/student_scaffold.dart';

class Cau2HomeView extends StatelessWidget {
  const Cau2HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: StudentScaffold(
        title: 'Ghi chú có danh mục',
        appBar: const TabBar(
          labelColor: Colors.deepPurple,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.deepPurple,
          tabs: [
            Tab(icon: Icon(Icons.notes), text: 'Ghi chú'),
            Tab(icon: Icon(Icons.folder), text: 'Danh mục'),
          ],
        ),
        body: const TabBarView(
          children: [
            NoteListView(),
            CategoryListView(),
          ],
        ),
      ),
    );
  }
}
