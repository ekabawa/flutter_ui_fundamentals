import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../state/course_state.dart';
import '../widgets/course_card.dart';
import 'course_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = context.watch<CourseProvider>().courses;
    final favoriteState = context.watch<CourseState>();

    final favoriteCourses = courses
        .where((course) => favoriteState.isFavorite(course.code))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Courses'),
      ),
      body: favoriteCourses.isEmpty
          ? const Center(
              child: Text('Belum ada mata kuliah favorit.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteCourses.length,
              itemBuilder: (context, index) {
                final course = favoriteCourses[index];

                return CourseCard(
                  course: course,
                  isFavorite: favoriteState.isFavorite(course.code),
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
            ),
    );
  }
}
