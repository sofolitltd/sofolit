// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBj0b32QV1o2ZntOASY3o9lQBz4wqqZZnc',
    appId: '1:673196576474:web:e6e9e977a46ca01a069fe3',
    messagingSenderId: '673196576474',
    projectId: 'sofolitbd',
    authDomain: 'sofolitbd.firebaseapp.com',
    storageBucket: 'sofolitbd.appspot.com',
    measurementId: 'G-MG26WSRV9G',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAObUrzKOVwlMA_r_4wR0-TG-7_BEU0M28',
    appId: '1:673196576474:android:350eb2f90e39b67d069fe3',
    messagingSenderId: '673196576474',
    projectId: 'sofolitbd',
    storageBucket: 'sofolitbd.appspot.com',
  );
}