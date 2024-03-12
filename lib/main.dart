import 'package:flutter/material.dart';
import 'pages/landing_page.dart';
import 'pages/sign_in_up.dart';
import 'pages/student_UI.dart';
import 'pages/tutor_UI.dart';
import 'pages/tutor_profile.dart';
import 'pages/selection.dart';
import 'pages/forgotpassword.dart';
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
          '/student_UI': (context) => const StudentUIWidget(),
          '/tutor_UI': (context) => const TutorUIWidget(),
          '/tutor_profile': (context) => const TutorProfileWidget(),
          '/selection_ui': (context) => const SelectionWidget(),
          '/forgotpassword': (context) => const ForgotpasswordWidget(),
        });
  }
}
