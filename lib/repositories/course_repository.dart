
import '../models/course.dart';
import '../services/course_supabase_service.dart';

class CourseRepository {
  CourseRepository(this.service);

  final CourseSupabaseService service;

  Future<List<Course>> getCourses() {
    return service.getCourses();
  }

  Future<void> createCourse(Course course) {
    return service.createCourse(course);
  }

  Future<void> updateCourse(Course course) {
    return service.updateCourse(course);
  }

  Future<void> deleteCourse(int id) {
    return service.deleteCourse(id);
  }
}
