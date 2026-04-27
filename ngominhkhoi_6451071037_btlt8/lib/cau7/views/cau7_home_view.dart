import 'package:flutter/material.dart';
import '../views/student_list_view.dart';
import '../views/course_list_view.dart';
import '../../widgets/student_scaffold.dart';

class Cau7HomeView extends StatelessWidget {
  const Cau7HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quản lý SV - Môn học'),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.people), text: 'Sinh viên'),
              Tab(icon: Icon(Icons.book), text: 'Môn học'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            StudentListView(),
            CourseListView(),
          ],
        ),
        bottomNavigationBar: Container(
          height: 40,
          color: Colors.deepPurple,
          alignment: Alignment.center,
          child: const Text(
            '6451071037 - Ngô Minh Khôi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
