
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';

class CourseApiService {
  CourseApiService({
    this.baseUrl = 'https://jsonplaceholder.typicode.com',
  });

  final String baseUrl;

  Future<List<Course>> getCourses() async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil data: HTTP ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as List<dynamic>;

    return data
        .map(
          (item) => Course.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
