
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../services/course_supabase_service.dart';
import '../state/course_state.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final CourseSupabaseService _supabaseService =
      CourseSupabaseService();

  late Future<List<Course>> coursesFuture;

  @override
  void initState() {
    super.initState();
    coursesFuture = _supabaseService.getCourses();
  }

  void _reloadCourses() {
    setState(() {
      coursesFuture = _supabaseService.getCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteState = context.watch<CourseState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Courses'),
      ),
      body: FutureBuilder<List<Course>>(
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Gagal memuat mata kuliah: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _reloadCourses,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final courses = snapshot.data ?? [];

          final favoriteCourses = courses
              .where(
                (course) =>
                    favoriteState.isFavorite(course.code),
              )
              .toList();

          if (favoriteCourses.isEmpty) {
            return const Center(
              child: Text('Belum ada mata kuliah favorit.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteCourses.length,
            itemBuilder: (context, index) {
              final course = favoriteCourses[index];

              return CourseCard(
                course: course,
                isFavorite:
                    favoriteState.isFavorite(course.code),
                onFavoriteChanged: () {
                  context
                      .read<CourseState>()
                      .toggleFavorite(course.code);
                },
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CourseDetailPage(
                        course: course,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
