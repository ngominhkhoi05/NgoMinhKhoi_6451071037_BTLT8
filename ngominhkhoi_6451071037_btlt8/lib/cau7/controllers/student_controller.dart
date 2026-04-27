import '../models/student_model.dart';
import '../utils/database_helper.dart';

class StudentController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Student>> getAllStudents() async {
    return await _dbHelper.getAllStudents();
  }

  Future<Student> createStudent(String name) async {
    final student = Student(name: name);
    return await _dbHelper.createStudent(student);
  }

  Future<int> updateStudent(Student student) async {
    return await _dbHelper.updateStudent(student);
  }

  Future<int> deleteStudent(int id) async {
    return await _dbHelper.deleteStudent(id);
  }

  Future<List<int>> getEnrolledCourseIds(int studentId) async {
    return await _dbHelper.getEnrolledCourseIds(studentId);
  }
}
