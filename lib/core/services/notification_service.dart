import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future<void> init() async {
    final android = AndroidInitializationSettings('smartbreath');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );
  }

  static Future<NotificationDetails> _notificationDetails() async {
    const int insistentFlag = 4;
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        playSound: true,
        additionalFlags: Int32List.fromList(<int>[insistentFlag]),
        styleInformation: BigTextStyleInformation(''),
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    await _notifications.show(
      id,
      title,
      body,
      await _notificationDetails(),
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<bool> areNotificationsEnabled() async {
    // Bu metod, bildirimlerin etkin olup olmadığını kontrol etmek için kullanılabilir.
    // Şu an için her zaman true dönüyor, ancak gerçek uygulamada
    // kullanıcının bildirim ayarlarını kontrol etmek gerekebilir.
    return true;
  }

  Future<bool> toggleNotifications() async {
    // Bu metod, bildirimleri açıp kapatmak için kullanılabilir.
    // Şu an için sadece true dönüyor, ancak gerçek uygulamada
    // kullanıcının bildirim ayarlarını değiştirmek gerekebilir.
    return true;
  }
}