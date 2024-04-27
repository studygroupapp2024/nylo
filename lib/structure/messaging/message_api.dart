import 'dart:convert';
import 'dart:developer' as devtools show log;
import 'dart:io';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:nylo/main.dart';
import 'package:nylo/pages/home/study_group/my_study_groups.dart';
import 'package:nylo/pages/home/tutor/my_tutor_classes.dart';

@pragma("vm:entry-point")
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    int id = Random().nextInt(1000000);
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'high_importance_channel',
        title: message.data['title'],
        body: message.data['body'],
        actionType: ActionType.SilentAction,
        notificationLayout: NotificationLayout.Default,
        payload: {
          "navigate": "true",
        },
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'check',
          label: 'Check it out',
          actionType: ActionType.SilentAction,
          color: Colors.green,
        )
      ],
    );
  } else {
    print("Notification is null");
  }
  print("Payload: ${message.data}");
}

class FirebaseMessage {
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();

    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'high_importance_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          defaultRingtoneType: DefaultRingtoneType.Notification,
          enableLights: true,
          enableVibration: true,
          vibrationPattern: highVibrationPattern,
          onlyAlertOnce: true,
        )
      ],
    );

    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          // Request permission to send notifications
          AwesomeNotifications().requestPermissionToSendNotifications().then(
            (isAllowed) {
              if (isAllowed) {
                devtools.log('User allowed notifications');
              } else {
                devtools.log('User denied notifications');
              }
            },
          );
        }
      },
    );

    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        int id = Random().nextInt(1000000);
        await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: id,
            channelKey: 'high_importance_channel',
            title: message.data['title'],
            body: message.data['body'],
            actionType: ActionType.SilentAction,
            notificationLayout: NotificationLayout.Default,
            payload: {
              "navigate": "true",
            },
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'check',
              label: 'Check it out',
              actionType: ActionType.SilentAction,
              color: Colors.green,
            )
          ],
        );
      } else {
        print("Notification is null");
      }
      print("Payload: ${message.data}");
    });

    FirebaseMessaging.instance.getInitialMessage().then(
          (value) => {
            if (value != null)
              {
                if (value.data['navigate'] == "true")
                  {
                    if (value.data['route'] == "groupchats")
                      {
                        MainApp.navigatorKey.currentState?.push(
                          MaterialPageRoute(
                            builder: (_) => FindPage(),
                          ),
                        )
                      }
                    else
                      {
                        MainApp.navigatorKey.currentState?.push(
                          MaterialPageRoute(
                            builder: (_) => TutorClassses(),
                          ),
                        )
                      }
                  },
              },
          },
        );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        print("MESSAGE DATA: ${message.data}");
        print("MESSAGE DATA ROUTE: ${message.data['route']}");
        if (message.data['navigate'] == "true") {
          if (message.data['route'] == "groupchats") {
            MainApp.navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (_) => FindPage(),
              ),
            );
          } else {
            MainApp.navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (_) => TutorClassses(),
              ),
            );
          }
        }
      },
    );
  }

  Future<String?> getFCMToken() async {
    return await firebaseMessaging.getToken();
  }

  Future<bool> sendPushMessage({
    required String recipientToken,
    required String title,
    required String body,
    required String route,
  }) async {
// Read the contents of the credentials file
    String credentialsJson = File('ServiceAccountKey.json').readAsStringSync();

// Parse the JSON string into a Map
    Map<String, dynamic> credentials = json.decode(credentialsJson);
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({credentials}),
      ['https://www.googleapis.com/auth/cloud-platform'],
    );
    final notificationData = {
      'message': {
        'token': recipientToken,
        'notification': {},
        'data': {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "screen": "screenA",
          // Use 'data' instead of 'payload'
          "navigate": "false",
          "route": route,
          'title': title,
          'body': body,
        },
      },
    };

    const String senderId = '378925058177';
    final response = await client.post(
      Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$senderId/messages:send'),
      headers: {
        'content-type': 'application/json',
      },
      body: jsonEncode(notificationData),
    );

    client.close();
    if (response.statusCode == 200) {
      return true; // Success!
    }

    devtools.log(
        'Notification Sending Error Response status: ${response.statusCode}');
    devtools.log('Notification Response body: ${response.body}');
    return false;
  }
}
