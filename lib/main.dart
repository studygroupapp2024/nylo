import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nylo/firebase_options.dart';
import 'package:nylo/structure/auth/auth_gate.dart';
import 'package:nylo/structure/messaging/message_api.dart';
import 'package:nylo/themes/light_mode.dart';

@pragma('vm:entry-point')
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Firebase.initializeApp();
  // await FirebaseAppCheck.instance.activate(
  //   webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),

  //   androidProvider: AndroidProvider.debug,

  //   //appleProvider: AppleProvider.appAttest,
  // );
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
      // routerConfig: router,
      home: const AuthGate(),
      theme: lightMode,
    );
  }
}

// final router = GoRouter(
//   routes: [
//     GoRoute(
//       path: '/',
//       builder: (
//         context,
//         state,
//       ) =>
//           const AuthGate(),
//     ),
//   ],
// );

// import 'package:firebase_messaging/firebase_messaging.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   // Initialize Firebase
//   await Firebase.initializeApp();

//   // Get the initial message if the app was opened via a notification while terminated
//   RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

//   // Process the initial message if it exists
//   if (initialMessage != null) {
//     print('Received initial message: $initialMessage');
//     // Handle the initial message as needed
//     handleInitialMessage(initialMessage);
//   }

//   // Run the app
//   runApp(MyApp());
// }

// void handleInitialMessage(RemoteMessage message) {
//   // Handle the initial message here, for example, show a dialog or navigate to a specific screen
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'My App',
//       home: MyHomePage(),
//     );
//   }
// }