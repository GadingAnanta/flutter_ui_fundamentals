# flutter_ui_fundamentals

**Course Explorer v2** — Praktikum Pemrograman Web & Mobile (Pemwob), Pertemuan 6:
State Management & Mobile Application Architecture.

- Nama: Agus Adrian Satria Ananta
- NIM: 2415051066
- Kelas: PTI 5 C

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
| `services/` | Sumber data: membuka `rootBundle`, `jsonDecode`, mengubahnya menjadi `List<Course>` (`CourseService`). Tidak tahu UI. |
| `repositories/` | Abstraksi data untuk Provider. Menerima `CourseService`, menyediakan `getCourses()` (`CourseRepository`). |
| `providers/` | State + business logic (`CourseProvider`): `courses`, `isLoading`, `error`, `favorites`; memanggil repository dan `notifyListeners()`. |
| `screens/` | Halaman aplikasi: `CourseExplorerShell` (shell responsif), daftar course, favorites, detail, profil. |
| `widgets/` | Komponen tampilan reusable tanpa state (`CourseCard`, `IdentityBar`). |

## Catatan

- Provider tidak menyimpan `BuildContext` sebagai state.
- `CourseService` hanya mengurus data (tanpa widget/UI).
- File `tahap*_*.dart` di `lib/` adalah artefak demo per tahap (bukti praktikum);
  kode produksi Course Explorer v2 berada di dalam folder `models/`, `services/`,
  `repositories/`, `providers/`, `screens/`, dan `widgets/`.

## Menjalankan

```bash
flutter pub get
flutter run
```
