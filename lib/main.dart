import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await initializeFirebase();
    runApp(const SignalCheckApp());
  } catch (_) {
    runApp(
      const SignalCheckApp(
        startupError:
            'Firebase could not start. Check your configuration and restart.',
      ),
    );
  }
}

Future<void> initializeFirebase() async {
  const useEmulators = bool.fromEnvironment(
    'USE_EMULATORS',
    defaultValue: true,
  );
  const demoProject = 'demo-firebase-cloud-quest-cw3';
  const liveProject = String.fromEnvironment('FIREBASE_PROJECT_ID');
  const liveKey = String.fromEnvironment('FIREBASE_API_KEY');
  const liveApp = String.fromEnvironment('FIREBASE_APP_ID');
  const liveSender = String.fromEnvironment('FIREBASE_SENDER_ID');
  if (!useEmulators &&
      [liveProject, liveKey, liveApp, liveSender].contains('')) {
    throw StateError('Missing Firebase client configuration.');
  }
  final platform = kIsWeb
      ? 'web'
      : defaultTargetPlatform == TargetPlatform.android
      ? 'android'
      : 'ios';
  final project = useEmulators ? demoProject : liveProject;
  await Firebase.initializeApp(
    options: FirebaseOptions(
      // The Android SDK validates the format even for an emulator-only key.
      apiKey: useEmulators ? 'AIzaSy'.padRight(39, '0') : liveKey,
      appId: useEmulators ? '1:1234567890:$platform:0123456789abcdef' : liveApp,
      messagingSenderId: useEmulators ? '1234567890' : liveSender,
      projectId: project,
      authDomain: kIsWeb ? '$project.firebaseapp.com' : null,
    ),
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
  );
  if (!useEmulators) return;
  const hostOverride = String.fromEnvironment('EMULATOR_HOST');
  final host = hostOverride.isNotEmpty
      ? hostOverride
      : platform == 'android'
      ? '10.0.2.2'
      : '127.0.0.1';
  await FirebaseAuth.instance.useAuthEmulator(
    host,
    9099,
    automaticHostMapping: false,
  );
  FirebaseFirestore.instance.useFirestoreEmulator(
    host,
    8080,
    automaticHostMapping: false,
  );
  FirebaseFunctions.instance.useFunctionsEmulator(
    host,
    5001,
    automaticHostMapping: false,
  );
}

class SignalCheckApp extends StatelessWidget {
  const SignalCheckApp({super.key, this.startupError});
  final String? startupError;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Signal Check',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff36564c)),
      scaffoldBackgroundColor: const Color(0xfff5f6ef),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    ),
    home: startupError == null
        ? const AuthGate()
        : Scaffold(
            body: SafeArea(child: Center(child: Text(startupError!))),
          ),
  );
}
