// ============================================================
// Praktikum Pemwob - Pertemuan 7
// Tahap 7: Detail Screen dengan Tombol Edit Course
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/identity_bar.dart';
import 'course_form_page.dart';

const String studentName = 'Agus Adrian Satria Ananta';
const String studentId = '2415051066';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    // Ambil data course terkini dari provider (jika baru saja di-update)
    final liveCourse = context
        .watch<CourseProvider>()
        .courses
        .firstWhere((c) => c.code == course.code, orElse: () => course);

    final bool isFavorite =
        context.watch<CourseProvider>().isFavorite(liveCourse.code);

    return Scaffold(
      appBar: AppBar(
        title: Text(liveCourse.code),
        actions: [
          // Tombol Edit Course di AppBar
          IconButton(
            tooltip: 'Edit Course',
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseFormPage(initialCourse: liveCourse),
                ),
              );
            },
          ),
          // Tombol Favorite
          IconButton(
            tooltip: 'Toggle favorite',
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.amber : null,
            ),
            onPressed: () =>
                context.read<CourseProvider>().toggleFavorite(liveCourse.code),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const IdentityBar(name: studentName, nim: studentId),
          const SizedBox(height: 16),
          Text(
            liveCourse.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text('Kode   : ${liveCourse.code}'),
          Text('SKS    : ${liveCourse.credits}'),
          Text('Status : ${liveCourse.statusLabel}'),
          const SizedBox(height: 20),

          // Tombol Aksi Edit Course
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.edit),
            label: const Text(
              'Edit Course (HTTP PUT)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseFormPage(initialCourse: liveCourse),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Status favorite pada detail
          Card(
            color: isFavorite ? Colors.amber.shade50 : Colors.grey.shade100,
            child: ListTile(
              leading: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.amber : Colors.grey,
              ),
              title: Text(
                isFavorite
                    ? 'Course ini ada di favorit'
                    : 'Course ini belum difavoritkan',
              ),
              trailing: TextButton(
                onPressed: () =>
                    context.read<CourseProvider>().toggleFavorite(liveCourse.code),
                child: Text(isFavorite ? 'Hapus' : 'Tambah'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
