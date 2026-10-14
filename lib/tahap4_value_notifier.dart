// Praktikum Pemwob - Pertemuan 6
// Tahap 4: ValueNotifier dan ValueListenableBuilder
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
import 'package:flutter/material.dart';

const String studentName = 'Agus Adrian Satria Ananta';
const String studentId = '2415051066';

const List<Map<String, dynamic>> _courses = [
  {'code': 'MOB01', 'title': 'Git & GitHub', 'credits': 2},
  {'code': 'MOB02', 'title': 'Dart Fundamentals', 'credits': 2},
  {'code': 'MOB03', 'title': 'Flutter UI Fundamentals', 'credits': 3},
  {'code': 'MOB04', 'title': 'Navigation', 'credits': 2},
  {'code': 'MOB05', 'title': 'State Management', 'credits': 3},
];

class Tahap4ValueNotifierPage extends StatefulWidget {
  const Tahap4ValueNotifierPage({super.key});

  @override
  State<Tahap4ValueNotifierPage> createState() =>
      _Tahap4ValueNotifierPageState();
}

class _Tahap4ValueNotifierPageState extends State<Tahap4ValueNotifierPage> {
  // Nilai sederhana yang bisa dipantau tanpa setState().
  final ValueNotifier<int> _jumlahFavorite = ValueNotifier<int>(0);

  // Untuk pembanding: state biasa yang memakai setState().
  bool _contohSetState = false;

  // Penghitung build, supaya kelihatan area mana yang rebuild.
  int _buildHalaman = 0;

  @override
  void dispose() {
    // Wajib: lepaskan listener saat widget dibuang.
    _jumlahFavorite.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    // Hanya mengubah value notifier -> TIDAK memanggil setState().
    _jumlahFavorite.value =
        _jumlahFavorite.value == 0 ? 1 : 0; // demo: on/off
  }

  @override
  Widget build(BuildContext context) {
    _buildHalaman++; // bertambah HANYA saat halaman ini rebuild

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 4 - ValueNotifier'),
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

          // Bukti bahwa halaman ini TIDAK ikut rebuild saat value berubah.
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Halaman ini telah dibuild: $_buildHalaman kali.\n'
                'Ubah ValueNotifier di bawah dan lihat angka ini tetap.',
              ),
            ),
          ),
          const SizedBox(height: 12),

          Card(
            color: Colors.teal.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dipantau dengan ValueListenableBuilder',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<int>(
                    valueListenable: _jumlahFavorite,
                    builder: (context, value, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jumlah favorite: $value',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Status: ${value == 0 ? 'belum ada' : 'ada 1 course favorit'}',
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                value == 0 ? Icons.star_border : Icons.star,
                                color: value == 0 ? Colors.grey : Colors.amber,
                              ),
                              const SizedBox(width: 8),
                              FilledButton(
                                onPressed: _toggleFavorite,
                                child: Text(
                                  value == 0 ? 'Tandai favorit' : 'Batal favorit',
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pembanding',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Nilai: ${_contohSetState ? 'AKTIF' : 'TIDAK AKTIF'}'),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () {
                      setState(() => _contohSetState = !_contohSetState);
                    },
                    child: const Text('Ubah'),
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
            ),
        ],
      ),
    );
  }
}