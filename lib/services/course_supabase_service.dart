
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
    final user = _supabase.auth.currentUser;
    final data = course.toJson();
    data.remove('id');

    if (course.ownerId != null && course.ownerId!.isNotEmpty) {
      data['owner_id'] = course.ownerId;
    } else if (user != null) {
      data['owner_id'] = user.id;
    }

    await _supabase
        .from('courses')
        .insert(data);
  }

  
  Future<bool> updateCourse(Course course) async {
    if (course.id == null) {
      throw ArgumentError('ID course tidak boleh kosong.');
    }

    final response = await _supabase
        .from('courses')
        .update({
          'code': course.code,
          'title': course.title,
          'credits': course.credits,
          'status': course.status,
        })
        .eq('id', course.id!)
        .select();

    return (response as List).isNotEmpty;
  }

  Future<bool> deleteCourse(int id) async {
    final response = await _supabase
        .from('courses')
        .delete()
        .eq('id', id)
        .select();

    return (response as List).isNotEmpty;
  }

}
