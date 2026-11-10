
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Meminta izin notifikasi
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint(
      'Status izin: ${settings.authorizationStatus}',
    );

    // Mengambil FCM Token
    String? token = await _firebaseMessaging.getToken();

    debugPrint('FCM Token: $token');

    // Mendengarkan pesan saat aplikasi terbuka
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Notifikasi diterima');
      debugPrint('Judul: ${message.notification?.title}');
      debugPrint('Isi: ${message.notification?.body}');
    });
  }
}
