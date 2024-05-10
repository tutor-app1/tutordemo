/* import 'package:test/test.dart';
import 'package:tutorapptrials/pages/sign_in_up.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutorapptrials/pages/auth1_model.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}

Future<void> main() async {
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthManager authManager;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    authManager = AuthManager(auth: mockFirebaseAuth);
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
  });

  test('sign in with email and password - success', () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'test@test.com', password: 'password'))
        .thenAnswer((_) async => mockUserCredential);
    when(mockUserCredential.user).thenReturn(mockUser);

    expect(await authManager.signInWithEmail('test@test.com', 'password'), isA<User>());
  });

  test('sign in with email and password - failure', () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'test@test.com', password: 'password'))
        .thenThrow(FirebaseAuthException(code: 'user-not-found'));

    expect(() async => await authManager.signInWithEmail('test@test.com', 'password'),
        throwsA(isA<AuthException>()));
  });

  test('signOut calls signOut on FirebaseAuth', () async {
    await authManager.signOut();

    verify(mockFirebaseAuth.signOut()).called(1);
  });
} */

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tutorapptrials/pages/auth1_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockAuth extends Mock implements AuthBase {
  @override
  Future<User?> signInWithEmail(String email, String password) => super.noSuchMethod(
    Invocation.method(#signInWithEmail, [email, password]),
    returnValue: Future.value(MockUser()),
  );

  @override
  Future<void> signOut() => super.noSuchMethod(Invocation.method(#signOut, []), returnValue: Future.value());

  @override
  Future<void> resetPassword(String email) => super.noSuchMethod(
    Invocation.method(#resetPassword, [email]),
    returnValue: Future.value(),
  );
}

class MockUser extends Mock implements User {}

void main() {
  late MockAuth mockAuth;
  late AuthManager1 authManager;

  setUp(() {
    mockAuth = MockAuth();
    authManager = AuthManager1(auth: mockAuth);

    when(mockAuth.signOut()).thenAnswer((_) => Future.value());
  });

  test('signInWithEmail calls signInWithEmail on AuthBase', () async {
    // Prepare test data
    String email = 'testEmail';
    String password = 'testPassword';

    // Mocking the signInWithEmail method of AuthBase to return a User object
    when(mockAuth.signInWithEmail(email, password)).thenAnswer((_) => Future.value(MockUser()));

    // Call the signInWithEmail method of authManager with the test email and password and await the result
    final result = await authManager.signInWithEmail(email, password);

    // Verify that the signInWithEmail method of AuthBase was called exactly once with the test email and password
    verify(mockAuth.signInWithEmail(email, password)).called(1);

    // Verify that the result is not null
    expect(result, isNotNull);
    // Optionally, you can further test the returned User object if needed
  });

  test('signOut calls signOut on AuthBase', () async {
    await authManager.signOut();

    verify(mockAuth.signOut()).called(1);
  });

  test('resetPassword calls resetPassword on AuthBase', () async {
    String email = 'testEmail';

    when(mockAuth.resetPassword(email)).thenAnswer((_) => Future.value());

    await authManager.resetPassword(email);

    verify(mockAuth.resetPassword(email)).called(1);
  });
}