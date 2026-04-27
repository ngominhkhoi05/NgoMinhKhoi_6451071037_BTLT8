import '../models/course_model.dart';
import '../utils/database_helper.dart';

class CourseController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Course>> getAllCourses() async {
    return await _dbHelper.getAllCourses();
  }

  Future<Course> createCourse(String name) async {
    final course = Course(name: name);
    return await _dbHelper.createCourse(course);
  }

  Future<int> updateCourse(Course course) async {
    return await _dbHelper.updateCourse(course);
  }

  Future<int> deleteCourse(int id) async {
    return await _dbHelper.deleteCourse(id);
  }

  Future<List<int>> getEnrolledStudentIds(int courseId) async {
    return await _dbHelper.getEnrolledStudentIds(courseId);
  }
}
