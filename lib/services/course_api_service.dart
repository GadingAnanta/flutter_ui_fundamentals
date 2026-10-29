// Praktikum Pemwob - Pertemuan 7
// Tahap 4: Memindahkan HTTP ke Service Layer
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066


import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';

class CourseApiService {
  CourseApiService(this.baseUrl);
  final String baseUrl;

  Uri _buildUri([String path = '']) {
    final cleanBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    if (cleanBase.endsWith('/courses') || cleanBase.endsWith('/posts')) {
      return path.isEmpty ? Uri.parse(cleanBase) : Uri.parse('$cleanBase/$path');
    }
    return path.isEmpty ? Uri.parse('$cleanBase/courses') : Uri.parse('$cleanBase/courses/$path');
  }

  Future<List<Course>> getCourses() async {
    final response = await http.get(_buildUri());
    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil course (HTTP ${response.statusCode})');
    }
    final List data = jsonDecode(response.body) as List;
    return data
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

