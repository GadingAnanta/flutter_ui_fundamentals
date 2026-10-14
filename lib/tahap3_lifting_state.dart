
// Praktikum Pemwob - Pertemuan 6
// Tahap 3: Lifting State Up dan Single Source of Truth
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
// PARENT = ANCESTOR TERDEKAT YANG MEMBUTUHKAN STATE
class Tahap3LiftingStatePage extends StatefulWidget {
  const Tahap3LiftingStatePage({super.key});

  @override
  State<Tahap3LiftingStatePage> createState() =>
      _Tahap3LiftingStatePageState();
}

class _Tahap3LiftingStatePageState extends State<Tahap3LiftingStatePage> {
  final Set<String> _favorites = <String>{};
  String _selectedCode = 'MOB01';

  void _toggleFavorite(String code) {
    setState(() {
      if (_favorites.contains(code)) {
        _favorites.remove(code);
      } else {
        _favorites.add(code);
      }
    });
  }

  void _selectCourse(String code) {
    setState(() => _selectedCode = code);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> selected = _courses.firstWhere(
      (c) => c['code'] == _selectedCode,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 3 - Lifting State Up'),
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
          const SizedBox(height: 8),

          // Info pemilik state (untuk bukti di screenshot).
          _OwnerBanner(
            jumlahFavorite: _favorites.length,
            selected: _selectedCode,
          ),
          const SizedBox(height: 12),

          // WIDGET A -> menerima DATA via constructor + mengirim AKSI via callback.
          _CourseListPanel(
            favorites: _favorites,
            selectedCode: _selectedCode,
            onSelect: _selectCourse,
            onToggleFavorite: _toggleFavorite,
          ),

          const SizedBox(height: 12),

          // WIDGET B -> memakai state yang SAMA (harus konsisten dengan A).
          _CourseDetailPanel(
            course: selected,
            isFavorite: _favorites.contains(_selectedCode),
            onToggleFavorite: () => _toggleFavorite(_selectedCode),
          ),
        ],
      ),
    );
  }
}
// Banner kecil: menampilkan isi state dari sudut pandang parent.
class _OwnerBanner extends StatelessWidget {
  final int jumlahFavorite;
  final String selected;

  const _OwnerBanner({required this.jumlahFavorite, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Adrian',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Jumlah favorite : $jumlahFavorite'),
            Text('Course terpilih  : $selected'),
          ],
        ),
      ),
    );
  }
}
// WIDGET A: daftar course (StatelessWidget - tidak menyimpan state)
class _CourseListPanel extends StatelessWidget {
  final Set<String> favorites;
  final String selectedCode;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onToggleFavorite;

  const _CourseListPanel({
    required this.favorites,
    required this.selectedCode,
    required this.onSelect,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Widget A - Daftar Course',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          for (final c in _courses)
            _CourseTile(
              course: c,
              // data dari parent (tidak ada salinan lokal)
              isFavorite: favorites.contains(c['code']),
              selected: c['code'] == selectedCode,
              // aksi dikirim balik ke parent
              onSelect: () => onSelect(c['code'] as String),
              onToggleFavorite: () => onToggleFavorite(c['code'] as String),
            ),
        ],
      ),
    );
  }
}
class _CourseTile extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onToggleFavorite;

  const _CourseTile({
    required this.course,
    required this.isFavorite,
    required this.selected,
    required this.onSelect,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: selected,
      title: Text('${course['code']} - ${course['title']}'),
      subtitle: Text('${course['credits']} SKS'),
      onTap: onSelect,
      trailing: IconButton(
        tooltip: 'Toggle favorite',
        icon: Icon(
          isFavorite ? Icons.star : Icons.star_border,
          color: isFavorite ? Colors.amber : Colors.grey,
        ),
        onPressed: onToggleFavorite,
      ),
    );
  }
}
// WIDGET B: detail course (memakai STATE YANG SAMA -> wajib konsisten)
class _CourseDetailPanel extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const _CourseDetailPanel({
    required this.course,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Widget B - Detail Course',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('${course['code']} - ${course['title']}'),
            Text('${course['credits']} SKS'),
            Text(
              'Status favorite: ${isFavorite ? 'FAVORIT' : 'belum favorit'}',
              style: TextStyle(
                color: isFavorite ? Colors.amber.shade800 : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: onToggleFavorite,
                icon: Icon(isFavorite ? Icons.star : Icons.star_border),
                label: Text(
                  isFavorite ? 'Hapus dari favorit' : 'Tambah ke favorit',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}