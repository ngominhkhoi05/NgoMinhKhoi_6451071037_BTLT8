import 'package:flutter/material.dart';
import '../views/expense_list_view.dart';
import '../views/category_list_view.dart';
import '../../widgets/student_scaffold.dart';

class Cau4HomeView extends StatelessWidget {
  const Cau4HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: StudentScaffold(
        title: 'Quản lý chi tiêu',
        appBar: const TabBar(
          labelColor: Colors.deepPurple,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.deepPurple,
          tabs: [
            Tab(icon: Icon(Icons.receipt_long), text: 'Chi tiêu'),
            Tab(icon: Icon(Icons.folder), text: 'Danh mục'),
          ],
        ),
        body: const TabBarView(
          children: [
            ExpenseListView(),
            CategoryListView(),
          ],
        ),
      ),
    );
  }
}
