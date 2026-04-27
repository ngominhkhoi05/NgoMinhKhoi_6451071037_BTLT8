import 'student_model.dart';
import 'course_model.dart';

class Enrollment {
  final int? id;
  final int studentId;
  final int courseId;
  Student? student;
  Course? course;

  Enrollment({
    this.id,
    required this.studentId,
    required this.courseId,
    this.student,
    this.course,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'courseId': courseId,
    };
  }

  factory Enrollment.fromMap(Map<String, dynamic> map) {
    return Enrollment(
      id: map['id'] as int?,
      studentId: map['studentId'] as int,
      courseId: map['courseId'] as int,
      student: map['student'] != null
          ? Student.fromMap(map['student'] as Map<String, dynamic>)
          : null,
      course: map['course'] != null
          ? Course.fromMap(map['course'] as Map<String, dynamic>)
          : null,
    );
  }

  Enrollment copyWith({
    int? id,
    int? studentId,
    int? courseId,
    Student? student,
    Course? course,
  }) {
    return Enrollment(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      courseId: courseId ?? this.courseId,
      student: student ?? this.student,
      course: course ?? this.course,
    );
  }
}
