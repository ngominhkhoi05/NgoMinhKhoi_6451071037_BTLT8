import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/student_model.dart';
import '../models/course_model.dart';
import '../models/enrollment_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('student_course.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE courses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE enrollments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studentId INTEGER NOT NULL,
        courseId INTEGER NOT NULL,
        FOREIGN KEY (studentId) REFERENCES students (id) ON DELETE CASCADE,
        FOREIGN KEY (courseId) REFERENCES courses (id) ON DELETE CASCADE,
        UNIQUE(studentId, courseId)
      )
    ''');
  }

  // ==================== STUDENT OPERATIONS ====================

  Future<Student> createStudent(Student student) async {
    final db = await instance.database;
    final id = await db.insert('students', {'name': student.name});
    return student.copyWith(id: id);
  }

  Future<List<Student>> getAllStudents() async {
    final db = await instance.database;
    final result = await db.query('students', orderBy: 'name ASC');
    return result.map((map) => Student.fromMap(map)).toList();
  }

  Future<int> updateStudent(Student student) async {
    final db = await instance.database;
    return db.update(
      'students',
      {'name': student.name},
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> deleteStudent(int id) async {
    final db = await instance.database;
    return db.delete('students', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== COURSE OPERATIONS ====================

  Future<Course> createCourse(Course course) async {
    final db = await instance.database;
    final id = await db.insert('courses', {'name': course.name});
    return course.copyWith(id: id);
  }

  Future<List<Course>> getAllCourses() async {
    final db = await instance.database;
    final result = await db.query('courses', orderBy: 'name ASC');
    return result.map((map) => Course.fromMap(map)).toList();
  }

  Future<int> updateCourse(Course course) async {
    final db = await instance.database;
    return db.update(
      'courses',
      {'name': course.name},
      where: 'id = ?',
      whereArgs: [course.id],
    );
  }

  Future<int> deleteCourse(int id) async {
    final db = await instance.database;
    return db.delete('courses', where: 'id = ?', whereArgs: [id]);
  }

  // ==================== ENROLLMENT OPERATIONS ====================

  Future<Enrollment> enrollStudent(int studentId, int courseId) async {
    final db = await instance.database;
    final id = await db.insert('enrollments', {
      'studentId': studentId,
      'courseId': courseId,
    });
    return Enrollment(id: id, studentId: studentId, courseId: courseId);
  }

  Future<void> unenrollStudent(int studentId, int courseId) async {
    final db = await instance.database;
    await db.delete(
      'enrollments',
      where: 'studentId = ? AND courseId = ?',
      whereArgs: [studentId, courseId],
    );
  }

  Future<List<Course>> getCoursesForStudent(int studentId) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT courses.* FROM courses
      INNER JOIN enrollments ON courses.id = enrollments.courseId
      WHERE enrollments.studentId = ?
      ORDER BY courses.name ASC
    ''', [studentId]);
    return result.map((map) => Course.fromMap(map)).toList();
  }

  Future<List<Student>> getStudentsForCourse(int courseId) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT students.* FROM students
      INNER JOIN enrollments ON students.id = enrollments.studentId
      WHERE enrollments.courseId = ?
      ORDER BY students.name ASC
    ''', [courseId]);
    return result.map((map) => Student.fromMap(map)).toList();
  }

  Future<List<int>> getEnrolledCourseIds(int studentId) async {
    final db = await instance.database;
    final result = await db.query(
      'enrollments',
      columns: ['courseId'],
      where: 'studentId = ?',
      whereArgs: [studentId],
    );
    return result.map((map) => map['courseId'] as int).toList();
  }

  Future<List<int>> getEnrolledStudentIds(int courseId) async {
    final db = await instance.database;
    final result = await db.query(
      'enrollments',
      columns: ['studentId'],
      where: 'courseId = ?',
      whereArgs: [courseId],
    );
    return result.map((map) => map['studentId'] as int).toList();
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
