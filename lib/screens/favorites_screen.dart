// ============================================================
// Praktikum Pemwob - Pertemuan 6
// Tahap 14: Isi tab "Favorites" (body-only, hanya course favorit)
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'course_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CourseProvider p = context.watch<CourseProvider>();
    final List<Course> fav = p.favoriteCourses; // sumber yang sama dgn list

    if (fav.isEmpty) {
      return const Center(child: Text('Belum ada course favorit.'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final c in fav)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CourseCard(
              course: c,
              isFavorite: true, // isinya pasti favorit
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseDetailScreen(course: c),
                ),
              ),
              // Hapus dari favorit -> item langsung hilang di sini.
              onToggleFavorite: () =>
                  context.read<CourseProvider>().toggleFavorite(c.code),
            ),
          ),
      ],
    );
  }
}
