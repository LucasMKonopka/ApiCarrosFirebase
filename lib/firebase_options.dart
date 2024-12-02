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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyATa0RzYZaYMYr2ufGe3N0ZTEY4RFflZ5Y',
    appId: '1:914160398753:web:10020f5b0e3b4b86ee1be0',
    messagingSenderId: '914160398753',
    projectId: 'trabalho4-943cf',
    authDomain: 'trabalho4-943cf.firebaseapp.com',
    storageBucket: 'trabalho4-943cf.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDSqXf7MgRQKYBVKTIh_CP-mMI0KBFHVrg',
    appId: '1:914160398753:android:556641a18f580a8cee1be0',
    messagingSenderId: '914160398753',
    projectId: 'trabalho4-943cf',
    storageBucket: 'trabalho4-943cf.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCYbnH6uXTrjrjqPrPx2NEfwKS5nMuQcdw',
    appId: '1:914160398753:ios:6e7d2acee14916bbee1be0',
    messagingSenderId: '914160398753',
    projectId: 'trabalho4-943cf',
    storageBucket: 'trabalho4-943cf.firebasestorage.app',
    iosBundleId: 'com.example.trabalho4',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCYbnH6uXTrjrjqPrPx2NEfwKS5nMuQcdw',
    appId: '1:914160398753:ios:6e7d2acee14916bbee1be0',
    messagingSenderId: '914160398753',
    projectId: 'trabalho4-943cf',
    storageBucket: 'trabalho4-943cf.firebasestorage.app',
    iosBundleId: 'com.example.trabalho4',
  );
}