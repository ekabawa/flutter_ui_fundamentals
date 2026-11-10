import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

// Global key untuk menampilkan SnackBar
final GlobalKey<ScaffoldMessengerState> messengerKey =
    GlobalKey<ScaffoldMessengerState>();

// Background Handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint(
    '[BACKGROUND] ${message.notification?.title}',
  );

  debugPrint(
    '[BACKGROUND] ${message.notification?.body}',
  );
}

class NotificationService {
  final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  // Mengambil FCM Token
  Future<String?> getToken() async {
    // ignore: deprecated_member_use
    final token = await _firebaseMessaging.getToken();

    debugPrint('FCM Token: $token');

    return token;
  }

  // Mendengarkan perubahan FCM Token
  void listenTokenRefresh(void Function(String token) onRefresh) {
    // ignore: deprecated_member_use
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token diperbarui');
      onRefresh(newToken);
    });
  }

  // Meminta izin notifikasi
  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint(
      'Notification permission: ${settings.authorizationStatus.name}',
    );

    return settings.authorizationStatus;
  }

  // Inisialisasi Firebase Cloud Messaging
  Future<void> init() async {
    // Meminta izin notifikasi
    await requestPermission();

    // Mengambil FCM Token
    await getToken();

    // Mendengarkan perubahan token
    listenTokenRefresh((newToken) {
      debugPrint('Token terbaru diterima: $newToken');
    });

    // Mengatur notifikasi foreground
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Mendengarkan pesan ketika aplikasi terbuka
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('[FOREGROUND] Notification received');
      debugPrint('title: ${message.notification?.title}');
      debugPrint('body : ${message.notification?.body}');
      debugPrint('data : ${message.data}');

      final title = message.notification?.title ?? 'Notifikasi';
      final body = message.notification?.body ?? '';

      messengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('$title\n$body'),
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }
}
