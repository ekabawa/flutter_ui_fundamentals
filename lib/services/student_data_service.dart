
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class StudentDataService {
  Future<Map<String, dynamic>> loadStudentData() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );

    return jsonDecode(jsonString) as Map<String, dynamic>;
  }
}
