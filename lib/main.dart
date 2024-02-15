import 'package:flutter/material.dart';
import 'pages/landing_page.dart';

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
        home: const landing_page(),
        routes: {'pages/landing_page.dart': (context) => const landing_page()});
  }
}
