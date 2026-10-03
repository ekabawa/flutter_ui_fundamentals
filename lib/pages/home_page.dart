import 'package:flutter/material.dart';

const String studentName = 'I Putu Eka Bawa Utama';
const String studentId = '2415051008';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Home',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              studentName,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              studentId,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}