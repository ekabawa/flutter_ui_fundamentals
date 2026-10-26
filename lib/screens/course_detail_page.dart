
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../state/course_state.dart';
import 'edit_course_page.dart';

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
            const Center(
              child: Text(
                '2415051008 • I Putu Eka Bawa Utama',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

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

            // Tombol Favorite
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context
                      .read<CourseState>()
                      .toggleFavorite(course.code);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite
                            ? 'Course dihapus dari favorite'
                            : 'Course ditambahkan ke favorite',
                      ),
                    ),
                  );
                },
                icon: Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                label: Text(
                  isFavorite
                      ? 'Hapus dari Favorite'
                      : 'Tambah Favorite',
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tombol Edit Course
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: course.id == null
                    ? null
                    : () async {
                        final updated =
                            await Navigator.push<bool>(
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
            const SizedBox(height: 12),

            // Tombol Hapus Course
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: course.id == null
                    ? null
                    : () async {
                        final confirm =
                            await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) =>
                              AlertDialog(
                            title: const Text('Hapus Course?'),
                            content: Text(
                              'Apakah Anda yakin ingin menghapus '
                              '${course.title}?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                    dialogContext,
                                    false,
                                  );
                                },
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                    dialogContext,
                                    true,
                                  );
                                },
                                child: const Text('Hapus'),
                              ),
                            ],
                          ),
                        );

                        if (confirm != true ||
                            !context.mounted) {
                          return;
                        }

                        try {
                          final success = await context
                              .read<CourseProvider>()
                              .deleteCourse(course.id!);

                          if (!context.mounted) return;

                          if (success) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Course berhasil dihapus',
                                ),
                              ),
                            );

                            Navigator.pop(context, true);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Gagal menghapus course. '
                                  'Silakan coba lagi.',
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                'Gagal menghapus course: $e',
                              ),
                            ),
                          );
                        }
                      },
                icon: const Icon(Icons.delete),
                label: const Text('Hapus Course'),
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
