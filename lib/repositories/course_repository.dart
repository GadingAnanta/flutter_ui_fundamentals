// ============================================================
// Praktikum Pemwob - Pertemuan 7
// Tahap 6: Repository Create Course
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import '../models/course.dart';
import '../services/course_api_service.dart';

class CourseRepository {
  final CourseApiService service;

  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    return service.getCourses();
  }

  Future<Course> createCourse(Course course) {
    return service.createCourse(course);
  }
}
