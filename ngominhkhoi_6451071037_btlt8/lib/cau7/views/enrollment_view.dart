import 'package:flutter/material.dart';
import '../controllers/enrollment_controller.dart';
import '../controllers/course_controller.dart';
import '../models/student_model.dart';
import '../models/course_model.dart';
import '../../widgets/student_scaffold.dart';

class EnrollmentView extends StatefulWidget {
  final Student student;

  const EnrollmentView({super.key, required this.student});

  @override
  State<EnrollmentView> createState() => _EnrollmentViewState();
}

class _EnrollmentViewState extends State<EnrollmentView> {
  final EnrollmentController _enrollmentController = EnrollmentController();
  final CourseController _courseController = CourseController();
  List<Course> _allCourses = [];
  List<Course> _enrolledCourses = [];
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
      final courses = await _courseController.getAllCourses();
      final enrolled = await _enrollmentController.getCoursesForStudent(widget.student.id!);
      final enrolledIds = enrolled.map((c) => c.id!).toList();

      setState(() {
        _allCourses = courses;
        _enrolledCourses = enrolled;
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

  Future<void> _toggleCourse(Course course) async {
    final isEnrolled = _enrolledIds.contains(course.id);
    await _enrollmentController.toggleEnrollment(
      widget.student.id!,
      course.id!,
      isEnrolled,
    );
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return StudentScaffold(
      title: 'Đăng ký môn học',
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
                  Colors.blue.shade400,
                  Colors.blue.shade600,
                ],
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.person, color: Colors.white, size: 48),
                const SizedBox(height: 8),
                Text(
                  widget.student.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_enrolledCourses.length} môn đã đăng ký',
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
                const Icon(Icons.checklist, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Danh sách môn học (${_allCourses.length})',
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
                : _allCourses.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.book_outlined, size: 60, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Chưa có môn học nào',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Vui lòng thêm môn học trước',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _allCourses.length,
                        itemBuilder: (context, index) {
                          final course = _allCourses[index];
                          final isEnrolled = _enrolledIds.contains(course.id);
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CheckboxListTile(
                              value: isEnrolled,
                              onChanged: (_) => _toggleCourse(course),
                              title: Text(
                                course.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: isEnrolled ? Colors.blue : Colors.black87,
                                ),
                              ),
                              secondary: Icon(
                                Icons.book,
                                color: isEnrolled ? Colors.blue : Colors.grey,
                              ),
                              activeColor: Colors.blue,
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
