
import 'package:flutter/material.dart';
import 'models/course.dart';
import 'services/course_api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = CourseApiService();

  try {
    final List<Course> courses = await apiService.getCourses();

    debugPrint('GET berhasil!');
    debugPrint('Jumlah data: ${courses.length}');

    for (final course in courses.take(3)) {
      debugPrint('Code: ${course.code}');
      debugPrint('Title: ${course.title}');
    }
  } catch (e) {
    debugPrint('GET gagal: $e');
  }
}
