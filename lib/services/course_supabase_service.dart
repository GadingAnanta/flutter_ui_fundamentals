// ============================================================
// Praktikum Pemwob - Pertemuan 7
// Tahap 13: INSERT - Menambah Data ke Database Supabase
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================
//
// CourseSupabaseService mengimplementasikan kontrak CourseDataSource
// (Tahap 9) dengan sumber data tabel `courses` di Supabase.
// SELECT (Tahap 12) dan INSERT (Tahap 13) sudah aktif;
// UPDATE/DELETE masih stub sampai Tahap 14-15.

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
  // Tahap 13: INSERT course baru ke tabel `courses`.
  // `.select().single()` mengembalikan baris yang baru dibuat
  // (termasuk id) supaya repository & provider menerima Course utuh.
  // ------------------------------------------------------------
  @override
  Future<Course> createCourse(Course course) async {
    final row = await supabase
        .from('courses')
        .insert(course.toJson())
        .select()
        .single();

    return Course.fromJson(row);
  }

  // ------------------------------------------------------------
  // Tahap 14-15: belum diimplementasikan.
  // ------------------------------------------------------------
  @override
  Future<void> updateCourse(int id, Course course) =>
      throw UnimplementedError();

  @override
  Future<void> deleteCourse(int id) => throw UnimplementedError();
}
