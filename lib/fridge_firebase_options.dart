// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

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
class FridgeFirebaseOptions {
  static String get name => 'fridge';

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return _web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions _web = FirebaseOptions(
    apiKey: String.fromEnvironment('FRIDGE_FIREBASE_WEB_KEY'),
    appId: '1:581070356908:web:a92bd1d491fc5a04d4ba09',
    messagingSenderId: '581070356908',
    projectId: 'monfrigo-1b428',
    authDomain: 'monfrigo-1b428.firebaseapp.com',
    storageBucket: 'monfrigo-1b428.appspot.com',
  );

  static const FirebaseOptions _android = FirebaseOptions(
    apiKey: String.fromEnvironment('FRIDGE_FIREBASE_ANDROID_KEY'),
    appId: '1:581070356908:android:312584a8de5b155fd4ba09',
    messagingSenderId: '581070356908',
    projectId: 'monfrigo-1b428',
    storageBucket: 'monfrigo-1b428.appspot.com',
  );
}
