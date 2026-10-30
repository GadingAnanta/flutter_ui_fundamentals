// ============================================================
// Praktikum Pemwob - Pertemuan 7
// Tahap 17: Repository + error handling & timeout
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================
//
// Repository menjadi kontrak yang dipakai state layer (Provider).
// Provider tidak tahu apakah dataSource berupa REST API, Supabase,
// maupun cache lokal.
//
// Mulai Tahap 17 repository juga menjadi satu-satunya tempat yang
// menerjemahkan error teknis (PostgREST, jaringan, JSON) menjadi
// CourseDataException, sehingga pesan yang tampil di UI informatif
// dan provider tetap bersih dari detail package.

import '../models/course.dart';
import '../services/course_data_source.dart';
import '../services/data_error.dart';

class CourseRepository {
  final CourseDataSource dataSource;

  CourseRepository(this.dataSource);

  /// Batas waktu agar request yang menggantung tidak menahan layar
  /// pada loading state selamanya (Kasus B - tidak ada internet).
  static const Duration _timeout = Duration(seconds: 15);

  Future<List<Course>> getCourses() => _guard(() => dataSource.getCourses());

  Future<Course> createCourse(Course course) =>
      _guard(() => dataSource.createCourse(course));

  Future<void> updateCourse(int id, Course course) =>
      _guard(() => dataSource.updateCourse(id, course));

  Future<void> deleteCourse(int id) => _guard(() => dataSource.deleteCourse(id));

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action().timeout(_timeout);
    } catch (e) {
      // Semua error diterjemahkan di sini; UI cukup menampilkan pesannya.
      throw CourseDataException(describeDataError(e));
    }
  }
}
