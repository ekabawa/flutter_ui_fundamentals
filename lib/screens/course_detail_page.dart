import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_course_page.dart';

import '../models/course.dart';
import '../state/course_state.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseState>();
    final isFavorite = provider.isFavorite(course.code);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Kode: ${course.code}',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 8),

            Text(
              'SKS: ${course.credits}',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 8),

            Text(
              'Status: ${course.status}',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 24),

            // Favorite menggunakan Provider yang sama.
            ElevatedButton.icon(
              onPressed: () {
                context
                    .read<CourseState>()
                    .toggleFavorite(course.code);

                final message = isFavorite
                    ? 'Course dihapus dari favorite'
                    : 'Course ditambahkan ke favorite';

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              },
              icon: Icon(
                isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              label: Text(
                isFavorite ? 'Favorite' : 'Tambah Favorite',
              ),
            ),


            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: course.id == null
                    ? null
                    : () async {
                        final updated = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditCoursePage(
                              course: course,
                            ),
                          ),
                        );

                        if (!context.mounted) return;

                        if (updated == true) {
                          Navigator.pop(context, true);
                        }
                      },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Course'),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Informasi Course',

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Materi pembelajaran dan aktivitas course '
              'dapat dikembangkan pada halaman ini.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
