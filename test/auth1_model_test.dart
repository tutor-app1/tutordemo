import 'package:test/test.dart';
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
}