import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shopping_app/repositories/auth_repository.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, User?>((ref) {
  return AuthController(ref)..appStarted();
});

class AuthController extends StateNotifier<User?> {
  final Ref _ref;

  StreamSubscription<User?>? _authStateChangesSubscription;

  AuthController(this._ref) : super(null) {
    _authStateChangesSubscription?.cancel();
    _authStateChangesSubscription = _ref
        .read(authRepositoryProvider)
        .authStateChanges
        .listen((user) => state = user);
  }

  @override
  void dispose() {
    _authStateChangesSubscription?.cancel();
    super.dispose();
  }

  void appStarted() async {
    final user = _ref.read(authRepositoryProvider).getCurrentUser();
    if (user == null) {
      await _ref.read(authRepositoryProvider).signInAnonymously();
    }
  }

  void signOut() async {
    await _ref.read(authRepositoryProvider).signOut();
  }
}
