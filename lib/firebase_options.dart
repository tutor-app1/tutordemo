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
    apiKey: 'AIzaSyCkxtKNcWBXafXCv4FWzLXiAeJ6zgd0z_g',
    appId: '1:29521760363:web:4846b048868758e52ba12e',
    messagingSenderId: '29521760363',
    projectId: 'tutor-app-aa096',
    authDomain: 'tutor-app-aa096.firebaseapp.com',
    databaseURL: 'https://tutor-app-aa096-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'tutor-app-aa096.appspot.com',
    measurementId: 'G-EFR1Z25D6K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCiY8KYrPO8fIElBv7YRiwGvP_tyQ0UrM0',
    appId: '1:29521760363:android:a3d1a8bc67f795972ba12e',
    messagingSenderId: '29521760363',
    projectId: 'tutor-app-aa096',
    databaseURL: 'https://tutor-app-aa096-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'tutor-app-aa096.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB79kVKy64-mNilKKVSFYQ93UJsJJXHYSc',
    appId: '1:29521760363:ios:ad132e7af976613a2ba12e',
    messagingSenderId: '29521760363',
    projectId: 'tutor-app-aa096',
    databaseURL: 'https://tutor-app-aa096-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'tutor-app-aa096.appspot.com',
    iosBundleId: 'com.flutterapp.tutorapptrials',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB79kVKy64-mNilKKVSFYQ93UJsJJXHYSc',
    appId: '1:29521760363:ios:8ed585151dfcccb62ba12e',
    messagingSenderId: '29521760363',
    projectId: 'tutor-app-aa096',
    databaseURL: 'https://tutor-app-aa096-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'tutor-app-aa096.appspot.com',
    iosBundleId: 'com.flutterapp.tutorapptrials.RunnerTests',
  );
}
