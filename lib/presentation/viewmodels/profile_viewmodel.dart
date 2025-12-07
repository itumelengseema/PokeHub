import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:pokedex_app/data/models/user_profile_model.dart';

enum ProfileViewState { initial, loading, loaded, error }

class ProfileViewModel extends ChangeNotifier {
  final User? user;

  ProfileViewModel({required this.user});

  // State
  ProfileViewState _state = ProfileViewState.initial;
  UserProfile? _userProfile;
  String? _errorMessage;

  // Getters
  ProfileViewState get state => _state;
  UserProfile? get userProfile => _userProfile;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == ProfileViewState.loading;

  // Load user profile
  Future<void> loadUserProfile() async {
    if (user == null) {
      _state = ProfileViewState.error;
      _errorMessage = 'No user logged in';
      notifyListeners();
      return;
    }

    _state = ProfileViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Create user profile from Firebase User
      _userProfile = UserProfile(
        name: user!.displayName ?? 'Pokémon Trainer',
        email: user!.email ?? '',
        profileImageUrl: user!.photoURL,
        bio: null,
        joinedDate: user!.metadata.creationTime ?? DateTime.now(),
      );

      _state = ProfileViewState.loaded;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = ProfileViewState.error;
      notifyListeners();
    }
  }

  // Get formatted join date
  String getFormattedJoinDate() {
    if (_userProfile == null) return '';

    final date = _userProfile!.joinedDate;
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    return '${months[date.month - 1]} ${date.year}';
  }

  // Get user initials
  String getUserInitials() {
    if (_userProfile == null) return 'PT';

    final nameParts = _userProfile!.name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return _userProfile!.name.substring(0, 2).toUpperCase();
  }

  // Refresh profile
  Future<void> refresh() async {
    await loadUserProfile();
  }
}
