import '../models/course.dart';
import '../services/course_service.dart';

class CourseRepository {
  CourseRepository(this.service);

  final CourseService service;

  Future<List<Course>> getCourses() {
    return service.loadCourses();
  }
}