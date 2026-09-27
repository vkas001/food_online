import 'package:firebase_auth/firebase_auth.dart';

import 'user_repository.dart';

/// Thin boundary around [FirebaseAuth] + Firestore user profile writes.
///
/// Mirrors the `services/authService.ts` seam — screens never talk to
/// Firebase directly.
class AuthService {
  AuthService({
    FirebaseAuth? firebaseAuth,
    UserRepository? userRepository,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _userRepository = userRepository ?? UserRepository();

  final FirebaseAuth _firebaseAuth;
  final UserRepository _userRepository;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
    required String userId,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userInfoMap = <String, dynamic>{
      "Name": name,
      "Email": email,
      "Id": userId,
    };
    await _userRepository.addUserDetails(userInfoMap, userId);
    return credential;
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() => _firebaseAuth.signOut();
}