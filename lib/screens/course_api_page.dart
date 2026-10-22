
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
  late Future<List<Course>> coursesFuture;

  @override
  void initState() {
    super.initState();
    coursesFuture = apiService.fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REST API Courses'),
      ),
      body: Column(
        children: [
          const ListTile(
            title: Text('I Putu Eka Bawa Utama'),
            subtitle: Text('NIM: 2415051008'),
          ),
          Expanded(
            child: FutureBuilder<List<Course>>(
              future: coursesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final courses = snapshot.data ?? [];

                if (courses.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada data course'),
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
