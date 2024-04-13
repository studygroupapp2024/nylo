// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC9tuQWbtsheCl_XHEP4YnYqHDSTp1j5HM',
    appId: '1:378925058177:web:f385736808d4335244e580',
    messagingSenderId: '378925058177',
    projectId: 'nylo-c23aa',
    authDomain: 'nylo-c23aa.firebaseapp.com',
    storageBucket: 'nylo-c23aa.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAq0zzPYTD_ScFYdUe8HEkMvgQ3vA3u7Qc',
    appId: '1:378925058177:android:037a5e7330a025f944e580',
    messagingSenderId: '378925058177',
    projectId: 'nylo-c23aa',
    storageBucket: 'nylo-c23aa.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCLmFtxcyGV3bjY6PogWuNsPKOre4NFMGM',
    appId: '1:378925058177:ios:2471a9730e3fd38244e580',
    messagingSenderId: '378925058177',
    projectId: 'nylo-c23aa',
    storageBucket: 'nylo-c23aa.appspot.com',
    iosBundleId: 'com.turnix.nylo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCLmFtxcyGV3bjY6PogWuNsPKOre4NFMGM',
    appId: '1:378925058177:ios:2471a9730e3fd38244e580',
    messagingSenderId: '378925058177',
    projectId: 'nylo-c23aa',
    storageBucket: 'nylo-c23aa.appspot.com',
    iosBundleId: 'com.turnix.nylo',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC9tuQWbtsheCl_XHEP4YnYqHDSTp1j5HM',
    appId: '1:378925058177:web:1f39a192fa03dd5644e580',
    messagingSenderId: '378925058177',
    projectId: 'nylo-c23aa',
    authDomain: 'nylo-c23aa.firebaseapp.com',
    storageBucket: 'nylo-c23aa.appspot.com',
  );
}
