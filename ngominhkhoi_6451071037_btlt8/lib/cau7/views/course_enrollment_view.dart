import 'package:flutter/material.dart';
import '../controllers/enrollment_controller.dart';
import '../controllers/student_controller.dart';
import '../models/student_model.dart';
import '../models/course_model.dart';
import '../utils/database_helper.dart';
import '../../widgets/student_scaffold.dart';

class CourseEnrollmentView extends StatefulWidget {
  final Course course;

  const CourseEnrollmentView({super.key, required this.course});

  @override
  State<CourseEnrollmentView> createState() => _CourseEnrollmentViewState();
}

class _CourseEnrollmentViewState extends State<CourseEnrollmentView> {
  final EnrollmentController _enrollmentController = EnrollmentController();
  final StudentController _studentController = StudentController();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Student> _allStudents = [];
  List<Student> _enrolledStudents = [];
  List<int> _enrolledIds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final students = await _studentController.getAllStudents();
      final enrolled = await _dbHelper.getStudentsForCourse(widget.course.id!);
      final enrolledIds = enrolled.map((s) => s.id!).toList();

      setState(() {
        _allStudents = students;
        _enrolledStudents = enrolled;
        _enrolledIds = enrolledIds;
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

  Future<void> _toggleStudent(Student student) async {
    final isEnrolled = _enrolledIds.contains(student.id);
    await _enrollmentController.toggleEnrollment(
      student.id!,
      widget.course.id!,
      isEnrolled,
    );
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return StudentScaffold(
      title: 'Danh sách sinh viên',
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green.shade400,
                  Colors.green.shade600,
                ],
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.book, color: Colors.white, size: 48),
                const SizedBox(height: 8),
                Text(
                  widget.course.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_enrolledStudents.length} sinh viên đã đăng ký',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.people, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Danh sách sinh viên (${_allStudents.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _allStudents.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outlined, size: 60, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Chưa có sinh viên nào',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Vui lòng thêm sinh viên trước',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _allStudents.length,
                        itemBuilder: (context, index) {
                          final student = _allStudents[index];
                          final isEnrolled = _enrolledIds.contains(student.id);
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CheckboxListTile(
                              value: isEnrolled,
                              onChanged: (_) => _toggleStudent(student),
                              title: Text(
                                student.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: isEnrolled ? Colors.green : Colors.black87,
                                ),
                              ),
                              secondary: Icon(
                                Icons.person,
                                color: isEnrolled ? Colors.green : Colors.grey,
                              ),
                              activeColor: Colors.green,
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
