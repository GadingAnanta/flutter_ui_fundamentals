
// Praktikum Pemwob - Pertemuan 6
// Tahap 2: Masalah setState() Saat Aplikasi Membesar
// Fokus : state ownership, prop drilling, duplikasi state
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066


import 'package:flutter/material.dart';

const String studentName = 'Agus Adrian Satria Ananta';
const String studentId = '2415051066';

// Data course (sama seperti student_data.json).
const List<Map<String, dynamic>> _courses = [
  {'code': 'MOB01', 'title': 'Git & GitHub', 'credits': 2},
  {'code': 'MOB02', 'title': 'Dart Fundamentals', 'credits': 2},
  {'code': 'MOB03', 'title': 'Flutter UI Fundamentals', 'credits': 3},
  {'code': 'MOB04', 'title': 'Navigation', 'credits': 2},
  {'code': 'MOB05', 'title': 'State Management', 'credits': 3},
];

class Tahap2SetStateProblemPage extends StatefulWidget {
  const Tahap2SetStateProblemPage({super.key});

  @override
  State<Tahap2SetStateProblemPage> createState() =>
      _Tahap2SetStateProblemPageState();
}

class _Tahap2SetStateProblemPageState
    extends State<Tahap2SetStateProblemPage> {
  // Satu nilai favorites dimiliki parent.
  final Set<String> _favorites = <String>{};

  void _toggleFavorite(String code) {
    setState(() {
      if (_favorites.contains(code)) {
        _favorites.remove(code);
      } else {
        _favorites.add(code);
      }
    });
  }

  void _clearFavorites() {
    setState(() => _favorites.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 2 - Masalah setState()'),
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
          const SizedBox(height: 4),
          const Text(
            'Satu favorites di parent, diteruskan ke dua child '
            'lewat constructor + callback.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 12),

          // CHILD 1: menerima favorites + callback lewat CONSTRUCTOR.
          _FavoriteSummaryBar(
            favorites: _favorites,
            onClear: _clearFavorites,
          ),

          const SizedBox(height: 12),

          // CHILD 2 (intermediate): sebenarnya TIDAK memakai favorites,
          // tetapi ikut membawanya agar bisa diteruskan ke bawah.
          _CoursesPanel(
            favorites: _favorites,
            onToggleFavorite: _toggleFavorite,
          ),
        ],
      ),
    );
  }
}


// CHILD 1: ringkasan favorite (benar-benar memakai favorites)

class _FavoriteSummaryBar extends StatelessWidget {
  final Set<String> favorites;
  final VoidCallback onClear;

  const _FavoriteSummaryBar({
    required this.favorites,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Child 1 - Ringkasan favorite',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Jumlah favorite: ${favorites.length}'),
                  Text(favorites.isEmpty ? '(belum ada)' : favorites.join(', ')),
                ],
              ),
            ),
            TextButton(onPressed: onClear, child: const Text('Reset')),
          ],
        ),
      ),
    );
  }
}


// CHILD 2 (intermediate): PROP DRILLING ada di sini

class _CoursesPanel extends StatelessWidget {
  final Set<String> favorites;
  final ValueChanged<String> onToggleFavorite;

  const _CoursesPanel({
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Child 2 - Intermediate (tidak butuh state)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('...tapi harus ikut membawa favorites + callback.'),
            const SizedBox(height: 8),
            for (final c in _courses)
              _CourseRow(
                course: c,
                // data diteruskan turun lewat constructor
                isFavorite: favorites.contains(c['code']),
                // aksi diteruskan naik lewat callback
                onToggle: () => onToggleFavorite(c['code'] as String),
              ),
          ],
        ),
      ),
    );
  }
}
// LEAF: baris course (memakai favorites + menampilkan DUPLIKASI)
class _CourseRow extends StatefulWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;
  final VoidCallback onToggle;

  const _CourseRow({
    required this.course,
    required this.isFavorite,
    required this.onToggle,
  });

  @override
  State<_CourseRow> createState() => _CourseRowState();
}

class _CourseRowState extends State<_CourseRow> {
  late bool _salinanLokal = widget.isFavorite;

  @override
  Widget build(BuildContext context) {
    final String code = widget.course['code'] as String;
    final bool sinkron = _salinanLokal == widget.isFavorite;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(code,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${widget.course['title']} • '
                    '${widget.course['credits']} SKS'),
                Text(
                  sinkron
                      ? 'salinan lokal sinkron'
                      : 'salinan lokal BERBEDA (duplikasi state!)',
                  style: TextStyle(
                    fontSize: 11,
                    color: sinkron ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          // Aksi dikirim ke parent lewat callback (state tetap di parent).
          IconButton(
            tooltip: 'Toggle favorite (via callback ke parent)',
            icon: Icon(
              widget.isFavorite ? Icons.star : Icons.star_border,
              color: widget.isFavorite ? Colors.amber : Colors.grey,
            ),
            onPressed: widget.onToggle,
          ),
          IconButton(
            tooltip: 'Ubah salinan lokal saja',
            icon: const Icon(Icons.content_copy, size: 18),
            onPressed: () => setState(() => _salinanLokal = !_salinanLokal),
          ),
        ],
      ),
    );
  }
}