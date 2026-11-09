import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfile {
  final String id;
  final String email;
  final String name;
  final String role; // student | instructor | admin

  const UserProfile({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  bool get isStudent => role == 'student';
  bool get isInstructor => role == 'instructor';
  bool get isAdmin => role == 'admin';

  // Getter kompatibilitas mundur
  bool get isSeeker => isStudent;
  bool get isOwner => isInstructor;

  String get roleLabel {
    switch (role.toLowerCase()) {
      case 'student':
      case 'seeker':
        return 'Student';
      case 'instructor':
      case 'owner':
        return 'Instructor';
      case 'admin':
        return 'Admin';
      default:
        return role;
    }
  }

  factory UserProfile.fromMap(Map<String, dynamic> m) => UserProfile(
        id: m['id'] as String,
        email: (m['email'] ?? '') as String,
        name: (m['name'] ?? '') as String,
        role: (m['role'] ?? 'student') as String,
      );
}

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<UserProfile?> getMyProfile() async {
    final user = _client.auth.currentUser; // currentUser
    if (user == null) return null;

    final data = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    return data == null ? null : UserProfile.fromMap(data);
    // currentUserRole
  }
}
