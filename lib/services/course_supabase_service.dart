
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';

class CourseSupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Course>> getCourses() async {
    final data = await _supabase
        .from('courses')
        .select()
        .order('id');

    return (data as List)
        .map(
          (e) => Course.fromJson(
            Map<String, dynamic>.from(e),
          ),
        )
        .toList();
  }

  Future<void> createCourse(Course course) async {
    final data = course.toJson();
    data.remove('id');

    await _supabase
        .from('courses')
        .insert(data);
  }
}
