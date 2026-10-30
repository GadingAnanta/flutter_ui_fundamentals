// Praktikum Pemwob - Pertemuan 7
// Tahap 17: Pemetaan error data layer menjadi pesan informatif
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';


class CourseDataException implements Exception {
  final String message;
  const CourseDataException(this.message);

  @override
  String toString() => message;
}

/// Menerjemahkan error teknis menjadi pesan yang bisa ditindaklanjuti.
String describeDataError(Object error) {
  if (error is CourseDataException) return error.message;

  // --- Kasus D & E: penolakan dari database/PostgREST ---
  if (error is PostgrestException) {
    switch (error.code) {
      case '42P01':
      case 'PGRST205':
        return 'Tabel database tidak ditemukan (${error.code}). '
            'Periksa nama tabel pada service.';
      case '42501':
        return 'Akses ditolak oleh policy RLS database (42501). '
            'Periksa policy pada tabel courses.';
      case '23505':
        return 'Data duplikat: kode course sudah terdaftar (23505). '
            'Gunakan kode lain.';
      case '23502':
        return 'Kolom wajib belum terisi (23502). '
            'Lengkapi kode dan judul course.';
      case '23514':
        return 'Data melanggar aturan validasi database (23514). '
            'Periksa SKS (>= 0) dan status (planned/active/done).';
      case 'PGRST301':
        return 'Sesi/kunci API ditolak (PGRST301). '
            'Periksa anon key pada lib/config/supabase_config.dart.';
      default:
        return 'Database menolak permintaan: ${error.message}';
    }
  }

  // --- Kasus B: jaringan/timeout ---
  if (error is TimeoutException) {
    return 'Permintaan melebihi batas waktu. '
        'Periksa koneksi internet lalu tekan Coba Lagi.';
  }

  final raw = error.toString();
  if (raw.contains('SocketException') ||
      raw.contains('ClientException') ||
      raw.contains('Failed host lookup') ||
      raw.contains('Connection refused') ||
      raw.contains('XMLHttpRequest error')) {
    return 'Tidak dapat menghubungi server. '
        'Periksa koneksi internet lalu tekan Coba Lagi.';
  }

  // --- Kasus C: data dari server tidak cocok dengan model ---
  if (error is FormatException || raw.contains('is not a subtype of type')) {
    return 'Format data dari server tidak sesuai model Course. '
        'Periksa pemetaan JSON pada Course.fromJson.';
  }

  return 'Terjadi kesalahan: $raw';
}
