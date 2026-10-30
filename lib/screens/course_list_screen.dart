// ============================================================
// Praktikum Pemwob - Pertemuan 7
// Tahap 6: Course List Screen dengan tombol Tambah Course
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
import 'course_form_page.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  @override
  void initState() {
    super.initState();
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
    if (p.isLoading && p.courses.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2) ERROR STATE
    if (p.error != null && p.courses.isEmpty) {
      return ErrorView(
        message: p.error!,
        onRetry: () => context.read<CourseProvider>().loadCourses(),
      );
    }

    final List<Course> courses = p.courses;

    return Column(
      children: [
        // Tombol "+ Tambah Course" sesuai mockup Worksheet
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE6F4EA), // Soft green
                foregroundColor: const Color(0xFF137333),
                elevation: 0,
                side: const BorderSide(color: Color(0xFFCEEAD6)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.add, color: Color(0xFF137333)),
              label: const Text(
                '+ Tambah Course',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF137333),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CourseFormPage()),
                );
              },
            ),
          ),
        ),

        // 3) EMPTY STATE
        if (courses.isEmpty)
          const Expanded(
            child: Center(
              child: Text(
                'Data course belum tersedia',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          )
        else
          // 4) SUCCESS STATE
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => context.read<CourseProvider>().loadCourses(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final c = courses[index];
                  return Padding(
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
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
