# flutter_ui_fundamentals

**Course Explorer v2** — Praktikum Pemrograman Web & Mobile (Pemwob), Pertemuan 6:
State Management & Mobile Application Architecture.

- Nama: Agus Adrian Satria Ananta
- NIM: 2415051066
- Kelas: PTI 5 C

## Dokumentasi REST API Endpoint (Pertemuan 7 - Tahap 1)

Pada tahap awal praktikum REST API, aplikasi menggunakan REST endpoint untuk resource `courses`:

- **Base URL / Endpoint**: `https://jsonplaceholder.typicode.com/posts` (atau endpoint latihan `/courses`)
- **HTTP Method**: `GET`
- **Expected Status Code**: `200 OK`
- **Resource**: `/courses`
- **Representasi JSON Resource (Course)**:
  ```json
  {
    "id": 1,
    "code": "MOB01",
    "title": "Git & GitHub",
    "credits": 2,
    "status": "active"
  }
  ```
- **Field JSON Utama**:
  1. `id` (int): Identifier unik resource.
  2. `code` (String): Kode mata kuliah (contoh: "MOB01").
  3. `title` (String): Judul / nama mata kuliah (contoh: "Git & GitHub").
  4. `credits` (int): Beban SKS mata kuliah (contoh: 2).
  5. `status` (String): Status keikutsertaan course (`planned`, `active`, `done`).

---

## Database Supabase (Pertemuan 7 - Tahap 11)

Skema tabel `courses` pada Supabase (PostgreSQL):

| Kolom | Tipe | Keterangan |
|---|---|---|
| `id` | `bigint` identity | Primary key |
| `code` | `text` | Kode course (mis. `MOB01`), dipakai sebagai kunci favorites |
| `title` | `text` | Judul course |
| `credits` | `int` | Jumlah SKS |
| `status` | `text` | `planned` / `active` / `done` (CHECK constraint) |
| `created_at` | `timestamptz` | Default `now()` |

Script SQL lengkap (tabel + CHECK constraint + 3 data awal + RLS policy):

```
supabase/migrations/0001_create_courses.sql
```

Nama kolom sengaja dibuat sama dengan key pada `Course.fromJson()` / `toJson()`
(`code`, `title`, `credits`, `status`) agar mapping JSON tidak perlu diubah.

**Keamanan.** RLS diaktifkan. Policy yang dipakai bersifat permisif (role `anon`
boleh select/insert/update/delete tanpa autentikasi) dan **hanya untuk
lingkungan laboratorium/praktikum**, bukan pola produksi. Kunci yang dipakai
aplikasi hanya *publishable/anon key*; `service_role` key tidak pernah
disimpan di aplikasi.

---

## Arsitektur & Arah Dependency

```
Screen / Widget  ->  Provider  ->  Repository  ->  Service / Data Source
```

UI (screens/widgets) **tidak pernah** mengakses `rootBundle`/`jsonDecode` secara
langsung. Data course dimuat melalui rantai tersebut.

## Tanggung Jawab Tiap Folder (`lib/`)

| Folder | Tanggung jawab |
|---|---|
| `models/` | Bentuk/struktur data murni (`Course`), termasuk `Course.fromJson`. Tidak tahu UI maupun sumber data. |
| `services/` | Sumber data dan kontraknya: `CourseDataSource` (abstrak) + `CourseApiService` (implementasi REST). Tidak tahu UI. |
| `repositories/` | Abstraksi data untuk Provider. Menerima `CourseDataSource`, menyediakan CRUD (`CourseRepository`). |
| `providers/` | State + business logic (`CourseProvider`): `courses`, `isLoading`, `error`, `favorites`; memanggil repository dan `notifyListeners()`. |
| `screens/` | Halaman aplikasi: `CourseExplorerShell` (shell responsif), daftar course, favorites, detail, profil. |
| `widgets/` | Komponen tampilan reusable tanpa state (`CourseCard`, `IdentityBar`). |

## Catatan

- Provider tidak menyimpan `BuildContext` sebagai state.
- `CourseApiService` hanya mengurus data (tanpa widget/UI).
- File `tahap*_*.dart` di `lib/` adalah artefak demo per tahap (bukti praktikum);
  kode produksi Course Explorer v2 berada di dalam folder `models/`, `services/`,
  `repositories/`, `providers/`, `screens/`, dan `widgets/`.

## Menjalankan

```bash
flutter pub get
flutter run
```
