
import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/course_api_service.dart';

class CourseApiPage extends StatefulWidget {
  const CourseApiPage({super.key});

  @override
  State<CourseApiPage> createState() => _CourseApiPageState();
}

class _CourseApiPageState extends State<CourseApiPage> {
  final CourseApiService apiService = CourseApiService();

  final formKey = GlobalKey<FormState>();
  final codeController = TextEditingController();
  final titleController = TextEditingController();
  final creditsController = TextEditingController();

  List<Course> courses = [];
  bool isLoading = true;
  bool isSubmitting = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  @override
  void dispose() {
    codeController.dispose();
    titleController.dispose();
    creditsController.dispose();
    super.dispose();
  }

  Future<void> loadCourses() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await apiService.getCourses();
      if (!mounted) return;

      setState(() {
        courses = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> createCourse() async {
    if (!formKey.currentState!.validate()) return;

    final course = Course(
      code: codeController.text.trim(),
      title: titleController.text.trim(),
      credits: int.parse(creditsController.text.trim()),
    );

    setState(() => isSubmitting = true);

    try {
      final createdCourse = await apiService.createCourse(course);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'POST berhasil: ${createdCourse.title}',
          ),
          backgroundColor: Colors.green,
        ),
      );

      codeController.clear();
      titleController.clear();
      creditsController.clear();

      await loadCourses();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuat course: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  Widget buildCourseForm() {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Tambah Course',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Code wajib diisi'
                        : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Title wajib diisi'
                        : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: creditsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Credits',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Credits wajib diisi';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Credits harus berupa angka bulat';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: isSubmitting ? null : createCourse,
                icon: isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.add),
                label: Text(
                  isSubmitting ? 'Mengirim...' : 'Simpan Course',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REST API Courses'),
        actions: [
          IconButton(
            onPressed: isLoading ? null : loadCourses,
            tooltip: 'Refresh data',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          const ListTile(
            title: Text('I Putu Eka Bawa Utama'),
            subtitle: Text('NIM: 2415051008'),
          ),
          Expanded(
            child: ListView(
              children: [
                buildCourseForm(),
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Gagal memuat data course\n$errorMessage',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: loadCourses,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  )
                else if (courses.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text('Data course belum tersedia'),
                    ),
                  )
                else ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(
                      'Daftar Course (3 data pertama)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...courses.take(3).toList().asMap().entries.map(
                    (entry) {
                      final index = entry.key;
                      final course = entry.value;

                      return ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        title: Text(course.title),
                        subtitle: Text('Code: ${course.code}'),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
