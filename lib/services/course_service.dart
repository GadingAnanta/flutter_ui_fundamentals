// ============================================================
// Praktikum Pemwob - Pertemuan 6
// Tahap 9: Memisahkan data source ke CourseService
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/course.dart';

/// CourseService bertanggung jawab HANYA pada satu hal:
/// mengambil data mentah (JSON) dan mengubahnya menjadi `List<Course>`.
/// UI tidak lagi tahu dari mana data berasal (asset, file, atau API).
class CourseService {
  final String assetPath;

  const CourseService({this.assetPath = 'assets/data/student_data.json'});

  Future<List<Course>> loadCourses() async {
    final String jsonString = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> data =
        jsonDecode(jsonString) as Map<String, dynamic>;
    final List<dynamic> list = data['courses'] as List<dynamic>;
    return list
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
