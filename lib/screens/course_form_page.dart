// ============================================================
// Praktikum Pemwob - Pertemuan 7
// Tahap 6: Form Tambah Course (Create Resource via HTTP POST)
// Nama  : Agus Adrian Satria Ananta
// NIM   : 2415051066
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/identity_bar.dart';

const String studentName = 'Agus Adrian Satria Ananta';
const String studentId = '2415051066';

class CourseFormPage extends StatefulWidget {
  final Course? initialCourse;

  const CourseFormPage({super.key, this.initialCourse});

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _codeController;
  late final TextEditingController _titleController;
  late final TextEditingController _creditsController;
  String _selectedStatus = 'planned';

  bool _isSaving = false;

  bool get _isEditMode => widget.initialCourse != null;

  @override
  void initState() {
    super.initState();
    final c = widget.initialCourse;
    _codeController = TextEditingController(text: c?.code ?? '');
    _titleController = TextEditingController(text: c?.title ?? '');
    _creditsController = TextEditingController(text: c != null ? '${c.credits}' : '2');
    _selectedStatus = c?.status ?? 'planned';
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final course = Course(
        id: widget.initialCourse?.id,
        code: _codeController.text.trim(),
        title: _titleController.text.trim(),
        credits: int.parse(_creditsController.text.trim()),
        status: _selectedStatus,
      );

      // Panggil createCourse melalui CourseProvider
      await context.read<CourseProvider>().createCourse(course);

      // Guard: Cek apakah widget masih terpasang pada tree sebelum pakai context
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Course "${course.title}" berhasil disimpan!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan course: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Course' : 'Tambah Course'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const IdentityBar(name: studentName, nim: studentId),
              const SizedBox(height: 20),

              // 1. Kode Course
              TextFormField(
                controller: _codeController,
                readOnly: _isEditMode, // Kunci kode dibuat readonly pada mode edit
                decoration: InputDecoration(
                  labelText: 'Kode Course *',
                  hintText: 'Contoh: MOB01',
                  prefixIcon: const Icon(Icons.code),
                  border: const OutlineInputBorder(),
                  filled: _isEditMode,
                  fillColor: _isEditMode ? Colors.grey.shade100 : null,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Kode course tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 2. Judul Course
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Judul / Nama Course *',
                  hintText: 'Contoh: Pemrograman Mobile Lanjut',
                  prefixIcon: const Icon(Icons.book),
                  border: const OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Judul course tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. SKS / Credits
              TextFormField(
                controller: _creditsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Jumlah SKS *',
                  hintText: 'Contoh: 2 atau 3',
                  prefixIcon: const Icon(Icons.numbers),
                  border: const OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'SKS tidak boleh kosong';
                  }
                  final num = int.tryParse(val.trim());
                  if (num == null || num <= 0) {
                    return 'SKS harus berupa angka positif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 4. Status
              DropdownButtonFormField<String>(
                initialValue: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status Course',
                  prefixIcon: const Icon(Icons.flag),
                  border: const OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'planned',
                    child: Text('Direncanakan (planned)'),
                  ),
                  DropdownMenuItem(
                    value: 'active',
                    child: Text('Sedang Berjalan (active)'),
                  ),
                  DropdownMenuItem(
                    value: 'done',
                    child: Text('Selesai (done)'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedStatus = val);
                  }
                },
              ),
              const SizedBox(height: 24),

              // Tombol Simpan dengan Guard isSaving (mencegah submit ganda)
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.teal.shade700,
                  foregroundColor: Colors.white,
                ),
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  _isSaving
                      ? 'Menyimpan...'
                      : (_isEditMode ? 'Perbarui Course' : 'Simpan Course'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
