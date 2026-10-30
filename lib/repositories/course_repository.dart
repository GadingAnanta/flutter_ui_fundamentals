// ============================================================
// Praktikum Pemwob - Pertemuan 7
// Tahap 9: Repository Pattern untuk REST API
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================
//
// Repository menjadi kontrak yang dipakai state layer (Provider).
// Provider tidak tahu apakah dataSource berupa REST API, Supabase,
// maupun cache lokal.

import '../models/course.dart';
import '../services/course_data_source.dart';

class CourseRepository {
  final CourseDataSource dataSource;

  CourseRepository(this.dataSource);

  Future<List<Course>> getCourses() => dataSource.getCourses();

  Future<Course> createCourse(Course course) =>
      dataSource.createCourse(course);

  Future<void> updateCourse(int id, Course course) =>
      dataSource.updateCourse(id, course);

  Future<void> deleteCourse(int id) => dataSource.deleteCourse(id);
}
