// Tahap 5: menampilkan CourseState (ChangeNotifier) lewat listener
// Catatan: Provider belum dipasang, jadi memakai ListenableBuilder.
import 'package:flutter/material.dart';
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

class Tahap5ChangeNotifierPage extends StatefulWidget {
  const Tahap5ChangeNotifierPage({super.key});

  @override
  State<Tahap5ChangeNotifierPage> createState() =>
      _Tahap5ChangeNotifierPageState();
}

class _Tahap5ChangeNotifierPageState extends State<Tahap5ChangeNotifierPage> {
  final CourseState _state = CourseState();

  @override
  void dispose() {
    _state.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 5 - ChangeNotifier'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text(studentId)),
          ),
        ],
      ),
      
      body: ListenableBuilder(
        listenable: _state,
        builder: (context, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('$studentName - $studentId'),
              const SizedBox(height: 12),

              // Ringkasan isi state 
              Card(
                color: Colors.teal.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CourseState (ChangeNotifier)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Jumlah favorite: ${_state.jumlahFavorite}'),
                      Text(
                        _state.favorites.isEmpty
                            ? 'Favorites: (kosong)'
                            : 'Favorites: ${_state.favorites.join(', ')}',
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _state.clearFavorites,
                          child: const Text('Bersihkan'),
                        ),
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
                        'Eksperimen: lupa memanggil notifyListeners()',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Tekan tombol ini lalu lihat count di atas TIDAK berubah.',
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () {
                          _state.favorites.add('TANPA_NOTIF');
                        },
                        child: const Text('Ubah state tanpa notifyListeners()'),
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
                      _state.isFavorite(c['code'] as String)
                          ? Icons.star
                          : Icons.star_border,
                      color: _state.isFavorite(c['code'] as String)
                          ? Colors.amber
                          : Colors.grey,
                    ),
                    // Memanggil method pada object state 
                    onPressed: () => _state.toggleFavorite(c['code'] as String),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}