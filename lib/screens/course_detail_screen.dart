// ============================================================
// Praktikum Pemwob - Pertemuan 7
// Tahap 8: Detail Screen dengan Tombol Edit dan Hapus Course
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

  Future<void> _confirmDelete(BuildContext context, Course liveCourse) async {
    // Tampilkan dialog konfirmasi sebelum menghapus
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Yakin ingin menghapus course:\n"${liveCourse.title}"?\n\nTindakan ini tidak dapat dibatalkan.',
        ),
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 36),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    try {
      final targetId = liveCourse.id ?? 1;
      await context.read<CourseProvider>().deleteCourse(targetId, liveCourse.code);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Course "${liveCourse.title}" berhasil dihapus!'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Kembali ke halaman daftar setelah hapus berhasil
      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus course: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

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
          // Tombol Edit di AppBar
          IconButton(
            tooltip: 'Edit Course',
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CourseFormPage(initialCourse: liveCourse),
              ),
            ),
          ),
          // Tombol Hapus di AppBar
          IconButton(
            tooltip: 'Hapus Course',
            icon: const Icon(Icons.delete_outline),
            color: Colors.red.shade300,
            onPressed: () => _confirmDelete(context, liveCourse),
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

          // Tombol Edit Course
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
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CourseFormPage(initialCourse: liveCourse),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Tombol Hapus Course dengan Konfirmasi Dialog
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.delete_outline),
            label: const Text(
              'Hapus Course (HTTP DELETE)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () => _confirmDelete(context, liveCourse),
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
