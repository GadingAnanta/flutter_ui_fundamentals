// ============================================================
// Praktikum Pemwob - Pertemuan 6
// Tahap 15: Debugging State Management (ChangeNotifier / Provider)
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/identity_bar.dart';

const String studentName = 'Agus Adrian Satria Ananta';
const String studentId = '2415051066';

class Tahap15DebuggingPage extends StatefulWidget {
  const Tahap15DebuggingPage({super.key});

  @override
  State<Tahap15DebuggingPage> createState() => _Tahap15DebuggingPageState();
}

class _Tahap15DebuggingPageState extends State<Tahap15DebuggingPage> {
  String _hasilAsync = '(belum dijalankan)';

  Future<void> _jalankanAsync() async {
    // Simulasi operasi async (mis. permintaan data).
    await Future<void>.delayed(const Duration(milliseconds: 800));

    // KASUS D: setelah async, widget bisa saja sudah dibuang.
    // Periksa mounted SEBELUM memakai context / memanggil setState.
    if (!mounted) return;

    setState(() {
      _hasilAsync = 'Selesai pada ${DateTime.now().toLocal()}';
    });
  }

  @override
  Widget build(BuildContext context) {
    // watch -> ikut rebuild saat notifyListeners() dipanggil.
    final CourseProvider p = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 15 - Debugging State')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const IdentityBar(name: studentName, nim: studentId),
          const SizedBox(height: 12),

          // ---- Catatan tiap kasus ----
          _kartu(
            judul: 'Kasus A - notifyListeners() dihapus',
            masalah:
                'Jika notifyListeners() dihapus sementara dari toggleFavorite(), '
                'state berubah tetapi UI tidak ikut berubah (angka ★ tetap).',
            perbaikan:
                'Pastikan setiap perubahan state disusul notifyListeners(). '
                'Pulihkan setelah memahami efeknya.',
          ),
          _kartu(
            judul: 'Kasus B - context di ATAS ChangeNotifierProvider',
            masalah:
                'Memakai Provider dari context yang berada di atas '
                'ChangeNotifierProvider memunculkan ProviderNotFoundException.',
            perbaikan:
                'Ambil Provider dari context yang berada DI BAWAH provider '
                '(widget yang dibungkus), bukan dari atasnya.',
          ),
          _kartu(
            judul: 'Kasus C - error pada CourseService',
            masalah:
                'Jika loadString menunjuk berkas yang salah, loadCourses() '
                'menangkap error dan mengisi state error.',
            perbaikan:
                'UI membaca error != null lalu menampilkan pesan + tombol "Coba lagi".',
          ),
          _kartu(
            judul: 'Kasus D - perubahan state setelah async',
            masalah:
                'setState()/context dipakai setelah await padahal widget mungkin '
                'sudah dibuang -> peringatan use_build_context_synchronously.',
            perbaikan: 'Selalu periksa if (!mounted) return; sebelum setState().',
          ),

          const SizedBox(height: 8),

          // ---- Demo Kasus D ----
          const Text(
            'Demo Kasus D (async + mounted)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.timer_outlined),
              title: const Text('Status async'),
              subtitle: Text(_hasilAsync),
              trailing: ElevatedButton(
                onPressed: _jalankanAsync,
                child: const Text('Jalankan'),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ---- Demo Kasus A ----
          const Text(
            'Demo Kasus A (favorite + notifyListeners)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text(
            'Tap bintang. Jika notifyListeners() dihapus sementara, angka ★ '
            'tidak akan berubah.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(
                p.isFavorite('MOB03') ? Icons.star : Icons.star_border,
                color: p.isFavorite('MOB03') ? Colors.amber : Colors.grey,
              ),
              title: const Text('MOB03 - Flutter UI Fundamentals'),
              subtitle: Text('Jumlah favorite: ${p.jumlahFavorite}'),
              trailing: ElevatedButton(
                onPressed: () =>
                    context.read<CourseProvider>().toggleFavorite('MOB03'),
                child: const Text('Toggle MOB03'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartu({
    required String judul,
    required String masalah,
    required String perbaikan,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(judul, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Masalah: $masalah'),
            const SizedBox(height: 4),
            Text(
              'Perbaikan: $perbaikan',
              style: const TextStyle(color: Colors.indigo),
            ),
          ],
        ),
      ),
    );
  }
}
