// ============================================================
// Praktikum Pemwob - Pertemuan 6
// Tahap 10: Repository Pattern
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import '../models/course.dart';
import '../services/course_service.dart';

/// Lapisan abstraksi antara Provider (business logic) dan sumber data.
/// Provider cukup memanggil getCourses(); ia tidak perlu tahu
/// apakah data berasal dari JSON asset, REST API, atau database.
class CourseRepository {
  final CourseService service;

  // Dependency injection sederhana lewat constructor.
  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    return service.loadCourses();
  }
}