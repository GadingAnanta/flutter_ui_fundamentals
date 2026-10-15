// ============================================================
// Praktikum Pemwob - Pertemuan 6
// Tahap 14: Isi tab "Profile" (Nama + NIM terlihat jelas)
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import 'package:flutter/material.dart';

const String studentName = 'Agus Adrian Satria Ananta';
const String studentId = '2415051066';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
        SizedBox(height: 16),
        Center(
          child: Text(
            studentName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 4),
        Center(child: Text(studentId)),
        SizedBox(height: 8),
        Center(
          child: Text('Pendidikan Teknologi Informasi - Semester 5'),
        ),
      ],
    );
  }
}
