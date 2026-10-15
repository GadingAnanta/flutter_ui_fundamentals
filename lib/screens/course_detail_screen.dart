// ============================================================
// Praktikum Pemwob - Pertemuan 6
// Tahap 13: Detail screen - menampilkan status favorite
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/identity_bar.dart';

const String studentName = 'Agus Adrian Satria Ananta';
const String studentId = '2415051066';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    // watch -> status favorite ikut berubah bila di-toggle dari screen lain.
    final bool isFavorite =
        context.watch<CourseProvider>().isFavorite(course.code);

    return Scaffold(
      appBar: AppBar(
        title: Text(course.code),
        actions: [
          IconButton(
            tooltip: 'Toggle favorite',
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.amber : null,
            ),
            onPressed: () =>
                context.read<CourseProvider>().toggleFavorite(course.code),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const IdentityBar(name: studentName, nim: studentId),
          const SizedBox(height: 16),
          Text(
            course.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text('Kode   : ${course.code}'),
          Text('SKS    : ${course.credits}'),
          Text('Status : ${course.statusLabel}'),
          const SizedBox(height: 16),
          // Status favorite pada detail (harus konsisten dgn list & favorites).
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
                    context.read<CourseProvider>().toggleFavorite(course.code),
                child: Text(isFavorite ? 'Hapus' : 'Tambah'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
