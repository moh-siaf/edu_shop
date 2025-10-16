// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBnVA_IqOdguG6ewXk5Fymd2WPGszsR7fE', // 🔑 من google-services.json
    appId: '1:585347395751:android:bfb823917247704a942b82', // 🆔 من mobilesdk_app_id
    messagingSenderId: '585347395751', // 💬 من project_number
    projectId: 'edu-shop-app-eb01b', // 🏗️ من project_id
    storageBucket: 'edu-shop-app-eb01b.firebasestorage.app', // ☁️ من storage_bucket
  );


  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'edu-shop-app-eb01b',
    storageBucket: 'edu-shop-app-eb01b.appspot.com',
    iosClientId: 'YOUR_IOS_CLIENT_ID',
    iosBundleId: 'com.example.eduShop',
  );
}
