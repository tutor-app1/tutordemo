import 'package:flutter/material.dart';
import 'pages/landing_page.dart';
import 'pages/sign_in_up.dart';
import 'pages/studentUI_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Tutor App',
        home: const Onboarding1Widget(),
        routes: {
          '/landing_page': (context) => const Onboarding1Widget(),
          '/auth': (context) => const Auth1Widget(),
          '/studentUI_page': (context) => const StudentUIpageWidget(),
        });
  }
}
