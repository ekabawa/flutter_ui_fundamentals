
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../state/course_state.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  late Future<List<Course>> coursesFuture;

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
              CourseSummary(courses: courses),
              Expanded(
                child: CourseList(
                  courses: courses,
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

// Menggunakan watch() untuk mendengarkan perubahan jumlah favorite.
class CourseSummary extends StatelessWidget {
  final List<Course> courses;

  const CourseSummary({
    super.key,
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseState>();
    final favoriteCount = provider.favorites.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          Text(
            'Jumlah Favorite: $favoriteCount',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () {
                  // read() mengambil state tanpa listen.
                  final state = context.read<CourseState>();

                  for (final course in courses) {
                    if (!state.favorites.contains(course.code)) {
                      state.toggleFavorite(course.code);
                      break;
                    }
                  }
                },
                child: const Text('Tambah Favorite'),
              ),
              OutlinedButton(
                onPressed: favoriteCount == 0
                    ? null
                    : () {
                        // Hapus satu favorite.
                        final state = context.read<CourseState>();
                        state.toggleFavorite(
                          state.favorites.last,
                        );
                      },
                child: const Text('Kurangi Favorite'),
              ),
              if (favoriteCount > 0)
                TextButton(
                  onPressed: () {
                    context.read<CourseState>().clearFavorites();
                  },
                  child: const Text('Reset'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// Consumer membatasi rebuild pada bagian kartu course.
class CourseList extends StatelessWidget {
  final List<Course> courses;
  final ValueChanged<Course> onCourseTap;

  const CourseList({
    super.key,
    required this.courses,
    required this.onCourseTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];

        return Consumer<CourseState>(
          builder: (context, provider, child) {
            final isFavorite =
                provider.favorites.contains(course.code);

            return CourseCard(
              course: course,
              isFavorite: isFavorite,
              onFavoriteChanged: () {
                // read() digunakan untuk menjalankan aksi toggle.
                context
                    .read<CourseState>()
                    .toggleFavorite(course.code);
              },
              onTap: () => onCourseTap(course),
            );
          },
        );
      },
    );
  }
}
