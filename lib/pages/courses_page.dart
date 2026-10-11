import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../state/course_state.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';
import '../services/course_service.dart';

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
    coursesFuture = CourseService().loadCourses();
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

// watch() mendengarkan perubahan jumlah favorite.
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
    final firstCourse = courses.isNotEmpty ? courses.first : null;

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

          // Tahap 8: menampilkan objek Course hasil parsing JSON.
          if (firstCourse != null) ...[
            const SizedBox(height: 8),
            Text(
              'Model Course: ${firstCourse.title} '
              '(${firstCourse.code}) - ${firstCourse.credits} SKS',
              textAlign: TextAlign.center,
            ),
          ],

          const SizedBox(height: 12),

          // Tombol kontrol favorite.
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

// Consumer membatasi rebuild pada kartu course.
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
