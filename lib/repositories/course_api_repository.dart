import '../models/course.dart';
import '../services/course_api_service.dart';

class CourseApiRepository {
  CourseApiRepository(this.apiService);

  final CourseApiService apiService;

  Future<List<Course>> getCourses() =>
      apiService.getCourses();

  Future<Course> createCourse(Course course) =>
      apiService.createCourse(course);

  Future<void> updateCourse(int id, Course course) =>
      apiService.updateCourse(id, course);

  Future<void> deleteCourse(int id) =>
      apiService.deleteCourse(id);
}
