// ============================================================
// Praktikum Pemwob - Pertemuan 6
// Tahap 8: Model Course + parsing JSON
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

class Course {
  final String code;
  final String title;
  final int credits;
  final String status; // done | active | planned

  const Course({
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
  });

  /// Label status yang ramah dibaca manusia.
  String get statusLabel {
    switch (status) {
      case 'done':
        return 'Selesai';
      case 'active':
        return 'Sedang Berjalan';
      case 'planned':
        return 'Direncanakan';
      default:
        return status;
    }
  }

  /// Mengubah Map hasil jsonDecode menjadi object Course.
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      code: json['code'] as String,
      title: json['title'] as String,
      credits: (json['credits'] as num).toInt(),
      status: (json['status'] ?? 'planned') as String,
    );
  }

  /// Kebalikannya: object Course menjadi Map (dipakai bila perlu kirim/simpan).
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'title': title,
      'credits': credits,
      'status': status,
    };
  }
}
