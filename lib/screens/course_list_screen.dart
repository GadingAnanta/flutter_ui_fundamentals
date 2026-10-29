// ============================================================
// Praktikum Pemwob - Pertemuan 7
// Tahap 5: Loading, Success, Empty, dan Error State
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
import 'course_detail_screen.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  @override
  void initState() {
    super.initState();
    // Panggil loadCourses saat widget diinisialisasi (bukan dari build)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CourseProvider>().loadCourses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final CourseProvider p = context.watch<CourseProvider>();

    // 1) LOADING STATE
    if (p.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2) ERROR STATE
    if (p.error != null) {
      return ErrorView(
        message: p.error!,
        onRetry: () => context.read<CourseProvider>().loadCourses(),
      );
    }

    // 3) EMPTY STATE
    final List<Course> courses = p.courses;
    if (courses.isEmpty) {
      return const Center(
        child: Text(
          'Data course belum tersedia',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // 4) SUCCESS STATE
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final c in courses)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CourseCard(
              course: c,
              isFavorite: p.isFavorite(c.code),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseDetailScreen(course: c),
                ),
              ),
              onToggleFavorite: () =>
                  context.read<CourseProvider>().toggleFavorite(c.code),
            ),
          ),
      ],
    );
  }
}
