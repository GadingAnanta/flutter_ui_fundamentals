// ============================================================
// Praktikum Pemwob - Pertemuan 6
// Tahap 12-13: Widget reusable - kartu course (+ icon favorite)
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import 'package:flutter/material.dart';
import '../models/course.dart';

/// Menampilkan satu Course. Ditaruh di widgets/ karena hanya mengurus
/// tampilan sebuah item dan tidak menyimpan state.
class CourseCard extends StatelessWidget {
  final Course course;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onToggleFavorite;

  const CourseCard({
    super.key,
    required this.course,
    this.isFavorite = false,
    this.onTap,
    this.onToggleFavorite,
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(course.statusLabel),
              backgroundColor: _statusColor.withValues(alpha: 0.15),
              side: BorderSide(color: _statusColor),
            ),
            // Icon favorite: tampilannya mengikuti state di Provider.
            IconButton(
              tooltip: isFavorite ? 'Hapus dari favorit' : 'Tambah ke favorit',
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.amber : Colors.grey,
              ),
              onPressed: onToggleFavorite,
            ),
          ],
        ),
      ),
    );
  }
}
