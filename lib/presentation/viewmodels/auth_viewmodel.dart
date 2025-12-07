import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:pokedex_app/data/repositories/auth_repository.dart';

enum AuthViewState { initial, loading, authenticated, unauthenticated, error }

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository() {
    _listenToAuthChanges();
  }

  // State
  AuthViewState _state = AuthViewState.initial;
  User? _currentUser;
  String? _errorMessage;

  // Getters
  AuthViewState get state => _state;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == AuthViewState.loading;
  bool get isAuthenticated => _state == AuthViewState.authenticated;

  // Listen to auth state changes
  void _listenToAuthChanges() {
    _authRepository.userStream.listen(
      (user) {
        _currentUser = user;
        if (user != null) {
          _state = AuthViewState.authenticated;
        } else {
          _state = AuthViewState.unauthenticated;
        }
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        _state = AuthViewState.error;
        notifyListeners();
      },
    );
  }

  // Sign up
  Future<bool> signUp(String email, String password, String name) async {
    if (_state == AuthViewState.loading) return false;

    _state = AuthViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authRepository.signUp(email, password, name);
      if (user != null) {
        _currentUser = user;
        _state = AuthViewState.authenticated;
        notifyListeners();
        return true;
      }
      _state = AuthViewState.unauthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = _getReadableError(e);
      _state = AuthViewState.error;
      notifyListeners();
      return false;
    }
  }

  // Sign in
  Future<bool> signIn(String email, String password) async {
    if (_state == AuthViewState.loading) return false;

    _state = AuthViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authRepository.signIn(email, password);
      if (user != null) {
        _currentUser = user;
        _state = AuthViewState.authenticated;
        notifyListeners();
        return true;
      }
      _state = AuthViewState.unauthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = _getReadableError(e);
      _state = AuthViewState.error;
      notifyListeners();
      return false;
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    if (_state == AuthViewState.loading) return false;

    _state = AuthViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        _currentUser = user;
        _state = AuthViewState.authenticated;
        notifyListeners();
        return true;
      }
      _state = AuthViewState.unauthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = _getReadableError(e);
      _state = AuthViewState.error;
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      _currentUser = null;
      _state = AuthViewState.unauthenticated;
      notifyListeners();
    } catch (e) {
      _errorMessage = _getReadableError(e);
      _state = AuthViewState.error;
      notifyListeners();
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    if (_state == AuthViewState.loading) return false;

    _state = AuthViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.resetPassword(email);
      _state = AuthViewState.unauthenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _getReadableError(e);
      _state = AuthViewState.error;
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_state == AuthViewState.error) {
      _state = _currentUser != null
          ? AuthViewState.authenticated
          : AuthViewState.unauthenticated;
    }
    notifyListeners();
  }

  // Get readable error message
  String _getReadableError(dynamic error) {
    final errorString = error.toString();

    if (errorString.contains('user-not-found')) {
      return 'No user found with this email';
    } else if (errorString.contains('wrong-password')) {
      return 'Incorrect password';
    } else if (errorString.contains('email-already-in-use')) {
      return 'An account already exists with this email';
    } else if (errorString.contains('weak-password')) {
      return 'Password is too weak';
    } else if (errorString.contains('invalid-email')) {
      return 'Invalid email address';
    } else if (errorString.contains('network-request-failed')) {
      return 'Network error. Please check your connection';
    } else if (errorString.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later';
    }

    return 'An error occurred. Please try again';
  }
}
