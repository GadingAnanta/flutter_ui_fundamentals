// ============================================================
// Tahap 8: mengubah data JSON menjadi object Course lalu menampilkannya.
// Catatan: pembacaan JSON masih inline di sini (dipindah ke Service di Tahap 9).
// ============================================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'models/course.dart';

const String studentName = 'Agus Adrian Satria Ananta';
const String studentId = '2415051066';

class Tahap8ModelCoursePage extends StatefulWidget {
  const Tahap8ModelCoursePage({super.key});

  @override
  State<Tahap8ModelCoursePage> createState() => _Tahap8ModelCoursePageState();
}

class _Tahap8ModelCoursePageState extends State<Tahap8ModelCoursePage> {
  late Future<List<Course>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadCourses();
  }

  // Membaca JSON lalu mengubahnya menjadi List<Course>.
  Future<List<Course>> _loadCourses() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/student_data.json');
    final Map<String, dynamic> data =
        jsonDecode(jsonString) as Map<String, dynamic>;
    final List<dynamic> list = data['courses'] as List<dynamic>;
    // INILAH kuncinya: Map -> Course.fromJson
    return list
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 8 - Model Course'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text(studentId)),
          ),
        ],
      ),
      body: FutureBuilder<List<Course>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat: ${snapshot.error}'));
          }

          final List<Course> courses = snapshot.data ?? const [];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('$studentName - $studentId'),
              const SizedBox(height: 4),
              const Text(
                'Data di bawah ini berasal dari object Course (bukan Map).',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 12),

              for (final c in courses)
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(c.code.substring(0, 3)),
                    ),
                    title: Text(c.title),
                    subtitle: Text('${c.code} • ${c.credits} SKS'),
                    trailing: Chip(label: Text(c.statusLabel)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}