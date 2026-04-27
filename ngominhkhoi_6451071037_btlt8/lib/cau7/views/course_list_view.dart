import 'package:flutter/material.dart';
import '../controllers/course_controller.dart';
import '../models/course_model.dart';
import '../models/student_model.dart';
import '../widgets/course_tile.dart';
import '../../widgets/student_scaffold.dart';
import 'course_enrollment_view.dart';
import '../utils/database_helper.dart';

class CourseListView extends StatefulWidget {
  final VoidCallback? onDataChanged;

  const CourseListView({super.key, this.onDataChanged});

  @override
  State<CourseListView> createState() => _CourseListViewState();
}

class _CourseListViewState extends State<CourseListView> {
  final CourseController _controller = CourseController();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Map<int, List<Student>> _enrolledStudents = {};
  List<Course> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final courses = await _controller.getAllCourses();
      final Map<int, List<Student>> enrolled = {};

      for (final course in courses) {
        final students = await _dbHelper.getStudentsForCourse(course.id!);
        enrolled[course.id!] = students;
      }

      setState(() {
        _courses = courses;
        _enrolledStudents.clear();
        _enrolledStudents.addAll(enrolled);
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
        title: const Text('Thêm môn học'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Tên môn học',
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
      await _controller.createCourse(nameController.text.trim());
      _loadData();
      widget.onDataChanged?.call();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã thêm môn học')),
        );
      }
    }
  }

  Future<void> _deleteCourse(Course course) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có muốn xóa môn học "${course.name}" không?'),
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
      await _controller.deleteCourse(course.id!);
      _loadData();
      widget.onDataChanged?.call();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xóa môn học')),
        );
      }
    }
  }

  void _navigateToEnrollment(Course course) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseEnrollmentView(course: course),
      ),
    );
    _loadData();
    widget.onDataChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return StudentScaffold(
      title: 'Quản lý môn học',
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        tooltip: 'Thêm môn học',
        child: const Icon(Icons.add_box),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _courses.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.book_outlined, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Chưa có môn học nào',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Nhấn + để thêm môn học',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemCount: _courses.length,
                    itemBuilder: (context, index) {
                      final course = _courses[index];
                      return CourseTile(
                        course: course,
                        enrolledStudents: _enrolledStudents[course.id] ?? [],
                        onTap: () => _navigateToEnrollment(course),
                        onDelete: () => _deleteCourse(course),
                      );
                    },
                  ),
                ),
    );
  }
}
