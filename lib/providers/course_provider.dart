// ============================================================
// Praktikum Pemwob - Pertemuan 7
// Tahap 8: CourseProvider Delete Course
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import 'package:flutter/foundation.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  // ---- Shared favorites (application state) ----
  final Set<String> favorites = <String>{};

  bool isFavorite(String code) => favorites.contains(code);

  void toggleFavorite(String code) {
    favorites.contains(code) ? favorites.remove(code) : favorites.add(code);
    notifyListeners();
  }

  int get jumlahFavorite => favorites.length;

  List<Course> get favoriteCourses =>
      courses.where((c) => isFavorite(c.code)).toList();

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCourse(Course course) async {
    try {
      final newCourse = await repository.createCourse(course);
      await loadCourses();
      if (!courses.any((c) => c.code == newCourse.code)) {
        courses.insert(0, newCourse);
      }
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateCourse(int id, Course course) async {
    try {
      await repository.updateCourse(id, course);
      // Perbarui data lokal jika menggunakan mock API latihan
      final index = courses.indexWhere((c) => c.id == id || c.code == course.code);
      if (index != -1) {
        courses[index] = course;
      }
      await loadCourses();
      final updatedIdx = courses.indexWhere((c) => c.code == course.code);
      if (updatedIdx != -1) {
        courses[updatedIdx] = course;
      }
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteCourse(int id, String code) async {
    try {
      await repository.deleteCourse(id);
      // Langsung hapus dari list lokal agar UI responsif
      courses.removeWhere((c) => c.id == id || c.code == code);
      // Hapus dari favorites jika ada
      favorites.remove(code);
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
