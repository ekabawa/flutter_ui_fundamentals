
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../state/course_state.dart';
import 'edit_course_page.dart';
import '../services/profile_service.dart';
import '../widgets/role_guard.dart';

class CourseDetailPage extends StatefulWidget {
  final Course course;

  const CourseDetailPage({
    super.key,
    required this.course,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final ProfileService _profileService = ProfileService();
  late Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _profileService.getMyProfile();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseState>();
    final isFavorite = provider.isFavorite(widget.course.code);

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
              widget.course.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Kode: ${widget.course.code}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),

            Text(
              'SKS: ${widget.course.credits}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),

            Text(
              'Status: ${widget.course.status}',
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
                      .toggleFavorite(widget.course.code);

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
            // Tombol Edit Course (Khusus Instructor)
            FutureBuilder<UserProfile?>(
              future: _profileFuture,
              builder: (context, snapshot) {
                final role = snapshot.data?.role;
                return RoleGuard(
                  role: role,
                  allowed: const ['instructor'],
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: widget.course.id == null
                              ? null
                              : () async {
                                  final updated =
                                      await Navigator.push<bool>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditCoursePage(
                                        course: widget.course,
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
                    ],
                  ),
                );
              },
            ),
            // Tombol Hapus Course (Khusus Instructor)
            FutureBuilder<UserProfile?>(
              future: _profileFuture,
              builder: (context, snapshot) {
                final role = snapshot.data?.role;
                return RoleGuard(
                  role: role,
                  allowed: const ['instructor'],
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: widget.course.id == null
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
                              '${widget.course.title}?',
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
                              .deleteCourse(widget.course.id!);

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
                    ],
                  ),
                );
              },
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
