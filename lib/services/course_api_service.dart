
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/course.dart';

const String apiUrl =
    'https://jsonplaceholder.typicode.com/posts';

class CourseApiService {
  Future<List<Course>> fetchCourses() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;

      final courses = data.map((item) {
        return Course.fromJson(
          item as Map<String, dynamic>,
        );
      }).toList();

      debugPrint('Jumlah data dari API: ${courses.length}');

      return courses;
    }

    throw Exception('HTTP ${response.statusCode}');
  }
}
