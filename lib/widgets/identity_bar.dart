// ============================================================
// Praktikum Pemwob - Pertemuan 6
// Tahap 12: Widget reusable - papan identitas (Nama + NIM)
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import 'package:flutter/material.dart';

/// Widget kecil yang dipakai ulang di banyak screen untuk menampilkan
/// identitas mahasiswa. Ditaruh di widgets/ karena murni tampilan.
class IdentityBar extends StatelessWidget {
  final String name;
  final String nim;

  const IdentityBar({
    super.key,
    required this.name,
    required this.nim,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.indigo.shade200),
      ),
      child: Text(
        '$name - $nim',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
