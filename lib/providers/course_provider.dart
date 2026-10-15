// ============================================================
// Praktikum Pemwob - Pertemuan 6
// Tahap 11: Provider untuk Async State (loading / success / error)
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
  // Dipakai oleh lebih dari satu screen -> satu Provider = source of truth.
  final Set<String> favorites = <String>{};

  bool isFavorite(String code) => favorites.contains(code);

  void toggleFavorite(String code) {
    favorites.contains(code)
        ? favorites.remove(code)
        : favorites.add(code);
    notifyListeners();
  }

  int get jumlahFavorite => favorites.length;

  // Daftar course yang sedang difavoritkan (dipakai FavoritesScreen).
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
}