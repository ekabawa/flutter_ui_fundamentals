import 'package:flutter/material.dart';
import 'dart:async';

class DebuggingChallengePage extends StatelessWidget {
  const DebuggingChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    const studentName = 'I Putu Eka Bawa Utama';
    const studentId = '2415051008';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debugging Challenge'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // KASUS C
            // =========================
            const Text(
              'Kasus C - Keyboard Overflow',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const TextField(
              decoration: InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            const TextField(
              decoration: InputDecoration(
                labelText: 'NIM',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Komentar',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 300),

            ElevatedButton(
              onPressed: () {},
              child: const Text('Kirim'),
            ),

            const SizedBox(height: 40),

            // =========================
            // KASUS D
            // =========================
            const Text(
              'Kasus D - Navigasi Ganda',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              '$studentId - $studentName',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DebugDetailPage(),
                  ),
                );
              },
              child: const Text('Buka Detail'),
            ),
          ],
        ),
      ),
    );
  }
}


// ======================================
// HALAMAN DETAIL UNTUK KASUS D
// ======================================

class DebugDetailPage extends StatelessWidget {
  const DebugDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Detail'),
      ),
      body: const Center(
        child: Text(
          'Halaman Detail',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


// ======================================
// KASUS D - ASYNC DAN MOUNTED
// ======================================

class AsyncMountedDebugPage extends StatefulWidget {
  const AsyncMountedDebugPage({super.key});

  @override
  State<AsyncMountedDebugPage> createState() =>
      _AsyncMountedDebugPageState();
}

class _AsyncMountedDebugPageState
    extends State<AsyncMountedDebugPage> {
  String status = 'Belum dimulai';

  Future<void> mulaiProses() async {
    setState(() {
      status = 'Memproses...';
    });

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    setState(() {
      status = 'Proses selesai';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasus D - Async dan mounted'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                status,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: mulaiProses,
                child: const Text('Mulai Proses Async'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}