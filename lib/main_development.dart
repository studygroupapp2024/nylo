import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/appconfig.dart';
import 'package:nylo/firebase/dev/firebase_options-dev.dart';
import 'package:nylo/structure/auth/auth_gate.dart';
import 'package:nylo/structure/messaging/message_api.dart';
import 'package:nylo/themes/light_mode.dart';

class AppConfig {
  static const Environment currentEnvironment = Environment.development;
}

@pragma('vm:entry-point')
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: "nylo-dev",
  );

  await Firebase.initializeApp();

  await FirebaseMessage().initNotifications();

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
      // routerConfig: router,
      home: const AuthGate(),
      theme: lightMode,
    );
  }
}
