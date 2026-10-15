// Praktikum Pemwob - Pertemuan 6
// Tahap 7: context.watch(), context.read(), dan Consumer
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
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

class Tahap7WatchReadPage extends StatelessWidget {
  const Tahap7WatchReadPage({super.key});

  @override
  Widget build(BuildContext context) {
    // context.watch: MEMBACA state untuk ditampilkan -> rebuild saat berubah.
    final CourseState state = context.watch<CourseState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 7 - watch / read / Consumer'),
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

          // Bagian ini memakai watch() -> ikut rebuild saat favorite berubah.
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ringkasan',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Jumlah favorite: ${state.jumlahFavorite}'),
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
            Consumer<CourseState>(
              builder: (context, s, child) {
                final String code = c['code'] as String;
                return ListTile(
                  dense: true,
                  title: Text('$code - ${c['title']}'),
                  subtitle: Text('${c['credits']} SKS'),
                  trailing: IconButton(
                    tooltip: 'Toggle favorite',
                    icon: Icon(
                      s.isFavorite(code) ? Icons.star : Icons.star_border,
                      color: s.isFavorite(code) ? Colors.amber : Colors.grey,
                    ),
                    // context.read: hanya memanggil AKSI, tanpa listen.
                    onPressed: () =>
                        context.read<CourseState>().toggleFavorite(code),
                  ),
                );
              },
            ),

          const SizedBox(height: 12),
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Course yang dipilih: ${state.jumlahFavorite}'
                'sebagai favorit.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}