// lib/firebase_options.dart

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyB8wabRGVSPTvgjA-LZEsIs5Y4E5bnQnyU",
    authDomain: "app-fitness-fb3d8.firebaseapp.com",
    projectId: "app-fitness-fb3d8",
    storageBucket: "app-fitness-fb3d8.firebasestorage.app",
    messagingSenderId: "96178977832",
    appId: "1:96178977832:web:385877ba0e77b1d987491d",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "SUA_CHAVE_ANDROID_SE_NECESSÁRIO",
    appId: "SUA_APP_ID_ANDROID",
    messagingSenderId: "96178977832",
    projectId: "app-fitness-fb3d8",
    storageBucket: "app-fitness-fb3d8.firebasestorage.app",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "SUA_CHAVE_IOS_SE_NECESSÁRIO",
    appId: "SUA_APP_ID_IOS",
    messagingSenderId: "96178977832",
    projectId: "app-fitness-fb3d8",
    storageBucket: "app-fitness-fb3d8.firebasestorage.app",
    iosBundleId: "com.exemplo.ios",
  );

  static const FirebaseOptions macos = ios;
}
