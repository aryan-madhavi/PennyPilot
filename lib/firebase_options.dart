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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyApjCFBKNtb6bjoARcIZjObzf2fuB11BqI',
    appId: '1:852999262790:android:b23a649c491b107ada3047',
    messagingSenderId: '852999262790',
    projectId: 'penny-piolet-mjf0fo',
    storageBucket: 'penny-piolet-mjf0fo.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDjBldVflkmu0n98V5ATcqVM9Sp5DZQzEk',
    appId: '1:852999262790:ios:5dec801a7f83aa7bda3047',
    messagingSenderId: '852999262790',
    projectId: 'penny-piolet-mjf0fo',
    storageBucket: 'penny-piolet-mjf0fo.firebasestorage.app',
    androidClientId: '852999262790-2khl51v8jmg26pb8lnnpkm8cj336imiv.apps.googleusercontent.com',
    iosClientId: '852999262790-vhrth1e5cej2out6r7boip92omn7iseo.apps.googleusercontent.com',
    iosBundleId: 'com.example.pennyPilot',
  );
}