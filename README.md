# Course Data Manager — flutter_ui_fundamentals

Aplikasi Flutter **Course Data Manager** untuk Praktikum Pemrograman Web & Mobile
(Pemwob) **Pertemuan 7: RESTful API, Backend Services & Database Integration**.
Aplikasi merupakan pengembangan **Course Explorer v2** (Pertemuan 5–6) yang kini
mengambil data dari backend **Supabase (PostgreSQL)** dan mendukung CRUD penuh.

- Nama: Agus Adrian Satria Ananta
- NIM: 2415051066
- Kelas: PTI 5 C

## Deskripsi Aplikasi

Course Data Manager menampilkan daftar mata kuliah (course) yang tersimpan di
database, lengkap dengan operasi tambah, ubah, dan hapus. Identitas mahasiswa
(Nama & NIM) ditampilkan pada setiap layar melalui widget `IdentityBar`.

Fitur utama:

| Fitur | Keterangan |
|---|---|
| Read / SELECT | Daftar course dimuat dari tabel `courses` saat aplikasi dibuka, saat tab dibuka, dan saat pull-to-refresh |
| Create / INSERT | Form **Tambah Course** dengan validasi kode, judul, dan SKS |
| Update / UPDATE | Form **Edit Course** dari halaman detail (kode dikunci sebagai kunci relasi) |
| Delete / DELETE | Tombol hapus dengan dialog konfirmasi sebelum eksekusi |
| State lengkap | Loading, empty, success, error + tombol **Coba Lagi (Retry)** |
| Feedback | SnackBar hijau/merah untuk operasi berhasil/gagal |
| Navigasi responsif | `NavigationRail` pada layar lebar (≥ 840 px), `NavigationBar` pada layar sempit |
| Favorites | Tetap berfungsi dari Pertemuan 5–6, memakai `code` sebagai kunci, konsisten di tab Courses dan Favorites |

## Backend yang Digunakan

| Komponen | Keterangan |
|---|---|
| Backend/database | **Supabase** (PostgreSQL) — sumber data final aplikasi |
| Tabel | `public.courses` |
| Client | `supabase_flutter` 2.18.x dengan *publishable/anon key* |
| REST latihan (opsional) | `https://jsonplaceholder.typicode.com/posts` melalui `CourseApiService`, dipakai pada Tahap 1–9 |

### Skema tabel `courses`

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | `bigint` identity | Primary key |
| `code` | `text` | Kode course (mis. `MOB01`), unik, dipakai sebagai kunci favorites |
| `title` | `text` | Judul course |
| `credits` | `int` | Jumlah SKS (`CHECK credits >= 0`) |
| `status` | `text` | `planned` / `active` / `done` (`CHECK`) |
| `created_at` | `timestamptz` | Default `now()` |

Script SQL lengkap (tabel, CHECK, unique index `code`, data awal, RLS + policy):

```
supabase/migrations/0001_create_courses.sql
```

Nama kolom sengaja sama dengan key `Course.fromJson()` / `toJson()`
(`code`, `title`, `credits`, `status`) sehingga mapping JSON tidak perlu diubah.

### Mengganti sumber data (REST ↔ Supabase)

Pemilihan data source hanya dilakukan di `lib/main.dart`; screen, provider, dan
repository tidak perlu diubah:

```dart
// lib/main.dart — data source aktif: Supabase
// (untuk REST: CourseApiService(apiBaseUrl))
final CourseDataSource dataSource = CourseSupabaseService();
final repository = CourseRepository(dataSource);
```

## Arsitektur & Arah Dependency

```
Screen / Widget  ->  Provider  ->  Repository  ->  Service / Data Source
```

- UI (screens/widgets) tidak pernah mengakses Supabase/HTTP secara langsung.
- `CourseProvider` tidak berisi detail package HTTP/Supabase.
- `CourseRepository` menjadi satu-satunya tempat penerjemahan error teknis
  (PostgREST, jaringan, JSON) menjadi pesan yang informatif.

## Struktur Folder (`lib/`)

| Folder | Tanggung jawab |
|---|---|
| `models/` | Bentuk data murni (`Course`) termasuk `fromJson`/`toJson` |
| `services/` | `CourseDataSource` (kontrak), `CourseApiService` (REST), `CourseSupabaseService` (Supabase), `data_error.dart` (pemetaan error) |
| `repositories/` | `CourseRepository`: abstraksi data untuk provider + timeout + error mapping |
| `providers/` | `CourseProvider`: state (`courses`, `isLoading`, `error`, `favorites`) dan business logic |
| `screens/` | `CourseExplorerShell` (shell responsif), daftar course, favorites, detail, form, profil |
| `widgets/` | `CourseCard`, `IdentityBar`, `ErrorView` |
| `config/` | `supabase_config.dart` (URL project + publishable key) |

## Menjalankan

### 1. Prasyarat

- Flutter SDK 3.x (proyek diuji pada Flutter 3.47.3)
- Akun/proyek Supabase dengan tabel `courses`

### 2. Konfigurasi backend

Isi `lib/config/supabase_config.dart`:

```dart
const String supabaseUrl = 'https://<project-ref>.supabase.co'; // bukan URL dashboard
const String supabasePublishableKey = '<publishable/anon key>';
```

Jalankan `supabase/migrations/0001_create_courses.sql` pada SQL Editor Supabase
bila tabel belum tersedia. Gunakan hanya anon/publishable key; **jangan pernah**
menaruh `service_role` key di aplikasi klien.

### 3. Menjalankan aplikasi

```bash
flutter pub get
flutter run -d chrome     # atau: flutter run -d <device-id>
```

Catatan Windows: `flutter run -d windows` memerlukan Developer Mode aktif
(plugin memakai symlink); Chrome tidak memerlukan langkah tambahan.

### 4. Uji cepat CRUD

1. Daftar terisi otomatis dari Supabase.
2. **+ Tambah Course** → isi kode baru → simpan → data muncul di daftar.
3. Buka detail → **Edit** → ubah judul/SKS/status → simpan.
4. Buka detail → **Hapus Course** → konfirmasi dialog → data hilang dari daftar.
5. Periksa hasil yang sama pada Table Editor Supabase.

## REST API Latihan (Tahap 1)

- Endpoint: `https://jsonplaceholder.typicode.com/posts`
- Method: `GET` (Tahap 2), `POST` (6), `PUT` (7), `DELETE` (8)
- Status yang diharapkan: `200 OK`; contoh representasi resource:

```json
{
  "id": 1,
  "code": "MOB01",
  "title": "Git & GitHub",
  "credits": 2,
  "status": "active"
}
```

## Keamanan

- RLS aktif pada tabel `courses`. Policy `courses_all_lab` bersifat permisif
  (`using (true) with check (true)`) dan **hanya untuk lingkungan praktikum**.
- Aplikasi hanya memakai *publishable/anon key*; `service_role` key tidak ada di
  source code.
- `.env` dan variannya sudah diabaikan melalui `.gitignore`.
- Validasi form bukan pengganti validasi backend: `NOT NULL`, `CHECK`, dan
  `UNIQUE` pada database tetap menjadi penegak terakhir.

## Catatan

- Provider tidak menyimpan `BuildContext` sebagai state.
- File `lib/tahap*_*.dart` dan `lib/services.dart` adalah artefak demo pertemuan
  sebelumnya (bukti praktikum); kode aplikasi final berada di folder
  `models/`, `services/`, `repositories/`, `providers/`, `screens/`, `widgets/`,
  dan `config/`.

## Riwayat Commit per Tahap (Pertemuan 7)

| Tahap | Pesan commit |
|---|---|
| 0 | `Siapkan project untuk integrasi REST API` |
| 1 | `Dokumentasikan endpoint REST dan struktur JSON` |
| 2 | `Implementasikan HTTP GET dan parsing response` |
| 3 | `Tambahkan model Course dan JSON mapping` |
| 4 | `Pisahkan akses REST API ke service layer` |
| 5 | `Tambahkan loading empty error dan retry state` |
| 6 | `Tambahkan create course melalui HTTP POST` |
| 7 | `Tambahkan update course melalui HTTP PUT atau PATCH` |
| 8 | `Tambahkan hapus course melalui HTTP DELETE dan konfirmasi dialog` |
| 9 | `Refactor REST access menggunakan repository pattern` |
| 10 | `Konfigurasikan Supabase client untuk backend database` |
| 11 | `Dokumentasikan schema database Supabase` |
| 12 | `Baca data courses dari Supabase database` |
| 13 | `Tambahkan insert course ke Supabase` |
| 14 | `Tambahkan update course di Supabase` |
| 15 | `Tambahkan delete course di Supabase` |
| 16 | `Selesaikan Course Data Manager CRUD terintegrasi` |
| 17 | `Tambahkan error handling dan security hardening dasar` |
| 18 | `Finalisasi README dan bukti pengumpulan pertemuan 7` |
