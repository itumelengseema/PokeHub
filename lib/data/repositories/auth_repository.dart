import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokedex_app/data/services/firebase/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  Future<User?> signUp(String email, String password, String name) async {
    try {
      return await _authService.signUp(email, password, name);
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      return await _authService.signIn(email, password);
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      return await _authService.signInWithGoogle();
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  Stream<User?> get userStream => _authService.userStream;

  User? get currentUser => _authService.currentUser;
}
