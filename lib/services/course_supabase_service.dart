// ============================================================
// Praktikum Pemwob - Pertemuan 7
// Tahap 15: DELETE - Menghapus Data dari Database Supabase
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================
//
// CourseSupabaseService mengimplementasikan kontrak CourseDataSource
// (Tahap 9) dengan sumber data tabel `courses` di Supabase.
// Keempat operasi CRUD sudah aktif: SELECT (12), INSERT (13),
// UPDATE (14), dan DELETE (15).

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
  // Tahap 14: UPDATE baris course berdasarkan id.
  // `.eq('id', id)` WAJIB ada — tanpa itu semua baris akan terupdate.
  // ------------------------------------------------------------
  @override
  Future<void> updateCourse(int id, Course course) async {
    await supabase.from('courses').update(course.toJson()).eq('id', id);
  }

  // ------------------------------------------------------------
  // Tahap 15: DELETE baris course berdasarkan id.
  // Konfirmasi dilakukan di UI (dialog pada halaman detail) supaya
  // service tetap fokus pada satu tugas: menghapus satu baris.
  // ------------------------------------------------------------
  @override
  Future<void> deleteCourse(int id) async {
    await supabase.from('courses').delete().eq('id', id);
  }
}
