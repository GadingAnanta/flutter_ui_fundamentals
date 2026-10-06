import 'package:flutter/material.dart';
import 'services.dart';

const String studentName = 'Agus Adrian Satria Ananta';
const String studentId = '2415051066';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DebugLabPage(),
    );
  }
}

// Reusable widget 1: kartu profil 
class ProfileCard extends StatelessWidget {
  final String name;
  final String nim;
  final String major;
  final int semester;

  const ProfileCard({
    super.key,
    required this.name,
    required this.nim,
    required this.major,
    required this.semester,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 32,
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(nim),
                  const SizedBox(height: 4),
                  Text('$major - Semester $semester'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  Reusable widget 2: kartu ringkasan 
class SummaryCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Dashboard')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          final student = data['student'] as Map<String, dynamic>;
          final courses = data['courses'] as List<dynamic>;

          int totalCredits = 0;
          for (final c in courses) {
            totalCredits += (c as Map<String, dynamic>)['credits'] as int;
          }

          return Column(
            children: [
              ProfileCard(
                name: student['name'] as String,
                nim: student['nim'] as String,
                major: student['major'] as String,
                semester: student['semester'] as int,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    SummaryCard(
                      value: '${courses.length}',
                      label: 'Mata Kuliah',
                      icon: Icons.school,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    SummaryCard(
                      value: '$totalCredits',
                      label: 'Total SKS',
                      icon: Icons.credit_score,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
             
              Expanded(
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index] as Map<String, dynamic>;
                    final bool done = course['status'] == 'done';
                    final bool active = course['status'] == 'active';

                    final IconData icon = done
                        ? Icons.check_circle
                        : active
                            ? Icons.play_circle
                            : Icons.schedule;
                    final Color color = done
                        ? Colors.green
                        : active
                            ? Colors.blue
                            : Colors.orange;
                    final String label = done
                        ? 'Selesai'
                        : active
                            ? 'Aktif'
                            : 'Direncanakan';

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        leading: Icon(icon, color: color),
                        title: Text(course['title'] as String),
                        subtitle: Text(
                          '${course['code']} - ${course['credits']} SKS',
                        ),
                        trailing: Text(
                          label,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
// ================= TAHAP 1: Layout Tidak Responsif =================

class Tahap1Page extends StatelessWidget {
  const Tahap1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 1 - Layout Tidak Responsif')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$studentId - $studentName'),
            const SizedBox(height: 16),

            // A. Ukuran hard-coded, 
            const Text('A. Width tetap (hard-coded)'),
            const SizedBox(height: 8),
            Row(
              // Row memberi lebar tak terbatas ke child tanpa Expanded,
              // sehingga width 500 benar-benar dipaksakan dan overflow terlihat.
              children: [
                Container(
                  width: 500,
                  padding: const EdgeInsets.all(16),
                  color: Colors.orange.shade100,
                  child: Text('$studentId - $studentName'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // B. Ukuran menyesuaikan ruang yang tersedia.
            const Text('B. Lebar menyesuaikan ruang (Expanded)'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.green.shade100,
                    child: Text('$studentId - $studentName'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// ================= TAHAP 2: MediaQuery =================

class Tahap2Page extends StatelessWidget {
  const Tahap2Page({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca karakteristik layar yang tersedia pada context.
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    // Kondisi sederhana sesuai worksheet: width < 600 Compact, selain itu Wide.
    final String label = size.width < 600 ? 'Compact' : 'Wide';

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 2 - MediaQuery')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$studentId - $studentName'),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Width: ${size.width.toStringAsFixed(0)}'),
                    Text('Height: ${size.height.toStringAsFixed(0)}'),
                    Text('Orientation: $orientation'),
                    Text('Kategori: $label'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ================= TAHAP 3: LayoutBuilder dan Breakpoint =================

class Tahap3Page extends StatelessWidget {
  const Tahap3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 3 - LayoutBuilder & Breakpoint')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return const CompactLayout();
            } else if (constraints.maxWidth < 840) {
              return const MediumLayout();
            } else {
              return const ExpandedLayout();
            }
          },
        ),
      ),
    );
  }
}

// Widget bantu yang dipakai oleh ketiga layout.
class LayoutCard extends StatelessWidget {
  final String kategori;
  final String visual;

  const LayoutCard({super.key, required this.kategori, required this.visual});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kategori: $kategori',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(visual),
          ],
        ),
      ),
    );
  }
}

// Compact: satu kartu, isi menumpuk ke bawah.
class CompactLayout extends StatelessWidget {
  const CompactLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$studentId - $studentName'),
        const SizedBox(height: 12),
        const LayoutCard(
          kategori: 'Compact (< 600)',
          visual: 'Satu kartu, isi ditumpuk vertikal.',
        ),
      ],
    );
  }
}

// Medium: dua kartu berjajar.
class MediumLayout extends StatelessWidget {
  const MediumLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$studentId - $studentName'),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(
              child: LayoutCard(
                kategori: 'Medium (600-839)',
                visual: 'Dua kartu berjajar, ruang dibagi dua.',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: LayoutCard(
                kategori: 'Medium (600-839)',
                visual: 'Ruang lebar dipakai maximum.',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Expanded: tiga kartu berjajar.
class ExpandedLayout extends StatelessWidget {
  const ExpandedLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$studentId - $studentName'),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(
              child: LayoutCard(
                kategori: 'Expanded (>= 840)',
                visual: 'Tiga kartu berjajar.',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: LayoutCard(
                kategori: 'Expanded (>= 840)',
                visual: 'Ruang dibagi tiga sama besar.',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: LayoutCard(
                kategori: 'Expanded (>= 840)',
                visual: 'Ideal untuk tablet dan desktop.',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
// ================= TAHAP 4: Expanded, Flexible, dan Wrap =================

/// Panel bantu untuk Tahap 4 (reusable).
Widget buildPanel(String judul, String isi, Color warna) {
  return Container(
    padding: const EdgeInsets.all(12),
    color: warna.withValues(alpha: 0.15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(judul, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(isi),
      ],
    ),
  );
}

class Tahap4Page extends StatelessWidget {
  const Tahap4Page({super.key});

  @override
  Widget build(BuildContext context) {
    // Enam skill (ditambah satu) untuk Chip pada Wrap.
    final List<String> skills = [
      'Flutter',
      'Dart',
      'Responsive UI',
      'Navigation',
      'State Management',
      'JSON',
      'Git',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 4 - Expanded, Flexible, Wrap')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$studentId - $studentName'),
            const SizedBox(height: 16),

            // A. Expanded dengan flex 2:1
            const Text('A. Expanded(flex: 2) dan Expanded(flex: 1)'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: buildPanel(
                      'Panel A', 'flex: 2 (dua pertiga ruang)', Colors.blue),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: buildPanel(
                      'Panel B', 'flex: 1 (satu pertiga ruang)', Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // B. Flexible
            const Text('B. Flexible (longgar) dibandingkan Expanded (penuh)'),
            const SizedBox(height: 8),
            Row(
              children: [
                Flexible(
                  child: buildPanel(
                      'Flexible', 'Boleh menyusut sesuai isinya',
                      Colors.orange),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: buildPanel(
                      'Expanded', 'Selalu mengisi sisa ruang', Colors.purple),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // C. Wrap
            const Text('C. Wrap (chip otomatis pindah baris)'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((e) => Chip(label: Text(e))).toList(),
            ),
            const SizedBox(height: 24),

            // D. Row biasa sebagai pembanding.
            const Text('D. Row biasa (pembanding)'),
            const SizedBox(height: 4),
            const Text(
                'Pada layar sempit baris di bawah ini overflow karena tidak ada Expanded atau Wrap.'),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final s in skills)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(8),
                    color: Colors.red.shade100,
                    child: Text(s),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// ================= TAHAP 5: GridView Responsif =================

/// Jumlah kolom grid berdasarkan lebar yang tersedia.
int columnsFor(double width) {
  if (width < 600) return 1;
  if (width < 840) return 2;
  return 3;
}

/// Kartu course untuk GridView (reusable).
class CourseGridCard extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseGridCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final String status = course['status'] as String;
    final Color color = status == 'done'
        ? Colors.green
        : status == 'active'
            ? Colors.blue
            : Colors.orange;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  course['code'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${course['credits']} SKS',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                course['title'] as String,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              status,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class Tahap5Page extends StatefulWidget {
  const Tahap5Page({super.key});

  @override
  State<Tahap5Page> createState() => _Tahap5PageState();
}

class _Tahap5PageState extends State<Tahap5Page> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 5 - GridView Responsif')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          final student = data['student'] as Map<String, dynamic>;
          final courses = data['courses'] as List<dynamic>;

          return Column(
            children: [
              // Header: Nama dan NIM selalu terlihat.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.blue.shade50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${student['name']} - ${student['nim']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Course Explorer - ${courses.length} mata kuliah'),
                  ],
                ),
              ),

              // Grid responsif: jumlah kolom mengikuti lebar yang tersedia.
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columnsFor(constraints.maxWidth),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.8,
                      ),
                      itemCount: courses.length,
                      itemBuilder: (context, index) => CourseGridCard(
                        course: courses[index] as Map<String, dynamic>,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
// ================= TAHAP 6: Scrollable Content dan Keyboard =================

class Tahap6Page extends StatelessWidget {
  const Tahap6Page({super.key});

  /// Konten yang sengaja dibuat lebih tinggi dari area yang tersedia.
  List<Widget> isiKonten() {
    return [
      for (int i = 1; i <= 6; i++)
        Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(child: Text('$i')),
            title: Text('Kartu profil $i'),
            subtitle: const Text('Bagian dari konten yang panjang'),
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 6 - Scrollable Content')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('$studentId - $studentName'),
            const SizedBox(height: 16),

            // A. Tanpa scroll: kolom dipaksa masuk area 420px.
            const Text('A. Tanpa scroll (area dibatasi 420 px)'),
            const SizedBox(height: 8),
            SizedBox(
              height: 420,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: isiKonten(),
              ),
            ),
            const SizedBox(height: 24),

            // B. Dengan SingleChildScrollView: konten boleh melebihi area.
            const Text('B. Dengan SingleChildScrollView (area 420 px)'),
            const SizedBox(height: 8),
            SizedBox(
              height: 420,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: isiKonten(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // C. Uji keyboard: kolom isian berada di bawah lipatan layar.
            const Text('C. Uji keyboard'),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nama lengkap',
                helperText: 'Fokus kolom ini untuk membuka keyboard',
              ),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Feedback',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Saat keyboard terbuka, area konten tetap dapat di-scroll.'),
          ],
        ),
      ),
    );
  }
}
// ================= TAHAP 7: Navigator.push() dan Navigator.pop() =================

class Tahap7Page extends StatelessWidget {
  const Tahap7Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 7 - Navigator push/pop')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$studentId - $studentName',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // push: menambahkan DetailPage di atas HomePage.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DetailPage()),
                  );
                },
                child: const Text('Buka Detail'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Page')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline, size: 48),
              const SizedBox(height: 16),
              Text(
                '$studentId - $studentName',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text('Ini screen kedua hasil Navigator.push()'),
              const SizedBox(height: 24),
              ElevatedButton(
                // pop: menghapus screen teratas, kembali ke HomePage.
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ================= TAHAP 8: Passing Data dari List ke Detail Page =================

class Tahap8Page extends StatefulWidget {
  const Tahap8Page({super.key});

  @override
  State<Tahap8Page> createState() => _Tahap8PageState();
}

class _Tahap8PageState extends State<Tahap8Page> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  void _bukaDetail(BuildContext context, Map<String, dynamic> course) {
    // Data course dikirim melalui constructor CourseDetailPage.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourseDetailPage(course: course),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 8 - Passing Data')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          final student = data['student'] as Map<String, dynamic>;
          final courses = data['courses'] as List<dynamic>;

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Text(
                '${student['name']} - ${student['nim']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              for (final c in courses)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.book),
                    title: Text((c as Map<String, dynamic>)['title'] as String),
                    subtitle: Text(
                      '${c['code']} - ${c['credits']} SKS',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    // Setiap ListTile dapat ditekan.
                    onTap: () => _bukaDetail(context, c),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Detail page menerima data course melalui constructor.
class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final String status = course['status'] as String;

    return Scaffold(
      appBar: AppBar(title: Text(course['code'] as String)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course['title'] as String,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Kode: ${course['code']}'),
            Text('SKS: ${course['credits']}'),
            Text('Status: $status'),
            const Divider(height: 32),
            Text(
              '$studentId - $studentName',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
// ================= TAHAP 9: Returning Data dari Screen =================

/// Halaman konfirmasi. Mengirim nilai balik ke halaman sebelumnya.
class ConfirmPage extends StatelessWidget {
  final String title;

  const ConfirmPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konfirmasi')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Jadikan "$title" sebagai favorite?',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text('$studentId - $studentName'),
            const SizedBox(height: 24),
            // pop dengan nilai true.
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Ya, Favorit'),
            ),
            const SizedBox(height: 8),
            // pop dengan nilai false.
            OutlinedButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Halaman detail yang punya tombol Favorite.
class CourseDetailFavPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailFavPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course['code'] as String)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              course['title'] as String,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('SKS: ${course['credits']} - Status: ${course['status']}'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.star),
              label: const Text('Pilih Favorite'),
              onPressed: () async {
                // push di-await untuk menerima nilai dari ConfirmPage.
                final bool? disetujui = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConfirmPage(title: course['title'] as String),
                  ),
                );
                if (!context.mounted) return;
                // Kembali ke halaman list sambil mengirim nilai.
                Navigator.pop(context, disetujui == true);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Tahap9Page extends StatefulWidget {
  const Tahap9Page({super.key});

  @override
  State<Tahap9Page> createState() => _Tahap9PageState();
}

class _Tahap9PageState extends State<Tahap9Page> {
  late Future<Map<String, dynamic>> studentFuture;
  final List<String> favorit = [];

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  Future<void> _bukaDetail(Map<String, dynamic> course) async {
    // Menunggu nilai balik dari CourseDetailFavPage.
    final bool? jadiFavorit = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CourseDetailFavPage(course: course)),
    );

    if (!mounted || jadiFavorit != true) return;
    setState(() => favorit.add(course['code'] as String));

    // SnackBar muncul jika result == true.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${course['code']} masuk favorite. Total: ${favorit.length}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 9 - Returning Data')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          final courses = data['courses'] as List<dynamic>;

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Text(
                '$studentId - $studentName',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text('Favorite: ${favorit.isEmpty ? 'belum ada' : favorit.join(', ')}'),
              const Divider(),
              for (final c in courses)
                Card(
                  child: ListTile(
                    leading: Icon(
                      favorit.contains((c as Map<String, dynamic>)['code'])
                          ? Icons.star
                          : Icons.book,
                    ),
                    title: Text(c['title'] as String),
                    subtitle: Text('${c['code']} - ${c['credits']} SKS'),
                    onTap: () => _bukaDetail(c),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
// ============ TAHAP 10 & 11: NavigationBar dan NavigationRail adaptif ============

class HomeTabPage extends StatelessWidget {
  const HomeTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '$studentId - $studentName',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            subtitle: Text('Halaman utama navigasi'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.school),
            title: Text('Course Explorer'),
            subtitle: Text('5 mata kuliah semester 5'),
          ),
        ),
      ],
    );
  }
}

class CoursesTabPage extends StatelessWidget {
  const CoursesTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    const List<String> courses = [
      'MOB01 - Git & GitHub',
      'MOB02 - Dart Fundamentals',
      'MOB03 - Flutter UI Fundamentals',
      'MOB04 - Navigation',
      'MOB05 - State Management',
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '$studentId - $studentName',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        for (final c in courses)
          Card(child: ListTile(leading: const Icon(Icons.book), title: Text(c))),
      ],
    );
  }
}

class ProfileTabPage extends StatelessWidget {
  const ProfileTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assets/images/profile.jpg'),
        ),
        const SizedBox(height: 16),
        Text(
          studentName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(studentId),
        const Text('Pendidikan Teknologi Informasi - Semester 5'),
      ],
    );
  }
}

/// Shell navigasi utama. Tahap 10 memakai NavigationBar,
/// Tahap 11 menambah NavigationRail untuk layar lebar.
class AdaptiveShell extends StatefulWidget {
  const AdaptiveShell({super.key});

  @override
  State<AdaptiveShell> createState() => _AdaptiveShellState();
}

class _AdaptiveShellState extends State<AdaptiveShell> {
  // selectedIndex disimpan di state agar tetap sama saat layout berubah.
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomeTabPage(),
    CoursesTabPage(),
    ProfileTabPage(),
  ];

  void _pilih(int index) {
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Expanded: NavigationRail. Compact/Medium: NavigationBar.
        final bool useRail = constraints.maxWidth >= 840;

        final Widget konten = pages[selectedIndex];

        if (useRail) {
          return Scaffold(
            appBar: AppBar(title: const Text('Course Explorer')),
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: _pilih,
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.school),
                      label: Text('Courses'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person),
                      label: Text('Profile'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: konten),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Course Explorer')),
          body: konten,
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: _pilih,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.school),
                label: 'Courses',
              ),
              NavigationDestination(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
// ============ TAHAP 12, 13, 14: Interaksi, Form Validasi, dan Feedback ============

class CourseFavCard extends StatefulWidget {
  final Map<String, dynamic> course;

  const CourseFavCard({super.key, required this.course});

  @override
  State<CourseFavCard> createState() => _CourseFavCardState();
}

class _CourseFavCardState extends State<CourseFavCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      // InkWell: efek ripple untuk elemen Material.
      child: InkWell(
        onTap: () => setState(() => isFavorite = !isFavorite),
        // GestureDetector: long press menampilkan informasi.
        onLongPress: () => showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(widget.course['code'] as String),
            content: Text(
              '${widget.course['title']}\n'
              'SKS: ${widget.course['credits']}\n'
              '$studentId - $studentName',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.book),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.course['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${widget.course['code']} - ${widget.course['credits']} SKS'),
                  ],
                ),
              ),
              // Tombol eksplisit untuk favorite.
              IconButton(
                onPressed: () => setState(() => isFavorite = !isFavorite),
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.amber : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FormFeedbackPage extends StatefulWidget {
  const FormFeedbackPage({super.key});

  @override
  State<FormFeedbackPage> createState() => _FormFeedbackPageState();
}

class _FormFeedbackPageState extends State<FormFeedbackPage> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController namaController =
      TextEditingController(text: studentName);
  final TextEditingController nimController =
      TextEditingController(text: studentId);
  final TextEditingController komentarController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    namaController.dispose();
    nimController.dispose();
    komentarController.dispose();
    super.dispose();
  }

  void _kirim() {
    // Validasi form sebelum menampilkan hasil.
    if (!(formKey.currentState?.validate() ?? false)) return;

    // Dialog konfirmasi sebelum aksi penting.
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text('Kirim feedback dari ${nimController.text}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _prosesKirim();
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  Future<void> _prosesKirim() async {
    setState(() => loading = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => loading = false);

    // SnackBar setelah form valid.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Feedback dari ${namaController.text} (${nimController.text}) '
          'berhasil dikirim',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '$studentId - $studentName',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: namaController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nama',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: nimController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'NIM',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'NIM wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: komentarController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Komentar',
              ),
              validator: (value) {
                if (value == null || value.trim().length < 5) {
                  return 'Komentar minimal 5 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Loading feedback.
            if (loading) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ),
              ),
              const SizedBox(height: 8),
            ],

            ElevatedButton(
              onPressed: loading ? null : _kirim,
              child: Text(loading ? 'Mengirim...' : 'Kirim Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shell yang menggabungkan semua interaksi (Tahap 12, 13, 14).
class InteractionShell extends StatefulWidget {
  const InteractionShell({super.key});

  @override
  State<InteractionShell> createState() => _InteractionShellState();
}

class _InteractionShellState extends State<InteractionShell> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _CourseListSection(),
      const FormFeedbackPage(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Tahap 12-14 Interaksi')),
      body: pages[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (i) => setState(() => selectedIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.book), label: 'Course'),
          NavigationDestination(icon: Icon(Icons.edit), label: 'Feedback'),
        ],
      ),
    );
  }
}

class _CourseListSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> courses = [
      {'code': 'MOB01', 'title': 'Git & GitHub', 'credits': 2},
      {'code': 'MOB02', 'title': 'Dart Fundamentals', 'credits': 2},
      {'code': 'MOB03', 'title': 'Flutter UI Fundamentals', 'credits': 3},
      {'code': 'MOB04', 'title': 'Navigation', 'credits': 2},
      {'code': 'MOB05', 'title': 'State Management', 'credits': 3},
    ];

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(
          '$studentId - $studentName',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Tap kartu untuk favorite, long press untuk informasi.'),
        const SizedBox(height: 12),
        for (final c in courses) CourseFavCard(course: c),
      ],
    );
  }
}
//  TAHAP 15 


// ---------- HELPER STATUS ----------

String exStatus(String? status) {
  switch (status) {
    case 'done':
      return 'Selesai';
    case 'active':
      return 'Sedang Dipelajari';
    default:
      return 'Direncanakan';
  }
}

Color exStatusColor(String? status) {
  switch (status) {
    case 'done':
      return Colors.green;
    case 'active':
      return Colors.orange;
    default:
      return Colors.blueGrey;
  }
}

// ---------- REUSABLE WIDGET 1: KARTU STATISTIK (HomePage) ----------

class ExStatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const ExStatTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: Theme.of(context).textTheme.titleLarge),
                  Text(label, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- REUSABLE WIDGET 2: KARTU COURSE (CoursesPage) ----------

class ExCourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const ExCourseCard({
    super.key,
    required this.course,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final String code = course['code'] as String;
    final String status = course['status'] as String? ?? 'planned';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 18, child: Text(code.substring(0, 3))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['title'] as String,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('$code - ${course['credits']} SKS'),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Favorit',
                    onPressed: onToggleFavorite,
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color: isFavorite ? Colors.amber : Colors.grey,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.circle, size: 10, color: exStatusColor(status)),
                  const SizedBox(width: 6),
                  Text(exStatus(status)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- REUSABLE WIDGET 3: BARIS INFO (CourseDetailPage) ----------

class ExInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ExInfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

// ---------- REUSABLE WIDGET 4: BARIS IDENTITAS (HomePage/ProfilePage) ----------

class ExIdentityBar extends StatelessWidget {
  const ExIdentityBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.badge_outlined),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$studentName - $studentId',
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ---------- HOME PAGE ----------

class ExHomePage extends StatelessWidget {
  final int totalCourse;
  final int totalSks;
  final int totalFavorite;

  const ExHomePage({
    super.key,
    required this.totalCourse,
    required this.totalSks,
    required this.totalFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Course Explorer',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const ExIdentityBar(),
        const SizedBox(height: 16),

        // Wrap supaya kartu statistik pindah baris di layar sempit.
        LayoutBuilder(
          builder: (context, constraints) {
            final double lebar = constraints.maxWidth < 600 ? 400 : 220;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: lebar,
                  child: ExStatTile(
                    label: 'Course terdaftar',
                    value: '$totalCourse',
                    icon: Icons.school,
                  ),
                ),
                SizedBox(
                  width: lebar,
                  child: ExStatTile(
                    label: 'Total SKS',
                    value: '$totalSks',
                    icon: Icons.timeline,
                  ),
                ),
                SizedBox(
                  width: lebar,
                  child: ExStatTile(
                    label: 'Course favorit',
                    value: '$totalFavorite',
                    icon: Icons.star,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tentang aplikasi',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                const Text(
                  'Course Explorer menampilkan daftar course beserta SKS dan status. '
                  'Data course dibaca dari assets/data/student_data.json.',
                ),
                const SizedBox(height: 12),
                const Text('1. Tab Courses untuk melihat daftar course responsif.'),
                const Text('2. Tekan kartu untuk membuka halaman detail.'),
                const Text('3. Tekan ikon bintang untuk menandai favorit.'),
                const Text('4. Tab Profile untuk mengisi form feedback.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ---------- COURSES PAGE (list pada compact, grid pada medium/expanded) ----------

class ExCoursesPage extends StatefulWidget {
  final Set<String> favorites;
  final ValueChanged<String> onToggleFavorite;
  final ValueChanged<Map<String, dynamic>> onOpen;

  const ExCoursesPage({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
    required this.onOpen,
  });

  @override
  State<ExCoursesPage> createState() => _ExCoursesPageState();
}

class _ExCoursesPageState extends State<ExCoursesPage> {
  // Future disimpan di State agar tidak dibuat ulang setiap build.
  late final Future<Map<String, dynamic>> dataFuture = loadStudentData();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
        }

        final Map<String, dynamic> data = snapshot.data ?? const {};
        final List<Map<String, dynamic>> courses =
            (data['courses'] as List<dynamic>? ?? const [])
                .cast<Map<String, dynamic>>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  const Expanded(child: ExIdentityBar()),
                  const SizedBox(width: 12),
                  Text('${courses.length} course'),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Breakpoint worksheet: compact list 1 kolom,
                  // medium 2 kolom, expanded 3 kolom.
                  final bool compact = constraints.maxWidth < 600;
                  final int kolom =
                      constraints.maxWidth >= 840 ? 3 : (compact ? 1 : 2);

                  if (compact) {
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic> course = courses[index];
                        final String code = course['code'] as String;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                            height: 120,
                            child: ExCourseCard(
                              course: course,
                              isFavorite: widget.favorites.contains(code),
                              onTap: () => widget.onOpen(course),
                              onToggleFavorite: () =>
                                  widget.onToggleFavorite(code),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: kolom,
                      mainAxisExtent: 140,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> course = courses[index];
                      final String code = course['code'] as String;
                      return ExCourseCard(
                        course: course,
                        isFavorite: widget.favorites.contains(code),
                        onTap: () => widget.onOpen(course),
                        onToggleFavorite: () => widget.onToggleFavorite(code),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------- COURSE DETAIL PAGE (data lewat constructor) ----------

class ExCourseDetailPage extends StatefulWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;

  const ExCourseDetailPage({
    super.key,
    required this.course,
    required this.isFavorite,
  });

  @override
  State<ExCourseDetailPage> createState() => _ExCourseDetailPageState();
}

class _ExCourseDetailPageState extends State<ExCourseDetailPage> {
  late bool isFavorite = widget.isFavorite;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> c = widget.course;
    final String status = c['status'] as String? ?? 'planned';

    return Scaffold(
      appBar: AppBar(
        title: Text(c['code'] as String),
        actions: [
          IconButton(
            tooltip: 'Favorit',
            onPressed: () => setState(() => isFavorite = !isFavorite),
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.amber : Colors.grey,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              c['title'] as String,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const ExIdentityBar(),
            const Divider(height: 32),
            ExInfoRow(label: 'Kode', value: c['code'] as String),
            ExInfoRow(label: 'SKS', value: '${c['credits']} SKS'),
            ExInfoRow(label: 'Status', value: exStatus(status)),
            ExInfoRow(label: 'Favorit', value: isFavorite ? 'Ya' : 'Belum'),
            const SizedBox(height: 8),
            const Divider(height: 32),
            Text('Deskripsi',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text(
              'Materi ini membahas konsep dasar sampai penerapan lanjutan. '
              'Silakan buka materi dari LMS dan kerjakan latihan yang tersedia.',
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context, isFavorite),
              icon: const Icon(Icons.save),
              label: const Text('Simpan dan Kembali'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.pop(context, isFavorite),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- FEEDBACK FORM (dengan validasi, loading, SnackBar) ----------

class ExFeedbackForm extends StatefulWidget {
  const ExFeedbackForm({super.key});

  @override
  State<ExFeedbackForm> createState() => _ExFeedbackFormState();
}

class _ExFeedbackFormState extends State<ExFeedbackForm> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController namaController =
      TextEditingController(text: studentName);
  final TextEditingController nimController =
      TextEditingController(text: studentId);
  final TextEditingController komentarController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    namaController.dispose();
    nimController.dispose();
    komentarController.dispose();
    super.dispose();
  }

  Future<void> _kirim() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    setState(() => loading = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Feedback dari ${namaController.text} (${nimController.text}) berhasil dikirim'),
      ),
    );
    formKey.currentState?.reset();
    komentarController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: namaController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nama',
            ),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Nama wajib diisi'
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: nimController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'NIM',
            ),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'NIM wajib diisi'
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: komentarController,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Komentar (minimal 5 karakter)',
            ),
            validator: (value) => (value == null || value.trim().length < 5)
                ? 'Komentar minimal 5 karakter'
                : null,
          ),
          const SizedBox(height: 16),
          if (loading) ...[
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 8),
          ],
          ElevatedButton(
            onPressed: loading ? null : _kirim,
            child: Text(loading ? 'Mengirim...' : 'Kirim Feedback'),
          ),
        ],
      ),
    );
  }
}

// ---------- PROFILE PAGE ----------

class ExProfilePage extends StatelessWidget {
  const ExProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                    radius: 28, child: Icon(Icons.person, size: 30)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(studentName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(studentId),
                      const Text('Pendidikan Teknologi Informatika'),
                      const Text('Semester 5'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Form Feedback', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        const ExFeedbackForm(),
      ],
    );
  }
}

// ---------- RESPONSIVE SHELL ----------

class ExResponsiveShell extends StatefulWidget {
  const ExResponsiveShell({super.key});

  @override
  State<ExResponsiveShell> createState() => _ExResponsiveShellState();
}

class _ExResponsiveShellState extends State<ExResponsiveShell> {
  int selectedIndex = 0;
  final Set<String> favorites = <String>{};

  void _toggleFavorite(String code) {
    final bool liked = favorites.contains(code);
    setState(() {
      liked ? favorites.remove(code) : favorites.add(code);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            liked ? '$code dihapus dari favorit' : '$code masuk ke favorit'),
      ),
    );
  }

  Future<void> _openDetail(Map<String, dynamic> course) async {
    final String code = course['code'] as String;

    // Data course dikirim ke detail page melalui constructor.
    final bool? hasil = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ExCourseDetailPage(
          course: course,
          isFavorite: favorites.contains(code),
        ),
      ),
    );

    if (!mounted || hasil == null) return;

    if (hasil != favorites.contains(code)) {
      setState(() {
        hasil ? favorites.add(code) : favorites.remove(code);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Favorit $code diperbarui dari halaman detail')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalSks = 12;

    final pages = <Widget>[
      ExHomePage(
        totalCourse: 5,
        totalSks: totalSks,
        totalFavorite: favorites.length,
      ),
      ExCoursesPage(
        favorites: favorites,
        onToggleFavorite: _toggleFavorite,
        onOpen: _openDetail,
      ),
      const ExProfilePage(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint: expanded memakai NavigationRail.
        final bool wide = constraints.maxWidth >= 840;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Course Explorer'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(child: Text(studentId)),
              ),
            ],
          ),
          body: wide
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: selectedIndex,
                      onDestinationSelected: (i) =>
                          setState(() => selectedIndex = i),
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.home),
                          label: Text('Home'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.school),
                          label: Text('Courses'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.person),
                          label: Text('Profile'),
                        ),
                      ],
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: pages[selectedIndex]),
                  ],
                )
              : pages[selectedIndex],
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (i) => setState(() => selectedIndex = i),
                  destinations: const [
                    NavigationDestination(
                        icon: Icon(Icons.home), label: 'Home'),
                    NavigationDestination(
                        icon: Icon(Icons.school), label: 'Courses'),
                    NavigationDestination(
                        icon: Icon(Icons.person), label: 'Profile'),
                  ],
                ),
        );
      },
    );
  }
}
// TAHAP 16: DEBUGGING CHALLENGE 
 
// KASUS A - RenderFlex overflow pada Row dengan teks panjang


/// Versi salah: Row tanpa batas lentur. Teks panjang memicu overflow
/// pada layar sempit karena Row memberikan lebar keras ke child.
class DbgRowSalah extends StatelessWidget {
  const DbgRowSalah({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.info),
        const SizedBox(width: 8),
        Text('$studentId - $studentName - materi responsive flutter adaptive layout'),
      ],
    );
  }
}

/// Versi benar: Flexible memberi teks sisa ruang dan ellipsis
/// mencegah teks meluber melewati batas Row.
class DbgRowBenar extends StatelessWidget {
  const DbgRowBenar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.info),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$studentId - $studentName - materi responsive flutter adaptive layout',
          ),
        ),
      ],
    );
  }
}

/// Alternatif lain: Wrap membuat teks turun ke baris berikutnya.
class DbgRowWrap extends StatelessWidget {
  const DbgRowWrap({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      children: [
        const Icon(Icons.info),
        Text('$studentId - $studentName - materi responsive flutter adaptive layout'),
      ],
    );
  }
}

// ---------------------------------------------------------------
// KASUS B - Vertical viewport was given unbounded height
// ---------------------------------------------------------------

/// Versi salah: ListView langsung di dalam Column tanpa Expanded.
/// Column memberi tinggi tak terbatas, sedangkan ListView menolak
/// tinggi tak terbatas -> error unbounded height.
class DbgListSalah extends StatelessWidget {
  const DbgListSalah({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Kasus B - ListView di dalam Column'),
        ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => ListTile(
            dense: true,
            leading: const Icon(Icons.list),
            title: Text('Item $index - $studentId'),
          ),
        ),
      ],
    );
  }
}

/// Versi benar: bungkus ListView dengan Expanded agar
/// tinggi viewport-nya bounded oleh Column.
class DbgListBenar extends StatelessWidget {
  const DbgListBenar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Kasus B - ListView di dalam Column'),
        Expanded(
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => ListTile(
              dense: true,
              leading: const Icon(Icons.list),
              title: Text('Item $index - $studentId'),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------
// KASUS C - Keyboard overflow
// ---------------------------------------------------------------

/// Versi benar: SingleChildScrollView membuat konten dapat digulir,
/// dan Scaffold otomatis memakai resizeToAvoidBottomInset sehingga
/// area konten menyusut saat keyboard muncul. Field paling bawah
/// tetap dapat diakses dengan menggulir.
class DbgFormKeyboard extends StatelessWidget {
  const DbgFormKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Kasus C - form di dekat bawah layar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 200),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Catatan',
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ulasan',
            ),
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Saran',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Komentar terkirim')),
              );
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// KASUS D - Navigasi ganda
// ---------------------------------------------------------------

/// Tombol tekan berulang menumpuk route. Flag [dibuka] mencegah
/// aksi kedua sampai push pertama selesai.
class DbgTombolGanda extends StatefulWidget {
  const DbgTombolGanda({super.key});

  @override
  State<DbgTombolGanda> createState() => _DbgTombolGandaState();
}

class _DbgTombolGandaState extends State<DbgTombolGanda> {
  bool dibuka = false;

  Future<void> _bukaDetail() async {
    // Guard: aksi kedua diabaikan selama proses masih berjalan.
    if (dibuka) return;
    setState(() => dibuka = true);

    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Detail Course')),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info, size: 40),
                const SizedBox(height: 12),
                Text('$studentId - $studentName'),
                const SizedBox(height: 8),
                const Text('Route ini hanya bisa dibuka satu kali.'),
              ],
            ),
          ),
        ),
      ),
    );

    // Jangan panggil setState setelah widget sudah dilepas.
    if (!mounted) return;
    setState(() => dibuka = false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            dibuka
                ? 'Sedang membuka detail...'
                : 'Tekan tombol beberapa kali dengan cepat',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text('$studentId - $studentName'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            // Tombol dinonaktifkan selama proses push berjalan.
            onPressed: dibuka ? null : _bukaDetail,
            icon: const Icon(Icons.open_in_new),
            label: Text(dibuka ? 'Membuka...' : 'Buka Detail'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------
// HALAMAN LABORATORIUM
// ---------------------------------------------------------------

class DebugLabPage extends StatefulWidget {
  const DebugLabPage({super.key});

  @override
  State<DebugLabPage> createState() => _DebugLabPageState();
}

class _DebugLabPageState extends State<DebugLabPage> {
  int kasus = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 16 Debugging Lab'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(92),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < 4; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text('Kasus ${String.fromCharCode(65 + i)}'),
                        selected: kasus == i,
                        onSelected: (_) => setState(() => kasus = i),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: switch (kasus) {
        // Kasus A: Row dengan teks panjang
        0 => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Kasus A - RenderFlex overflow pada Row',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text('$studentId - $studentName',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              const Text('Error yang muncul:'),
              const Text('A RenderFlex overflowed by 120 pixels on the right.'),
              const SizedBox(height: 16),

              const Text('1) Versi salah (Row biasa, tanpa Flexible):'),
              const SizedBox(height: 8),
              const DbgRowSalah(),
              const SizedBox(height: 16),

              const Text('2) Diperbaiki dengan Expanded:'),
              const SizedBox(height: 8),
              const DbgRowBenar(),
              const SizedBox(height: 16),

              const Text('3) Alternatif lain dengan Wrap:'),
              const SizedBox(height: 8),
              const DbgRowWrap(),
              const SizedBox(height: 16),

              const Text('Kenapa Flexible bekerja:'),
              const Text(
                'Row membagi lebar untuk child non-lentur terlebih dahulu '
                '(Icon 24 + SizedBox 8), lalu sisa lebar diberikan kepada '
                'Expanded atau Flexible. Karena Text willingly menerima '
                'lebar yang lebih kecil dari kebutuhan alaminya, tidak ada '
                'child yang melewati batas dan overflow tidak terjadi.',
              ),
              const SizedBox(height: 12),
              const Text('Perbedaan Expanded dan Flexible:'),
              const Text(
                'keduanya sama-sama memberi ruang tersisa, tetapi Expanded '
                'meminta ruang sebesar mungkin (flex: 1) sedangkan Flexible '
                'hanya mengambil ukuran wajar anak lalu maksimal sebesar '
                'ruang tersisa (FlexFit.loose).',
              ),
            ],
          ),

        // Kasus B: unbounded ListView
        1 => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kasus B - Vertical viewport was given unbounded height',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text('$studentId - $studentName',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Error yang muncul:'),
                    const Text(
                      'RenderFlex children have non-zero flex but incoming '
                      'height constraints are unbounded.',
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'ListView adalah scrollable vertikal yang butuh tinggi '
                      'viewport yang sudah ditentukan. Column hanya memberikan '
                      'batas longgar pada tinggi sehingga tinggi ListView '
                      'menjadi tak terbatas dan ditolak.',
                    ),
                    const SizedBox(height: 8),
                    const Text(
                        'Solusi: bungkus dengan Expanded atau SizedBox(height: ...).'),
                  ],
                ),
              ),
              const Expanded(child: DbgListBenar()),
            ],
          ),

        // Kasus C: keyboard overflow
        2 => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.keyboard),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$studentId - $studentName - ketuk field paling bawah, '
                        'lalu scroll ke bawah',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: DbgFormKeyboard()),
            ],
          ),

        // Kasus D: navigasi ganda
        _ => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.warning),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$studentId - $studentName - tekan tombol berkali-kali',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: DbgTombolGanda()),
            ],
          ),
      },
    );
  }
}