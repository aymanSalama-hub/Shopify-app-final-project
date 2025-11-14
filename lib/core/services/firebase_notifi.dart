import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../features/notification/presentation/model/model_notifi.dart';
import '../../features/notification/presentation/widget/save_notifi.dart';
import '../../main.dart';
import '../../features/home/presentation/pages/home_screen.dart';

class FirebaseNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin local = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _fcm.requestPermission();

    // For debug
    print("FCM TOKEN: ${await _fcm.getToken()}");

    await _initLocalNotifications();

    _handleTerminated();
    _handleBackgroundOpen();
    _handleForeground();
  }

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await local.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        navigatorKey.currentState?.pushNamed(HomeScreen.routeName);
      },
    );
  }

  // TERMINATED
  void _handleTerminated() {
    _fcm.getInitialMessage().then((message) {
      if (message != null) _saveAndNavigate(message);
    });
  }

  // BACKGROUND → OPENED BY USER
  void _handleBackgroundOpen() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _saveAndNavigate(message);
    });
  }

  // FOREGROUND
  void _handleForeground() {
    FirebaseMessaging.onMessage.listen((message) async {
      print("🔔 Foreground Noti: ${message.notification?.title}");

      await local.show(
        message.hashCode,
        message.notification?.title,
        message.notification?.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "foreground_channel",
            "Foreground Notifications",
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );

      _saveNotification(message);
    });
  }

  // SAVE ONLY
  Future<void> _saveNotification(RemoteMessage message) async {
    if (message.notification == null) return;

    final note = AppNotification(
      title: message.notification!.title ?? "No Title",
      body: message.notification!.body ?? "",
      date: DateTime.now().toString(),
    );

    await NotificationStorage.saveNotification(note);
  }

  // SAVE + NAVIGATE
  Future<void> _saveAndNavigate(RemoteMessage message) async {
    await _saveNotification(message);

    navigatorKey.currentState?.pushNamed(HomeScreen.routeName);
  }
}
