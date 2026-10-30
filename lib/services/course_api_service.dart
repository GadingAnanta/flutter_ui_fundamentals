// Praktikum Pemwob - Pertemuan 7
// Tahap 7: HTTP PUT/PATCH: Memperbarui Resource
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

  Future<Course> createCourse(Course course) async {
    final response = await http.post(
      _buildUri(),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(course.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      return Course(
        id: data['id'] as int?,
        code: (data['code'] as String?) ?? course.code,
        title: (data['title'] as String?) ?? course.title,
        credits: (data['credits'] as num?)?.toInt() ?? course.credits,
        status: (data['status'] as String?) ?? course.status,
      );
    }
    throw Exception('Gagal membuat course (HTTP ${response.statusCode})');
  }

  Future<void> updateCourse(int id, Course course) async {
    final response = await http.put(
      _buildUri('$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(course.toJson()),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal memperbarui course (HTTP ${response.statusCode})');
    }
  }
}
