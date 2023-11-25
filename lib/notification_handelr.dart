import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'constance.dart';
import 'main.dart';
import 'models/user_model.dart';
import 'modules/chats/chat_screen.dart';

class NotificationHandelr {
  static final messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();
  /// to initial Local Notification
  static Future<void> initLocalNotification() async {
    var androidInitializationSetting =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializeSetting = InitializationSettings(
      android: androidInitializationSetting,
    );
    await localNotification.initialize(initializeSetting,
        onDidReceiveNotificationResponse: (payload) {});
  }

  /// show foreGround Notification
  static Future<void> showLocalNotification({required RemoteMessage message}) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'chats',
      'Chats',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      channel.id,
      channel.name,
      enableVibration: true,
      playSound: true,
      importance: Importance.max,
      priority: Priority.max,
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    localNotification.show(
      0,
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      notificationDetails,
    );
  }

  static Future<void> setupInteractedMessage() async {
    messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((event) {
      showLocalNotification(message: event);
    });
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onBackgroundMessage(
        (_firebaseMessagingBackgroundHandler));
  }

  static void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      MyApp.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => const ChatScreen(),
        ),
      );
    }
  }

  static Future<void> sendPushNotification(
      {required SocialUserModel userModel,
      required String msg,
      required String name}) async {
    try {
      final body = {
        "to": userModel.pushToken,
        "notification": {
          "title": name,
          "body": msg,
          "android_channel_id": "chats",
          "sound": "default",
          "android_channel_name":'Chats',
          "image_url": userModel.image,
          "data": {
            "user_model": userModel.uId,
            "type": 'chat',
          },
          "priority": "max",
          "content_available": true,
        }
      };
      var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
      var response = await http.post(url, body: jsonEncode(body), headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'key=$serverKey',
      });
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (error) {
      log('pushNotificationException : ${error.toString()}');
    }
  }

}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.data['type'] == 'chat') {
    MyApp.navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => const ChatScreen(),
      ),
    );
  }
  log("Handling a background message: ${message.messageId}");
}
