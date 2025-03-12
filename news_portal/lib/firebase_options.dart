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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyByWKOiPDwsrqeIaovlvJZII7DVO48xYB4',
    appId: '1:657194578963:web:3c51d587c774dcc69efbe6',
    messagingSenderId: '657194578963',
    projectId: 'newsportal-3c06e',
    authDomain: 'newsportal-3c06e.firebaseapp.com',
    storageBucket: 'newsportal-3c06e.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCJuNZgiHyId-fuYBzng9BQZmDg0wC6dKg',
    appId: '1:657194578963:android:75400412bf6af2d49efbe6',
    messagingSenderId: '657194578963',
    projectId: 'newsportal-3c06e',
    storageBucket: 'newsportal-3c06e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAEOo6Jwt7tlUyJcCvKQYfNTtdscPWE7C0',
    appId: '1:657194578963:ios:b9685d02e47b612b9efbe6',
    messagingSenderId: '657194578963',
    projectId: 'newsportal-3c06e',
    storageBucket: 'newsportal-3c06e.firebasestorage.app',
    iosBundleId: 'com.example.newsPortal',
  );

}