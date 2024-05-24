import 'package:flutter/material.dart';
import 'pages/landing_page.dart';
import 'pages/sign_in_up.dart';
import 'pages/student_UI.dart';
import 'pages/tutor_UI.dart';
import 'pages/tutor_profile.dart';
import 'pages/student_personal_profile.dart';
import 'pages/chat.dart';
import 'pages/tutor_personal_profile.dart';
import 'pages/chat_screen.dart';
import 'pages/forgotpassword.dart';
import 'pages/availability.dart';
import 'pages/review_creation.dart';
import 'pages/review_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<Widget> getStartPage(User user) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    var doc = await _firestore.collection('student').doc(user.uid).get();

    if (doc.exists) {
      return const StudentUIWidget();
    } else {
      return const TutorUIWidget();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tutor App',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading spinner while waiting
          } else {
            if (snapshot.hasData) {
              return FutureBuilder<Widget>(
                future: getStartPage(snapshot.data!),
                builder:
                    (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return snapshot.data!;
                  }
                },
              );
            } else {
              return const Onboarding1Widget(); // If no user is signed in, show the landing page
            }
          }
        },
      ),
      routes: {
        '/landing_page': (context) => const Onboarding1Widget(),
        '/auth': (context) => const Auth1Widget(),
        '/student_UI': (context) => const StudentUIWidget(),
        '/forgot_password': (context) => const ForgotpasswordWidget(),
        '/availability': (context) => const AvailabilityWidget(),
        '/student_personal_profile': (context) => const StudentPersonalProfileWidget(),
        '/chat': (context) => const ChatWidget(),
        '/tutor_UI': (context) => const TutorUIWidget(),
        '/review_page': (context) => const ReviewPageWidget(),
        '/tutor_profile': (context) => const TutorProfileWidget(),
        '/tutor_personal_profile': (context) => const TutorPersonalProfileWidget(),
        '/review_creation': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return ReviewCreationWidget(
            key: const ValueKey('review_creation'),
            otherUserId: args['otherUserId']!,
            tutorId: args['tutorId']!,
          );
        },
        '/chat_screen': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return ChatScreenWidget(
            key: const ValueKey('chat_screen'),
            otherUserId: args['otherUserId']!,
            conversationId: args['conversationId']!,
            tutorId: args['tutorId']!,
          );
        },
      },
    );
  }
}
