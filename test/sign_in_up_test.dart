import 'package:test/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' as test;
import 'package:firebase_core/firebase_core.dart';
import 'package:tutorapptrials/pages/sign_in_up.dart';
import 'package:tutorapptrials/pages/selection.dart';
//import 'package:tutorapptrials/pages/auth1_model.dart'; 

void main () {
   setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });
  test.testWidgets('After signing up, user is moved to the next page', (test.WidgetTester tester) async {
    // Build the MaterialApp with the SignInUp page as the home page
    await tester.pumpWidget(const MaterialApp(
      home: Auth1Widget(),
    ));

    // Fill in the sign up form
    final usernameField = test.find.byKey(const Key('usernameField'));
    final emailField = test.find.byKey(const Key('emailField'));
    final passwordField = test.find.byKey(const Key('passwordField'));
    final confirmPasswordField = test.find.byKey(const Key('confirmPasswordField'));
    await tester.enterText(usernameField, 'testUsername');
    await tester.enterText(emailField, 'test@email.com');
    await tester.enterText(passwordField, 'testPassword');
    await tester.enterText(confirmPasswordField, 'testPassword');

    // Tap the sign up button
    final signUpButton = test.find.text('Create Account');
    await tester.tap(signUpButton);

    // Run the tasks that are queued in the event loop
    await tester.pumpAndSettle();

    // Verify that the current page is the next page
    expect(test.find.byType(SelectionWidget), test.findsOneWidget); 
  });
}
