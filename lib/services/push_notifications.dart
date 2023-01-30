import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream =
      StreamController.broadcast();
  static Stream<String> get messageStream => _messageStream.stream;

  static Future initializeApp() async {
    const storage = FlutterSecureStorage();
    //Push notiifications
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    //print('Token: $token');
    storage.write(key: 'token', value: token);
    //Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    //Local notifications
  }

  static Future _backgroundHandler(RemoteMessage message) async {
    _messageStream.add(message.notification?.title ?? 'No title');
    //print('background Handler ${message.messageId}');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    _messageStream.add(message.notification?.title ?? 'No title');
    //print('onMessage Handler ${message.messageId}');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    _messageStream.add(message.notification?.title ?? 'No title');
    //print('onMessageOpenApp Handler ${message.messageId}');
  }

  static closeStreams() {
    _messageStream.close();
  }
}
