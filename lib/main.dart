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
      home: Tahap7Page(),
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