// ============================================================
// Tahap 9: menguji CourseService (data dibaca lewat service, bukan di UI)
// ============================================================

import 'package:flutter/material.dart';
import 'models/course.dart';
import 'services/course_service.dart';

const String studentName = 'Agus Adrian Satria Ananta';
const String studentId = '2415051066';

class Tahap9ServicePage extends StatefulWidget {
  const Tahap9ServicePage({super.key});

  @override
  State<Tahap9ServicePage> createState() => _Tahap9ServicePageState();
}

class _Tahap9ServicePageState extends State<Tahap9ServicePage> {
  // UI memakai SERVICE, bukan rootBundle langsung.
  final CourseService _service = CourseService();
  late Future<List<Course>> _future;

  @override
  void initState() {
    super.initState();
    _future = _muatData();
  }

  Future<List<Course>> _muatData() async {
    final List<Course> courses = await _service.loadCourses();

    // Uji sementara via debugPrint (lihat panel Debug Console).
    for (final c in courses) {
      debugPrint('DEBUG course: ${c.code} - ${c.title} (${c.credits} SKS)');
    }
    return courses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 9 - CourseService'),
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
                'Data berasal dari CourseService.loadCourses() -> List<Course>.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 12),
              for (final c in courses)
                ListTile(
                  leading: CircleAvatar(child: Text(c.code.substring(0, 3))),
                  title: Text(c.title),
                  subtitle: Text('${c.code} • ${c.credits} SKS'),
                  trailing: Text(c.statusLabel),
                ),
            ],
          );
        },
      ),
    );
  }
}