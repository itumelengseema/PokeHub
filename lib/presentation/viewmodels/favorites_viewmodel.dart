import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';
import 'package:pokedex_app/data/repositories/favorites_repository.dart';

enum FavoritesViewState { initial, loading, loaded, error }

class FavoritesViewModel extends ChangeNotifier {
  final FavoritesRepository _favoritesRepository;
  StreamSubscription<List<Pokemon>>? _favoritesSubscription;

  FavoritesViewModel({FavoritesRepository? favoritesRepository})
      : _favoritesRepository = favoritesRepository ?? FavoritesRepository() {
    _listenToFavorites();
  }

  // State
  FavoritesViewState _state = FavoritesViewState.initial;
  List<Pokemon> _allFavorites = [];
  List<Pokemon> _filteredFavorites = [];
  String _searchQuery = '';
  String? _errorMessage;

  // Getters
  FavoritesViewState get state => _state;
  List<Pokemon> get favorites => _filteredFavorites;
  String get searchQuery => _searchQuery;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == FavoritesViewState.loading;
  bool get isEmpty => _filteredFavorites.isEmpty && _searchQuery.isEmpty;

  // Listen to favorites stream
  void _listenToFavorites() {
    // Cancel existing subscription if any
    _favoritesSubscription?.cancel();

    _favoritesSubscription = _favoritesRepository.favoritesStream().listen(
      (favorites) {
        _allFavorites = favorites;
        _applyFilters();
        if (_state == FavoritesViewState.initial) {
          _state = FavoritesViewState.loaded;
        }
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        _state = FavoritesViewState.error;
        notifyListeners();
      },
    );
  }

  // Reinitialize favorites for new user
  void reinitialize() {
    _allFavorites = [];
    _filteredFavorites = [];
    _searchQuery = '';
    _errorMessage = null;
    _state = FavoritesViewState.initial;
    _listenToFavorites();
    notifyListeners();
  }

  // Load favorites
  Future<void> loadFavorites() async {
    _state = FavoritesViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _allFavorites = await _favoritesRepository.getFavorites();
      _applyFilters();
      _state = FavoritesViewState.loaded;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = FavoritesViewState.error;
      notifyListeners();
    }
  }

  // Add favorite
  Future<void> addFavorite(Pokemon pokemon) async {
    try {
      await _favoritesRepository.addFavorite(pokemon);
      // Stream will update automatically
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Remove favorite
  Future<void> removeFavorite(String pokemonId) async {
    try {
      await _favoritesRepository.removeFavorite(pokemonId);
      // Stream will update automatically
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Check if Pokemon is favorite
  Future<bool> isFavorite(String pokemonId) async {
    return await _favoritesRepository.isFavorite(pokemonId);
  }

  // Toggle favorite
  Future<void> toggleFavorite(Pokemon pokemon) async {
    final isFav = await isFavorite(pokemon.id);
    if (isFav) {
      await removeFavorite(pokemon.id);
    } else {
      await addFavorite(pokemon);
    }
  }

  // Search favorites
  void searchFavorites(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  // Apply filters
  void _applyFilters() {
    _filteredFavorites = _allFavorites.where((pokemon) {
      return _searchQuery.isEmpty ||
          pokemon.name.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    try {
      await _favoritesRepository.clearAllFavorites();
      // Stream will update automatically
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Reset search
  void resetSearch() {
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }

  @override
  void dispose() {
    _favoritesSubscription?.cancel();
    super.dispose();
  }
}
