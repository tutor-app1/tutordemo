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
  Future<UserCredential?> createAccountWithEmail(String username, String email, String password, String subject, String role, String educationlevel) {
    return super.noSuchMethod(
      Invocation.method(#createAccountWithEmail, [username, email, password, subject, role, educationlevel]),
      returnValue: Future.value(MockUserCredential()),
    );
  }

  @override
  Future<void> signOut() => super.noSuchMethod(Invocation.method(#signOut, []), returnValue: Future.value());

  @override
  Future<void> resetPassword(String email) => super.noSuchMethod(
    Invocation.method(#resetPassword, [email]),
    returnValue: Future.value(),
  );
}

class MockUser extends Mock implements User {}
class MockUserCredential extends Mock implements UserCredential {}

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
  });

  test('createAccountWithEmail calls createAccountWithEmail on AuthBase', () async {
    // Prepare test data
    String username = 'testUser';
    String email = 'testEmail';
    String password = 'testPassword';
    String subject = 'testSubject';
    String role = 'testRole';
    String educationLevel = 'testEducationLevel';

    // Mocking the createAccountWithEmail method of AuthBase to return a UserCredential object
    when(mockAuth.createAccountWithEmail(username, email, password, subject, role, educationLevel))
        .thenAnswer((_) => Future.value(MockUserCredential()));

    // Call the createAccountWithEmail method of authManager with the test data and await the result
    final result = await authManager.createAccountWithEmail(
      username,
      email,
      password,
      subject,
      role,
      educationLevel,
    );

    // Verify that the createAccountWithEmail method of AuthBase was called exactly once with the test data
    verify(mockAuth.createAccountWithEmail(username, email, password, subject, role, educationLevel)).called(1);

    // Verify that the result is not null
    expect(result, isNotNull);
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