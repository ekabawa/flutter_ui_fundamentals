import 'package:flutter/material.dart';

import '../models/course.dart';

class CourseDetailPage extends StatefulWidget {
  final Course course;

  const CourseDetailPage({
    super.key,
    required this.course,
  });

  @override
  State<CourseDetailPage> createState() =>
      _CourseDetailPageState();
}

class _CourseDetailPageState
    extends State<CourseDetailPage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final course = widget.course;

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

            // FAVORITE
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavorite
                          ? 'Course ditambahkan ke favorite'
                          : 'Course dihapus dari favorite',
                    ),
                  ),
                );
              },
              icon: Icon(
                isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              label: Text(
                isFavorite
                    ? 'Favorite'
                    : 'Tambah Favorite',
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Informasi Course',
              style: const TextStyle(
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