// ============================================================
// Praktikum Pemwob - Pertemuan 7
// Tahap 15: DELETE - Menghapus Data dari Database Supabase
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066


import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  SupabaseClient get supabase => Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    final data = await supabase.from('courses').select().order('id');

    return (data as List)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    final row = await supabase
        .from('courses')
        .insert(course.toJson())
        .select()
        .single();

    return Course.fromJson(row);
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    await supabase.from('courses').update(course.toJson()).eq('id', id);
  }

  @override
  Future<void> deleteCourse(int id) async {
    await supabase.from('courses').delete().eq('id', id);
  }
}
