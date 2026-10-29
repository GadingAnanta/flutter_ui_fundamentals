// Praktikum Pemwob - Pertemuan 7
// Tahap 3: Model Dart (Course.fromJson() dan toJson())
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/course.dart';
import 'widgets/identity_bar.dart';

const String studentName = 'Agus Adrian Satria Ananta';
const String studentId = '2415051066';
const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';

class Tahap3ModelDartPage extends StatefulWidget {
  const Tahap3ModelDartPage({super.key});

  @override
  State<Tahap3ModelDartPage> createState() => _Tahap3ModelDartPageState();
}

class _Tahap3ModelDartPageState extends State<Tahap3ModelDartPage> {
  late Future<List<Course>> _futureCourses;

  Future<List<Course>> fetchCoursesAsModel() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> rawList = jsonDecode(response.body) as List<dynamic>;

      // Konversi List<dynamic> (Map) menjadi typed List<Course>
      final List<Course> courses = rawList
          .map((item) => Course.fromJson(item as Map<String, dynamic>))
          .toList();

      debugPrint('Berhasil mapping ke Model Course: ${courses.length} objek');
      return courses;
    }

    throw Exception('HTTP ${response.statusCode}: Gagal mengambil data');
  }

  @override
  void initState() {
    super.initState();
    _futureCourses = fetchCoursesAsModel();
  }

  void _reload() {
    setState(() {
      _futureCourses = fetchCoursesAsModel();
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'done':
        return Colors.green;
      case 'active':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 3 - Model Course'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: IdentityBar(name: studentName, nim: studentId),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              color: Colors.indigo.shade50,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.data_object, color: Colors.indigo),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Data JSON berhasil dimapping ke objek bertipe Course. Menampilkan code, title, credits, dan status.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Course>>(
              future: _futureCourses,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Memproses JSON ke Model Course...'),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 8),
                        Text('Error: ${snapshot.error}'),
                        ElevatedButton(
                          onPressed: _reload,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                final List<Course> courses = snapshot.data ?? [];
                if (courses.isEmpty) {
                  return const Center(child: Text('Data course kosong'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: courses.length > 5 ? 5 : courses.length, // Tampilkan 5 course teratas
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    final color = _getStatusColor(course.status);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: color.withValues(alpha: 0.15),
                          child: Text(
                            course.code.length > 3 ? course.code.substring(0, 3) : course.code,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        title: Text(
                          course.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          'Kode: ${course.code} • SKS: ${course.credits}',
                        ),
                        trailing: Chip(
                          label: Text(
                            course.statusLabel,
                            style: TextStyle(color: color, fontSize: 11),
                          ),
                          backgroundColor: color.withValues(alpha: 0.1),
                          side: BorderSide(color: color),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

