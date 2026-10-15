// ============================================================
// Praktikum Pemwob - Pertemuan 6
// Tahap 6: Memasang Provider pada Widget Tree
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_state.dart';

const String studentName = 'Agus Adrian Satria Ananta';
const String studentId = '2415051066';

const List<Map<String, dynamic>> _courses = [
  {'code': 'MOB01', 'title': 'Git & GitHub', 'credits': 2},
  {'code': 'MOB02', 'title': 'Dart Fundamentals', 'credits': 2},
  {'code': 'MOB03', 'title': 'Flutter UI Fundamentals', 'credits': 3},
  {'code': 'MOB04', 'title': 'Navigation', 'credits': 2},
  {'code': 'MOB05', 'title': 'State Management', 'credits': 3},
];

class Tahap6ProviderSetupPage extends StatelessWidget {
  const Tahap6ProviderSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca CourseState dari widget tree (Provider sudah di atas MaterialApp).
    // listen: true (default) -> rebuild saat notifyListeners().
    final CourseState state = Provider.of<CourseState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 6 - Provider Setup'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text(studentId)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('$studentName - $studentId'),
          const SizedBox(height: 12),

          Card(
            color: Colors.teal.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CourseState diakses dari widget tree',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Jumlah favorite: ${state.jumlahFavorite}'),
                  Text(
                    state.favorites.isEmpty
                        ? 'Favorites: (kosong)'
                        : 'Favorites: ${state.favorites.join(', ')}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          const Text(
            'Daftar course',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          for (final c in _courses)
            ListTile(
              dense: true,
              title: Text('${c['code']} - ${c['title']}'),
              subtitle: Text('${c['credits']} SKS'),
              trailing: IconButton(
                tooltip: 'Toggle favorite',
                icon: Icon(
                  state.isFavorite(c['code'] as String)
                      ? Icons.star
                      : Icons.star_border,
                  color: state.isFavorite(c['code'] as String)
                      ? Colors.amber
                      : Colors.grey,
                ),
                // Aksi: ambil object TANPA listen (listen: false).
                onPressed: () => Provider.of<CourseState>(
                  context,
                  listen: false,
                ).toggleFavorite(c['code'] as String),
              ),
            ),
        ],
      ),
    );
  }
}