// ============================================================
// Praktikum Pemwob - Pertemuan 6
// Tahap 12: Screen - daftar course (memakai Provider + widget reusable)
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/identity_bar.dart';

const String studentName = 'Agus Adrian Satria Ananta';
const String studentId = '2415051066';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  @override
  void initState() {
    super.initState();
    // read (bukan watch) -> memicu aksi tanpa ikut rebuild saat setup.
    context.read<CourseProvider>().loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    // watch -> ikut rebuild ketika isLoading / error / courses berubah.
    final CourseProvider p = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            onPressed: () => context.read<CourseProvider>().loadCourses(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: IdentityBar(name: studentName, nim: studentId),
          ),
          Expanded(child: _buildKondisi(context, p)),
        ],
      ),
    );
  }

  Widget _buildKondisi(BuildContext context, CourseProvider p) {
    // 1) LOADING
    if (p.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2) ERROR
    if (p.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 8),
            Text('Gagal memuat:\n${p.error}', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.read<CourseProvider>().loadCourses(),
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      );
    }

    // 3) SUCCESS
    final List<Course> courses = p.courses;
    if (courses.isEmpty) {
      return const Center(child: Text('Belum ada data course.'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final c in courses)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CourseCard(course: c),
          ),
      ],
    );
  }
}
