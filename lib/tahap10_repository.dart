// ============================================================
// Tahap 10: menguji alur Repository -> Service -> (JSON)
// ============================================================

import 'package:flutter/material.dart';
import 'models/course.dart';
import 'repositories/course_repository.dart';
import 'services/course_api_service.dart';

const String studentName = 'Agus Adrian Satria Ananta';
const String studentId = '2415051066';

class Tahap10RepositoryPage extends StatefulWidget {
  const Tahap10RepositoryPage({super.key});

  @override
  State<Tahap10RepositoryPage> createState() => _Tahap10RepositoryPageState();
}

class _Tahap10RepositoryPageState extends State<Tahap10RepositoryPage> {
  // UI memanggil REPOSITORY. Repository yang mengurus service.
  final CourseRepository _repository = CourseRepository(CourseApiService('https://jsonplaceholder.typicode.com/posts'));
  late Future<List<Course>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repository.getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 10 - Repository'),
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
                'Alur: halaman -> CourseRepository.getCourses() '
                '-> CourseService.loadCourses() -> JSON.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const Divider(height: 24),
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
