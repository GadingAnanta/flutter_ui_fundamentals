// ============================================================
// Praktikum Pemwob - Pertemuan 6
// Tahap 13: Favorites screen - hanya menampilkan course favorit
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/identity_bar.dart';
import 'course_detail_screen.dart';

const String studentName = 'Agus Adrian Satria Ananta';
const String studentId = '2415051066';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CourseProvider p = context.watch<CourseProvider>();
    final List<Course> fav = p.favoriteCourses; // sumber yang sama dgn list

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites (${fav.length})'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: IdentityBar(name: studentName, nim: studentId),
          ),
          Expanded(
            child: fav.isEmpty
                ? const Center(child: Text('Belum ada course favorit.'))
                : ListView(
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
                            onToggleFavorite: () => context
                                .read<CourseProvider>()
                                .toggleFavorite(c.code),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
