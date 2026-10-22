
import 'package:flutter/material.dart';
import 'services/course_api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = CourseApiService();

  try {
    final data = await apiService.fetchCourses();
    debugPrint('GET berhasil!');
    debugPrint('Jumlah data: ${data.length}');
  } catch (e) {
    debugPrint('GET gagal: $e');
  }
}
