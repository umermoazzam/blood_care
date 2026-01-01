import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBGIm-iScn76CbDNtpFkGe2iLGSjPC-Xag',
    appId: '1:241745573264:web:c957e22339bccf221f6f15',
    messagingSenderId: '241745573264',
    projectId: 'blooddonationapp-11964',
    authDomain: 'blooddonationapp-11964.firebaseapp.com',
    storageBucket: 'blooddonationapp-11964.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDGuXiOBJTWH-rVcEzwq4_3OFU4TsJ8cMQ',
    appId: '1:241745573264:android:6cd3c5ac85d8cc701f6f15',
    messagingSenderId: '241745573264',
    projectId: 'blooddonationapp-11964',
    storageBucket: 'blooddonationapp-11964.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDCsjPyPCyZ6HbcQuLx19Rwv7NpuDbm5JE',
    appId: '1:241745573264:ios:d37c8e7a9e82166e1f6f15',
    messagingSenderId: '241745573264',
    projectId: 'blooddonationapp-11964',
    storageBucket: 'blooddonationapp-11964.firebasestorage.app',
    iosBundleId: 'com.example.bloodCare',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDCsjPyPCyZ6HbcQuLx19Rwv7NpuDbm5JE',
    appId: '1:241745573264:ios:d37c8e7a9e82166e1f6f15',
    messagingSenderId: '241745573264',
    projectId: 'blooddonationapp-11964',
    storageBucket: 'blooddonationapp-11964.firebasestorage.app',
    iosBundleId: 'com.example.bloodCare',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBGIm-iScn76CbDNtpFkGe2iLGSjPC-Xag',
    appId: '1:241745573264:web:a04d351c9924dab81f6f15',
    messagingSenderId: '241745573264',
    projectId: 'blooddonationapp-11964',
    authDomain: 'blooddonationapp-11964.firebaseapp.com',
    storageBucket: 'blooddonationapp-11964.firebasestorage.app',
  );
}
