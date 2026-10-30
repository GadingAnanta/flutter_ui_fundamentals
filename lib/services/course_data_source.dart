// ============================================================
// Praktikum Pemwob - Pertemuan 7
// Tahap 9: Repository Pattern untuk REST API
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================
//
// Kontrak (abstract class) sumber data course.
// Provider/Repository tidak perlu tahu apakah data berasal dari
// REST API, Supabase, cache lokal, atau sumber lain.

import '../models/course.dart';

abstract class CourseDataSource {
  Future<List<Course>> getCourses();
  Future<Course> createCourse(Course course);
  Future<void> updateCourse(int id, Course course);
  Future<void> deleteCourse(int id);
}
