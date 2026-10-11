
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/course.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  late Future<List<Course>> coursesFuture;

  // Shared state untuk daftar favorite.
  final Set<String> favorites = {};

  // Tahap 4: ValueNotifier untuk jumlah favorite.
  final ValueNotifier<int> favoriteCount = ValueNotifier<int>(0);

  List<Course> loadedCourses = [];

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

  // Memperbarui favorite berdasarkan course yang dipilih.
  void toggleFavorite(String code) {
    setState(() {
      if (favorites.contains(code)) {
        favorites.remove(code);
      } else {
        favorites.add(code);
      }
    });

    favoriteCount.value = favorites.length;
  }

  // Tombol Tambah Favorite.
  // Menambahkan course pertama yang belum menjadi favorite.
  void addFavorite() {
    for (final course in loadedCourses) {
      if (!favorites.contains(course.code)) {
        toggleFavorite(course.code);
        return;
      }
    }
  }

  // Tombol Kurangi Favorite.
  // Menghapus satu course yang sedang menjadi favorite.
  void subtractFavorite() {
    if (favorites.isNotEmpty) {
      toggleFavorite(favorites.last);
    }
  }

  void clearFavorites() {
    setState(() {
      favorites.clear();
    });

    favoriteCount.value = favorites.length;
  }

  @override
  void dispose() {
    favoriteCount.dispose();
    super.dispose();
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
          loadedCourses = courses;

          return Column(
            children: [
              CourseSummary(
                favorites: favorites,
                favoriteCount: favoriteCount,
                onClearFavorites: clearFavorites,
                onAddFavorite: addFavorite,
                onSubtractFavorite: subtractFavorite,
              ),
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

// Ringkasan dan kontrol jumlah favorite.
class CourseSummary extends StatelessWidget {
  final Set<String> favorites;
  final ValueNotifier<int> favoriteCount;
  final VoidCallback onClearFavorites;
  final VoidCallback onAddFavorite;
  final VoidCallback onSubtractFavorite;

  const CourseSummary({
    super.key,
    required this.favorites,
    required this.favoriteCount,
    required this.onClearFavorites,
    required this.onAddFavorite,
    required this.onSubtractFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          ValueListenableBuilder<int>(
            valueListenable: favoriteCount,
            builder: (context, value, child) {
              return Text(
                'Jumlah Favorite: $value',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: onAddFavorite,
                child: const Text('Tambah Favorite'),
              ),
              OutlinedButton(
                onPressed: favorites.isEmpty
                    ? null
                    : onSubtractFavorite,
                child: const Text('Kurangi Favorite'),
              ),
              if (favorites.isNotEmpty)
                TextButton(
                  onPressed: onClearFavorites,
                  child: const Text('Reset'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// Daftar course.
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

        return CourseCard(
          course: course,
          isFavorite: isFavorite,
          onFavoriteChanged: () {
            onFavoriteChanged(course.code);
          },
          onTap: () => onCourseTap(course),
        );
      },
    );
  }
}
