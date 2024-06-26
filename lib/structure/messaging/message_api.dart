import 'dart:convert';
import 'dart:developer' as devtools show log;
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:nylo/config/app_config.dart';
import 'package:nylo/config/app_environments.dart';
import 'package:nylo/main_production.dart';
import 'package:nylo/pages/home/study_group/my_study_groups.dart';
import 'package:nylo/pages/home/tutor/my_tutor_classes.dart';
import 'package:nylo/pages/home/tutor/scheduler/set_schedule.dart';

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
    //FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
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
          );
        }
      },
    );

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
                    else if (value.data['route'] == "appointment")
                      {
                        MainApp.navigatorKey.currentState?.push(
                          MaterialPageRoute(
                            builder: (_) => SetSchedule(
                              classId: value.data['classId'],
                              tutorId: value.data['tutorId'],
                            ),
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
        if (message.data['navigate'] == "true") {
          if (message.data['route'] == "groupchats") {
            MainApp.navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (_) => FindPage(),
              ),
            );
          } else if (message.data['route'] == "appointment") {
            MainApp.navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (_) => SetSchedule(
                  classId: message.data['classId'],
                  tutorId: message.data['tutorId'],
                ),
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
    String? classId,
    String? tutorId,
  }) async {
    String path;
    String senderId;
    if (AppConfig.environment == Flavors.production) {
      path = 'lib/structure/messaging/ServiceAccountKeyProduction.json';

      senderId = '378925058177';
    } else if (AppConfig.environment == Flavors.staging) {
      path = 'lib/structure/messaging/ServiceAccountKeyStaging.json';
      senderId = '407999311341';
    } else {
      path = 'lib/structure/messaging/ServiceAccountKeyDevelopment.json';
      senderId = '578985333485';
    }

    String credentialsJson = await rootBundle.loadString(path);

    Map<String, dynamic> credentials = json.decode(credentialsJson);
    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(credentials),
      ['https://www.googleapis.com/auth/cloud-platform'],
    );

    final notificationData = {
      'message': {
        'token': recipientToken,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': {
          // Use 'data' instead of 'payload'
          "navigate": "false",
          "route": route,
          'title': title,
          'body': body,
          'classId': classId ?? '',
          'tutorId': tutorId ?? '',
        },
      },
    };

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
