import 'package:flutter/material.dart';
import 'pages/landing_page.dart';
import 'pages/sign_in_up.dart';

void main() {
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
        });
  }
}
