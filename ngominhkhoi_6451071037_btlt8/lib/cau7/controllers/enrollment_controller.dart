import '../models/course_model.dart';
import '../utils/database_helper.dart';

class EnrollmentController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> enrollStudent(int studentId, int courseId) async {
    await _dbHelper.enrollStudent(studentId, courseId);
  }

  Future<void> unenrollStudent(int studentId, int courseId) async {
    await _dbHelper.unenrollStudent(studentId, courseId);
  }

  Future<List<Course>> getCoursesForStudent(int studentId) async {
    return await _dbHelper.getCoursesForStudent(studentId);
  }

  Future<void> toggleEnrollment(int studentId, int courseId, bool isEnrolled) async {
    if (isEnrolled) {
      await _dbHelper.unenrollStudent(studentId, courseId);
    } else {
      await _dbHelper.enrollStudent(studentId, courseId);
    }
  }
}
