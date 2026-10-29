// ============================================================
// Praktikum Pemwob - Pertemuan 7
// Tahap 4: Repository menggunakan CourseApiService
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import '../models/course.dart';
import '../services/course_api_service.dart';

class CourseRepository {
  final CourseApiService service;

  // Dependency injection: CourseRepository kini bergantung pada CourseApiService
  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    return service.getCourses();
  }
}
