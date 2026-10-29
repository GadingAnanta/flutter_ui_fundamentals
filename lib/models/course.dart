// ============================================================
// Praktikum Pemwob - Pertemuan 7
// Tahap 3: Model Course + fromJson & toJson
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
  });

  /// Label status ramah pengguna untuk UI
  String get statusLabel {
    switch (status) {
      case 'done':
        return 'Selesai';
      case 'active':
        return 'Aktif';
      case 'planned':
        return 'Direncanakan';
      default:
        return status;
    }
  }

  /// Mengubah Map hasil jsonDecode menjadi objek Course typed
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      // Fallback toleran jika menggunakan API latihan umum seperti JSONPlaceholder
      code: (json['code'] as String?) ?? 'MOB0${json['id'] ?? 1}',
      title: (json['title'] as String?) ?? 'Untitled Course',
      credits: (json['credits'] as num?)?.toInt() ?? 2,
      status: (json['status'] as String?) ?? 'planned',
    );
  }

  /// Mengubah objek Course menjadi Map JSON untuk POST/PUT ke API / database
  Map<String, dynamic> toJson() => {
    'code': code,
    'title': title,
    'credits': credits,
    'status': status,
  };

  /// Salin objek dengan perubahan atribut tertentu (opsional)
  Course copyWith({
    int? id,
    String? code,
    String? title,
    int? credits,
    String? status,
  }) {
    return Course(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      credits: credits ?? this.credits,
      status: status ?? this.status,
    );
  }
}
