// ============================================================
// Praktikum Pemwob - Pertemuan 6
// Tahap 11: Halaman demo async state (loading / success / error)
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/course.dart';
import 'providers/course_provider.dart';

const String studentName = 'Agus Adrian Satria Ananta';
const String studentId = '2415051066';

class Tahap11AsyncStatePage extends StatefulWidget {
  // Wajib const supaya bisa dipakai di dalam const MaterialApp.
  const Tahap11AsyncStatePage({super.key});

  @override
  State<Tahap11AsyncStatePage> createState() => _Tahap11AsyncStatePageState();
}

class _Tahap11AsyncStatePageState extends State<Tahap11AsyncStatePage> {
  @override
  void initState() {
    super.initState();
    // read (bukan watch) -> memicu aksi tanpa ikut rebuild saat setup.
    context.read<CourseProvider>().loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    // watch -> ikut rebuild ketika isLoading / error / courses berubah.
    final CourseProvider p = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 11 - Async State'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            onPressed: () => context.read<CourseProvider>().loadCourses(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          // Papan identitas: Nama + NIM (untuk bukti praktikum).
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: const Text(
                '$studentName - $studentId',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(child: _buildKondisi(context, p)),
        ],
      ),
    );
  }

  Widget _buildKondisi(BuildContext context, CourseProvider p) {
    // 1) LOADING
    if (p.isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Memuat data...'),
          ],
        ),
      );
    }

    // 2) ERROR
    if (p.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 8),
              Text(
                'Gagal memuat data:\n${p.error}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.read<CourseProvider>().loadCourses(),
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }

    // 3) SUCCESS
    final List<Course> courses = p.courses;
    if (courses.isEmpty) {
      return const Center(child: Text('Belum ada data course.'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Status: success - data berasal dari CourseProvider.',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        for (final c in courses)
          Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(c.code.substring(0, 3))),
              title: Text(c.title),
              subtitle: Text('${c.code} • ${c.credits} SKS'),
              trailing: Chip(label: Text(c.statusLabel)),
            ),
          ),
      ],
    );
  }
}
