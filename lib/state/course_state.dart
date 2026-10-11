
import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseState extends ChangeNotifier {
  final CourseRepository repository;

  CourseState(this.repository);

  final Set<String> favorites = {};

  Future<List<Course>> loadCourses() {
    return repository.getCourses();
  }

  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }

    notifyListeners();
  }

  void clearFavorites() {
    favorites.clear();
    notifyListeners();
  }
}
