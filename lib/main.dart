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
      home: Tahap2Page(),
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