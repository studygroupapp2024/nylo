import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/config/app_config.dart';
import 'package:nylo/config/app_environments.dart';
import 'package:nylo/dependency_injection.dart';
import 'package:nylo/firebase/development/firebase_options-dev.dart';
import 'package:nylo/structure/auth/auth_gate.dart';
import 'package:nylo/structure/messaging/message_api.dart';
import 'package:nylo/themes/light_mode.dart';

@pragma('vm:entry-point')
void main() async {
  AppConfig.setEnvironment(Flavors.development);
  DependencyInjection.init();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "nylo-dev",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug, //.playIntegrity,
  );

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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      // routerConfig: router,
      home: const AuthGate(),
      theme: lightMode,
    );
  }
}
