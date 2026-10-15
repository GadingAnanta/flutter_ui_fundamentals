// ============================================================
// Praktikum Pemwob - Pertemuan 6
// Tahap 12: Widget reusable - kartu course
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import 'package:flutter/material.dart';
import '../models/course.dart';

/// Menampilkan satu Course. Ditaruh di widgets/ karena hanya mengurus
/// tampilan sebuah item dan tidak menyimpan state.
class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.course,
    this.onTap,
  });

  Color get _statusColor {
    switch (course.status) {
      case 'done':
        return Colors.green;
      case 'active':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: _statusColor.withValues(alpha: 0.15),
          child: Text(course.code.substring(0, 3)),
        ),
        title: Text(course.title),
        subtitle: Text('${course.code} • ${course.credits} SKS'),
        trailing: Chip(
          label: Text(course.statusLabel),
          backgroundColor: _statusColor.withValues(alpha: 0.15),
          side: BorderSide(color: _statusColor),
        ),
      ),
    );
  }
}
