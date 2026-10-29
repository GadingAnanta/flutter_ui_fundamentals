// ============================================================
// Praktikum Pemwob - Pertemuan 7
// Tahap 2: HTTP GET dari Flutter
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'widgets/identity_bar.dart';

const String studentName = 'Agus Adrian Satria Ananta';
const String studentId = '2415051066';

// Konstanta apiUrl sesuai endpoint latihan
const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';

class Tahap2HttpGetPage extends StatefulWidget {
  const Tahap2HttpGetPage({super.key});

  @override
  State<Tahap2HttpGetPage> createState() => _Tahap2HttpGetPageState();
}

class _Tahap2HttpGetPageState extends State<Tahap2HttpGetPage> {
  // Flag endpoint untuk simulasi error (langkah 4 worksheet)
  bool _useWrongUrl = false;
  late Future<List<dynamic>> _futureCourses;

  String get _currentUrl => _useWrongUrl
      ? 'https://jsonplaceholder.typicode.com/salah_endpoint_404'
      : apiUrl;

  Future<List<dynamic>> fetchCourses() async {
    debugPrint('Memanggil GET: $_currentUrl');
    final response = await http.get(Uri.parse(_currentUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      debugPrint('GET Berhasil! Jumlah item: ${data.length}');
      return data;
    }

    debugPrint('GET Gagal! Status code: ${response.statusCode}');
    throw Exception('HTTP ${response.statusCode}: Gagal mengambil data');
  }

  @override
  void initState() {
    super.initState();
    _futureCourses = fetchCourses();
  }

  void _reload() {
    setState(() {
      _futureCourses = fetchCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 2 - HTTP GET'),
        actions: [
          IconButton(
            tooltip: 'Refresh data',
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: IdentityBar(name: studentName, nim: studentId),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      'Endpoint aktif:\n$_currentUrl',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      icon: Icon(
                        _useWrongUrl
                            ? Icons.check_circle_outline
                            : Icons.error_outline,
                      ),
                      label: Text(
                        _useWrongUrl
                            ? 'Kembalikan ke URL Benar'
                            : 'Simulasikan URL Salah (Error 404)',
                      ),
                      onPressed: () {
                        setState(() {
                          _useWrongUrl = !_useWrongUrl;
                          _futureCourses = fetchCourses();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _futureCourses,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Mengambil data via HTTP GET...'),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 54,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Terjadi Error:\n${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi (Retry)'),
                            onPressed: _reload,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final List<dynamic> data = snapshot.data ?? [];
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'HTTP 200 OK — Berhasil memuat: ${data.length} item',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: data.length > 10 ? 10 : data.length,
                        itemBuilder: (context, index) {
                          final item = data[index] as Map<String, dynamic>;
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('${item['id']}'),
                              ),
                              title: Text(
                                item['title']?.toString() ?? 'No Title',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                item['body']?.toString() ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
          ),
        ],
      ),
    );
  }
}

