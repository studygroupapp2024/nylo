import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/firebase/prod/firebase_options-prod.dart';
import 'package:nylo/structure/auth/auth_gate.dart';
import 'package:nylo/structure/messaging/message_api.dart';
import 'package:nylo/themes/light_mode.dart';

@pragma('vm:entry-point')
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'nylo-c23aa',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Firebase.initializeApp();

  await FirebaseMessage().initNotifications();

  // Set the system navigation bar color here
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: const AuthGate(),
      theme: lightMode,
    );
  }
}
