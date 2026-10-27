import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<bool> showTestNotification() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      throw UnsupportedError('This demo currently supports Android only.');
    }

    if (!_initialized) {
      final initialized = await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
      );

      if (initialized != true) {
        throw StateError('Notification setup failed.');
      }

      _initialized = true;
    }

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (android == null) {
      throw StateError('Android notifications are unavailable.');
    }

    final allowed = await android.requestNotificationsPermission();

    if (allowed != true) return false;

    await _plugin.show(
      id: 900001,
      title: 'CareLink test',
      body: 'This is a test notification, not a medicine reminder.',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'carelink_test',
          'CareLink test notifications',
          channelDescription: 'Used to test notification setup.',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );

    return true;
  }
}