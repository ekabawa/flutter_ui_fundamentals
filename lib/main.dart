import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/courses_page.dart';


const String studentName = 'I Putu Eka Bawa Utama';
const String studentId = '2415051008';

Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );

  return jsonDecode(jsonString) as Map<String, dynamic>;
}

final List<Map<String, dynamic>> topics = [
  {
    'title': 'Git & GitHub',
    'subtitle': 'Version control',
    'done': true,
  },
  {
    'title': 'Dart Fundamentals',
    'subtitle': 'Language basics',
    'done': true,
  },
  {
    'title': 'Flutter UI Fundamentals',
    'subtitle': 'Widgets & layout',
    'done': false,
  },
  {
    'title': '$studentId - $studentName',
    'subtitle': 'Pemilik aplikasi',
    'done': false,
  },
];

void main() {
  runApp(const MyApp());
  
}

Widget buildStatCard(String value, String label, IconData icon) {
  return Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(label),
          ],
        ),
      ),
    ),
  );
}

class GreetingCard extends StatefulWidget {
  const GreetingCard({super.key});

  @override
  State<GreetingCard> createState() => _GreetingCardState();
}

class _GreetingCardState extends State<GreetingCard> {
  final TextEditingController controller = TextEditingController();

  String message = 'Belum ada pesan';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$studentId - $studentName',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Masukkan pesan',
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            setState(() {
              message = controller.text.trim().isEmpty
                  ? 'Input masih kosong'
                  : controller.text.trim();
            });
          },
          child: const Text('Tampilkan'),
        ),
        const SizedBox(height: 8),
        Text(message),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),

        scaffoldBackgroundColor: Colors.white,

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),

        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.blue.shade50,
          indicatorColor: Colors.blue.shade100,
        ),

        navigationRailTheme: NavigationRailThemeData(
          backgroundColor: Colors.blue.shade50,
          indicatorColor: Colors.blue.shade100,
        ),

        cardTheme: CardThemeData(
          color: Colors.blue.shade50,
          elevation: 2,
        ),
      ),

      home: const MainNavigationPage(),
    );
  }
}


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Dashboard'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat data: ${snapshot.error}',
              ),
            );
          }

          // Data
          final data = snapshot.data!;

          final student =
              data['student'] as Map<String, dynamic>;

          final courses =
              data['courses'] as List<dynamic>;

          // Hitung total SKS
          int totalCredits = 0;

          for (final course in courses) {
            totalCredits += course['credits'] as int;
          }

          // Hitung materi yang sudah selesai
          final completedCourses = courses
              .where(
                (course) => course['status'] == 'done',
              )
              .length;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PROFILE
                  ProfileCard(
                    student: student,
                  ),

                  const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue.shade100,
                  child: Text(
                    '$studentId - $studentName',
                  ),
                ),

                const SizedBox(height: 16),

                const ScreenInfoCard(),

                const SizedBox(height: 16),

                const ResponsiveLayoutExample(),

                const SizedBox(height: 16),

                const ExpandedWrapDemo(),

                const SizedBox(height: 16),
              

                  // SUMMARY CARD
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          icon: Icons.menu_book,
                          value: '${courses.length}',
                          label: 'Mata Kuliah',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SummaryCard(
                          icon: Icons.school,
                          value: '$totalCredits',
                          label: 'Total SKS',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  SummaryCard(
                    icon: Icons.check_circle,
                    value: '$completedCourses/${courses.length}',
                    label: 'Materi Selesai',
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.info),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$studentId - $studentName - '
                          'Ini adalah teks yang sangat panjang untuk menguji layout',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // JUDUL
                  const Text(
                    'Daftar Materi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // LIST MATERI
                  ResponsiveCourseGrid(
                    courses: courses,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


class ProfileCard extends StatelessWidget {
  final Map<String, dynamic> student;

  const ProfileCard({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(
                'assets/images/profile.jpg',
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    student['name'] as String,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'NIM: ${student['nim']}',
                  ),

                  Text(
                    'Kelas: ${student['class']}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const SummaryCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
            ),

            const SizedBox(height: 8),

            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(label),
          ],
        ),
      ),
    );
  }
}



class ScreenInfoCard extends StatelessWidget {
  const ScreenInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    final screenType = size.width < 600 ? 'Compact' : 'Wide';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Layar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Width: ${size.width.toStringAsFixed(0)}',
            ),

            Text(
              'Height: ${size.height.toStringAsFixed(0)}',
            ),

            Text(
              'Orientation: $orientation',
            ),

            Text(
              'Layout: $screenType',
            ),

            const SizedBox(height: 8),

            Text(
              '$studentId - $studentName',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompactLayout extends StatelessWidget {
  const CompactLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Compact Layout',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Kategori: Compact'),
            const Text('Lebar: < 600'),
            const SizedBox(height: 8),
            Text('$studentId - $studentName'),
          ],
        ),
      ),
    );
  }
}

class MediumLayout extends StatelessWidget {
  const MediumLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(
              Icons.tablet,
              size: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Medium Layout',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Kategori: Medium'),
                  const Text('Lebar: 600–839'),
                  Text('$studentId - $studentName'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ExpandedLayout extends StatelessWidget {
  const ExpandedLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            const Icon(
              Icons.desktop_windows,
              size: 50,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Expanded Layout',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Kategori: Expanded'),
                  const Text('Lebar: >= 840'),
                  Text('$studentId - $studentName'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResponsiveLayoutExample extends StatelessWidget {
  const ResponsiveLayoutExample({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return const CompactLayout();
        } else if (constraints.maxWidth < 840) {
          return const MediumLayout();
        } else {
          return const ExpandedLayout();
        }
      },
    );
  }
}



class ExpandedWrapDemo extends StatelessWidget {
  const ExpandedWrapDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final skills = [
      'Flutter',
      'Dart',
      'Git',
      'UI Design',
      'Firebase',
      'Responsive',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expanded 2:1',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 100,
                padding: const EdgeInsets.all(16),
                color: Colors.blue.shade100,
                child: const Center(
                  child: Text(
                    'Panel A\nFlex 2',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Container(
                height: 100,
                padding: const EdgeInsets.all(16),
                color: Colors.green.shade100,
                child: const Center(
                  child: Text(
                    'Panel B\nFlex 1',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        const Text(
          'Skills dengan Wrap',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills
              .map(
                (skill) => Chip(
                  label: Text(skill),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

int columnsFor(double width) {
  if (width < 600) {
    return 1;
  } else if (width < 840) {
    return 2;
  } else {
    return 3;
  }
}

class ResponsiveCourseGrid extends StatelessWidget {
  final List<dynamic> courses;

  const ResponsiveCourseGrid({
    super.key,
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = columnsFor(constraints.maxWidth);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course =
                courses[index] as Map<String, dynamic>;

            return InteractiveCourseCard(
              course: course,
            );
          },
        );
      },
    );
  }
}


class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() =>
      _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    CoursesPage(),
    NavigationProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 840) {
          return Scaffold(
            body: pages[currentIndex],

            bottomNavigationBar: NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.school),
                  label: 'Courses',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: currentIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.school),
                    label: Text('Courses'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person),
                    label: Text('Profile'),
                  ),
                ],
              ),

              const VerticalDivider(
                width: 1,
              ),

              Expanded(
                child: pages[currentIndex],
              ),
            ],
          ),
        );
      },
    );
  }
}


class NavigationHomePage extends StatelessWidget {
  const NavigationHomePage({super.key});

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
              'I Putu Eka Bawa Utama',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              '2415051008',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationCoursesPage extends StatefulWidget {
  const NavigationCoursesPage({super.key});

  @override
  State<NavigationCoursesPage> createState() =>
      _NavigationCoursesPageState();
}

class _NavigationCoursesPageState
    extends State<NavigationCoursesPage> {
  late Future<Map<String, dynamic>> studentFuture;

  @override
  void initState() {
    super.initState();
    studentFuture = loadStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat data: ${snapshot.error}',
              ),
            );
          }

          final data = snapshot.data!;
          final courses =
              data['courses'] as List<dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course =
                    courses[index] as Map<String, dynamic>;

                return InteractiveCourseCard(
                  course: course,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class NavigationProfilePage extends StatelessWidget {
  const NavigationProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Mahasiswa',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Nama: I Putu Eka Bawa Utama',
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 8),

            const Text(
              'NIM: 2415051008',
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const FeedbackFormPage(),
                  ),
                );
              },
              child: const Text('Beri Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}




class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detail Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Nama: $studentName',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'NIM: $studentId',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}



class ScrollableFormDemo extends StatelessWidget {
  const ScrollableFormDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scrollable Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profil Mahasiswa',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              decoration: const InputDecoration(
                labelText: 'NIM',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Diri',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Form ini dibuat lebih panjang dari tinggi layar '
                  'untuk menguji kemampuan scrolling.',
                ),
              ),
            ),

            const SizedBox(height: 300),

            const Text(
              'Bagian paling bawah form',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailPage({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final title = course['title'] as String;
    final code = course['code'] as String;
    final credits = course['credits'] as int;
    final status = course['status'] as String;

    String statusText;

    if (status == 'done') {
      statusText = 'Selesai';
    } else if (status == 'active') {
      statusText = 'Sedang Dipelajari';
    } else {
      statusText = 'Direncanakan';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Kode: $code',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 8),

            Text(
              'SKS: $credits',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 8),

            Text(
              'Status: $statusText',
              style: const TextStyle(fontSize: 18),
            ),

            const Divider(height: 32),

            Text(
              'Nama: $studentName',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 8),

            Text(
              'NIM: $studentId',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Pilih/Favorite'),
            ),
          ],
        ),
      ),
    );
  }
}


class InteractiveCourseCard extends StatefulWidget {
  final Map<String, dynamic> course;

  const InteractiveCourseCard({
    super.key,
    required this.course,
  });

  @override
  State<InteractiveCourseCard> createState() =>
      _InteractiveCourseCardState();
}

class _InteractiveCourseCardState
    extends State<InteractiveCourseCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final course = widget.course;

    return InkWell(
      onTap: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
      onLongPress: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${course['title']} - ${course['credits']} SKS',
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: Icon(
            isFavorite
                ? Icons.favorite
                : Icons.favorite_border,
          ),
          title: Text(
            course['title'] as String,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '${course['code']} • ${course['credits']} SKS',
          ),
        ),
      ),
    );
  }
}




class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final status = course['status'] as String;

    IconData icon;
    String statusText;

    if (status == 'done') {
      icon = Icons.check_circle;
      statusText = 'Selesai';
    } else if (status == 'active') {
      icon = Icons.play_circle;
      statusText = 'Sedang Dipelajari';
    } else {
      icon = Icons.schedule;
      statusText = 'Direncanakan';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailPage(
                course: course,
              ),
            ),
          );

          if (result == true && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Course berhasil dipilih/favorite'),
              ),
            );
          }
        },

        leading: Icon(icon),

        title: Text(
          course['title'] as String,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(
          '${course['code']} • ${course['credits']} SKS',
        ),

        trailing: Text(
          statusText,
        ),
      ),
    );
  }
}


class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() =>
      _FeedbackFormPageState();
}

class _FeedbackFormPageState
    extends State<FeedbackFormPage> {
  final formKey = GlobalKey<FormState>();

  final namaController =
      TextEditingController(text: studentName);

  final nimController =
      TextEditingController(text: studentId);

  final komentarController =
      TextEditingController();

  @override
  void dispose() {
    namaController.dispose();
    nimController.dispose();
    komentarController.dispose();
    super.dispose();
  }

Future<void> submitForm() async {
  if (!formKey.currentState!.validate()) {
    return;
  }

  if (!mounted) return;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text(
          'Apakah kamu yakin ingin mengirim feedback?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Kirim'),
          ),
        ],
      );
    },
  );

  if (!mounted) return;

  if (confirmed != true) {
    return;
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );

  await Future.delayed(
    const Duration(seconds: 2),
  );

  if (!mounted) return;

  Navigator.pop(context);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Feedback berhasil dikirim: '
        '${komentarController.text}',
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Form Feedback',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: nimController,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'NIM wajib diisi';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: komentarController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Komentar',
                  hintText: 'Tulis komentar...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().length < 5) {
                    return 'Komentar minimal 5 karakter';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitForm,
                  child: const Text(
                    'Kirim Feedback',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}