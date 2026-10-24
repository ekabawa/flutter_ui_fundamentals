
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

  List<Course> courses = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadCourses();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REST API Courses'),
        actions: [
          IconButton(
            onPressed: loadCourses,
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
            child: Builder(
              builder: (context) {
                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (errorMessage != null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Gagal memuat data course',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            errorMessage!,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: loadCourses,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (courses.isEmpty) {
                  return const Center(
                    child: Text('Data course belum tersedia'),
                  );
                }

                return ListView.builder(
                  itemCount: courses.take(3).length,
                  itemBuilder: (context, index) {
                    final course = courses[index];

                    return ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                      ),
                      title: Text(course.title),
                      subtitle: Text('Code: ${course.code}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
