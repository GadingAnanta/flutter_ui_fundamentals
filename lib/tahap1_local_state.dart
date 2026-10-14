// ============================================================
// Praktikum Pemwob - Pertemuan 6
// Tahap 1: Mengenal Local State dan Shared State
// Nama : Agus Adrian Satria Ananta
// NIM  : 2415051066
// ============================================================

import 'package:flutter/material.dart';

const String studentName = 'Agus Adrian Satria Ananta';
const String studentId = '2415051066';

class Tahap1LocalStatePage extends StatefulWidget {
  const Tahap1LocalStatePage({super.key});

  @override
  State<Tahap1LocalStatePage> createState() => _Tahap1LocalStatePageState();
}

class _Tahap1LocalStatePageState extends State<Tahap1LocalStatePage> {
  // ----------------------------------------------------------
  // LOCAL STATE (ephemeral): hanya dipakai widget ini sendiri.
  // Cocok dikelola dengan setState(). TIDAK perlu Provider.
  // ----------------------------------------------------------
  bool _favoriteLokal = false; // favorite sementara milik kartu ini
  bool _detailTerbuka = false; // show/hide detail course
  int _jumlahTap = 0; // nilai sementara, untuk membuktikan rebuild

  void _toggleFavoriteLokal() {
    setState(() {
      _favoriteLokal = !_favoriteLokal;
    });
  }

  void _toggleDetail() {
    setState(() {
      _detailTerbuka = !_detailTerbuka;
    });
  }

  void _tambahTap() {
    setState(() {
      _jumlahTap++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 1 - Local vs Shared State'),
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
          const Text(
            'Course Explorer',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          // Identitas wajib terlihat di UI.
          Text('$studentName - $studentId'),
          const Divider(height: 24),

          // ---------------- DEMO LOCAL STATE ----------------
          const Text(
            'Demo Local State (dikelola setState)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: IconButton(
                icon: Icon(
                  _favoriteLokal ? Icons.favorite : Icons.favorite_border,
                ),
                color: Colors.red,
                onPressed: _toggleFavoriteLokal,
              ),
              title: const Text('MOB03 - Flutter UI Fundamentals'),
              subtitle: Text(
                'Favorite lokal: ${_favoriteLokal ? "AKTIF" : "nonaktif"}'
                '  |  Jumlah tap: $_jumlahTap',
              ),
              trailing: IconButton(
                icon: Icon(
                  _detailTerbuka ? Icons.expand_less : Icons.expand_more,
                ),
                onPressed: _toggleDetail,
              ),
              onTap: _tambahTap,
            ),
          ),
          if (_detailTerbuka)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Detail: 3 SKS, status "active". Blok ini hanya muncul '
                'untuk widget ini -> contoh local state (ephemeral).',
              ),
            ),

          const SizedBox(height: 24),

          // ---------------- IDENTIFIKASI 5 STATE ----------------
          const Text(
            'Identifikasi 5 State pada Course Explorer',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ..._daftarState.map(
            (s) => Card(
              child: ListTile(
                dense: true,
                leading: Icon(
                  s.shared ? Icons.groups : Icons.person,
                  color: s.shared ? Colors.deepPurple : Colors.teal,
                ),
                title: Text(s.nama),
                subtitle: Text('${s.jenis}  •  ${s.alasan}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Data pendukung tabel klasifikasi state (biar rapi & mudah dipakai).
class _InfoState {
  final String nama;
  final String jenis;
  final String alasan;
  final bool shared;

  const _InfoState(this.nama, this.jenis, this.alasan, this.shared);
}

const List<_InfoState> _daftarState = [
  _InfoState('_favoriteLokal', 'Local (ephemeral)',
      'Hanya dipakai 1 kartu widget', false),
  _InfoState('_detailTerbuka', 'Local (ephemeral)',
      'Show/hide detail, tidak dibagikan', false),
  _InfoState('selectedIndex (tab)', 'Local (ephemeral)',
      'Hanya untuk navigasi di shell', false),
  _InfoState('favorites (Set<String>)', 'Shared (application)',
      'Dipakai list, detail, dan favorites screen', true),
  _InfoState('courses (List<Course>)', 'Shared (application)',
      'Data dari JSON, dipakai banyak screen', true),
];