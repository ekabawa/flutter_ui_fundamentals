
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/course.dart';
import 'course_detail_page.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  late Future<List<Course>> coursesFuture;

  // Shared state sementara yang dimiliki parent.
  final Set<String> favorites = {};

  @override
  void initState() {
    super.initState();
    coursesFuture = loadCourses();
  }

  Future<List<Course>> loadCourses() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );

    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final courses = data['courses'] as List<dynamic>;

    return courses
        .map(
          (course) => Course.fromJson(
            course as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  // Parent menjadi pemilik state dan mengatur perubahannya.
  void toggleFavorite(String code) {
    setState(() {
      if (favorites.contains(code)) {
        favorites.remove(code);
      } else {
        favorites.add(code);
      }
    });
  }

  void clearFavorites() {
    setState(() {
      favorites.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer'),
      ),
      body: FutureBuilder<List<Course>>(
        future: coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Terjadi error: ${snapshot.error}'),
            );
          }

          final courses = snapshot.data ?? [];

          return Column(
            children: [
              // Child pertama: menerima state dan callback.
              CourseSummary(
                favorites: favorites,
                onClearFavorites: clearFavorites,
              ),

              // Child kedua: menerima state dan callback.
              Expanded(
                child: CourseList(
                  courses: courses,
                  favorites: favorites,
                  onFavoriteChanged: toggleFavorite,
                  onCourseTap: (course) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseDetailPage(
                          course: course,
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

// CHILD 1: ringkasan favorite.
class CourseSummary extends StatelessWidget {
  final Set<String> favorites;
  final VoidCallback onClearFavorites;

  const CourseSummary({
    super.key,
    required this.favorites,
    required this.onClearFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: ListTile(
        leading: const Icon(Icons.favorite, color: Colors.red),
        title: const Text('Course Favorites'),
        subtitle: Text(
          '${favorites.length} course ditandai sebagai favorite',
        ),
        trailing: TextButton(
          onPressed: favorites.isEmpty ? null : onClearFavorites,
          child: const Text('Reset'),
        ),
      ),
    );
  }
}

// CHILD 2: daftar course.
class CourseList extends StatelessWidget {
  final List<Course> courses;
  final Set<String> favorites;
  final ValueChanged<String> onFavoriteChanged;
  final ValueChanged<Course> onCourseTap;

  const CourseList({
    super.key,
    required this.courses,
    required this.favorites,
    required this.onFavoriteChanged,
    required this.onCourseTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        final isFavorite = favorites.contains(course.code);

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: const Icon(Icons.school),
            title: Text(
              course.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${course.code} • ${course.credits} SKS',
            ),
            trailing: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () => onFavoriteChanged(course.code),
            ),
            onTap: () => onCourseTap(course),
          ),
        );
      },
    );
  }
}
