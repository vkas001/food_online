import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';
import '../services/user_preferences.dart';

/// Session gate for the app.
///
/// Mirrors the iBIZ `AuthContext`: owns the login state, a "restoring" flag
/// while prefs/current-user are loading, and an `onboarded` flag that gates the
/// onboarding screen. The router's redirect reads this provider.
class AuthProvider extends ChangeNotifier {
  AuthProvider({
    required AuthService authService,
    UserPreferences? preferences,
  })  : _authService = authService,
        _preferences = preferences ?? UserPreferences() {
    _restoring = true;
    _init();
  }

  final AuthService _authService;
  final UserPreferences _preferences;

  StreamSubscription<User?>? _authSubscription;

  User? _user;
  String? _displayName;
  String? _displayEmail;
  bool _restoring = true;
  bool _onboarded = false;

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get restoring => _restoring;
  bool get onboarded => _onboarded;
  String? get displayName => _displayName;
  String? get displayEmail => _displayEmail;

  Future<void> _init() async {
    _onboarded = await _preferences.getOnboarded();
    final current = _authService.currentUser;
    if (current != null) {
      await _loadProfile();
    }
    _restoring = false;
    notifyListeners();

    _authSubscription ??= _authService.authStateChanges().listen((user) async {
      _user = user;
      if (user != null) {
        await _loadProfile();
      } else {
        _displayName = null;
        _displayEmail = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadProfile() async {
    _displayName = await _preferences.getUserName();
    _displayEmail = await _preferences.getUserEmail();
  }

  Future<void> completeOnboarding() async {
    _onboarded = true;
    await _preferences.saveOnboarded(true);
    notifyListeners();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String userId,
  }) async {
    await _authService.signUp(
      name: name,
      email: email,
      password: password,
      userId: userId,
    );
    await _preferences.saveUserName(name);
    await _preferences.saveUserEmail(email);
  }

  Future<void> signIn({required String email, required String password}) async {
    await _authService.signIn(email: email, password: password);
    await _preferences.saveUserEmail(email);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}