// ============================================================
// Praktikum Pemwob - Pertemuan 7
// Tahap 12: SELECT - Membaca Data dari Database Supabase
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================
//
// CourseSupabaseService mengimplementasikan kontrak CourseDataSource
// (Tahap 9) dengan sumber data tabel `courses` di Supabase.
// Method yang belum dikerjakan (INSERT/UPDATE/DELETE) masih berupa
// stub UnimplementedError agar kelas tetap dapat dikompilasi.

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  /// Diambil lewat getter (bukan field final) supaya client baru
  /// diminta saat dipakai, sehingga aman walau objek dibuat lebih dulu.
  SupabaseClient get supabase => Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    final data = await supabase.from('courses').select().order('id');

    return (data as List)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ------------------------------------------------------------
  // Tahap 13-15: belum diimplementasikan.
  // ------------------------------------------------------------
  @override
  Future<Course> createCourse(Course course) => throw UnimplementedError();

  @override
  Future<void> updateCourse(int id, Course course) =>
      throw UnimplementedError();

  @override
  Future<void> deleteCourse(int id) => throw UnimplementedError();
}
