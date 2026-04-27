import 'package:flutter/material.dart';
import '../controllers/student_controller.dart';
import '../models/student_model.dart';
import '../models/course_model.dart';
import '../widgets/student_tile.dart';
import '../../widgets/student_scaffold.dart';
import 'enrollment_view.dart';
import '../utils/database_helper.dart';

class StudentListView extends StatefulWidget {
  final VoidCallback? onDataChanged;

  const StudentListView({super.key, this.onDataChanged});

  @override
  State<StudentListView> createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView> {
  final StudentController _controller = StudentController();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Map<int, List<Course>> _enrolledCourses = {};
  List<Student> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final students = await _controller.getAllStudents();
      final Map<int, List<Course>> enrolled = {};

      for (final student in students) {
        final courses = await _dbHelper.getCoursesForStudent(student.id!);
        enrolled[student.id!] = courses;
      }

      setState(() {
        _students = students;
        _enrolledCourses.clear();
        _enrolledCourses.addAll(enrolled);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  Future<void> _showAddDialog() async {
    final nameController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm sinh viên'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Tên sinh viên',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Thêm'),
          ),
        ],
      ),
    );

    if (result == true && nameController.text.trim().isNotEmpty) {
      await _controller.createStudent(nameController.text.trim());
      _loadData();
      widget.onDataChanged?.call();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã thêm sinh viên')),
        );
      }
    }
  }

  Future<void> _deleteStudent(Student student) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có muốn xóa sinh viên "${student.name}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _controller.deleteStudent(student.id!);
      _loadData();
      widget.onDataChanged?.call();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xóa sinh viên')),
        );
      }
    }
  }

  void _navigateToEnrollment(Student student) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EnrollmentView(student: student),
      ),
    );
    _loadData();
    widget.onDataChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return StudentScaffold(
      title: 'Quản lý sinh viên',
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        tooltip: 'Thêm sinh viên',
        child: const Icon(Icons.person_add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _students.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outlined, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Chưa có sinh viên nào',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Nhấn + để thêm sinh viên',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemCount: _students.length,
                    itemBuilder: (context, index) {
                      final student = _students[index];
                      return StudentTile(
                        student: student,
                        enrolledCourses: _enrolledCourses[student.id] ?? [],
                        onTap: () => _navigateToEnrollment(student),
                        onDelete: () => _deleteStudent(student),
                      );
                    },
                  ),
                ),
    );
  }
}
