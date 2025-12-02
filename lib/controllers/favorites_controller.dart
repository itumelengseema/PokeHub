import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/services/i_favorites_service.dart';


class FavoritesController extends ChangeNotifier {
  final IFavoritesService _favoritesService;
  final List<Pokemon> _favorites = [];
  bool _isLoading = false;

  FavoritesController(this._favoritesService) {
    _loadFavorites();
  }

  List<Pokemon> get favorites => List.unmodifiable(_favorites);
  bool get isLoading => _isLoading;


  Future<void> _loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final loadedFavorites = await _favoritesService.getFavorites();
      _favorites.clear();
      _favorites.addAll(loadedFavorites);
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

 
  Future<void> reloadFavorites() async {
    await _loadFavorites();
  }

  bool isFavorite(Pokemon pokemon) {
    return _favorites.contains(pokemon);
  }

  Future<void> toggleFavorite(Pokemon pokemon) async {
    if (isFavorite(pokemon)) {
      await removeFavorite(pokemon);
    } else {
      await addFavorite(pokemon);
    }
  }

  Future<void> addFavorite(Pokemon pokemon) async {
    if (!isFavorite(pokemon)) {
      _favorites.add(pokemon);
      notifyListeners();

      try {
        await _favoritesService.addFavorite(pokemon);
      } catch (e) {
        debugPrint('Error adding favorite to Firestore: $e');
       
        _favorites.remove(pokemon);
        notifyListeners();
        rethrow;
      }
    }
  }

  Future<void> removeFavorite(Pokemon pokemon) async {
    _favorites.remove(pokemon);
    notifyListeners();

    try {
      await _favoritesService.removeFavorite(pokemon.id);
    } catch (e) {
      debugPrint('Error removing favorite from Firestore: $e');
      
      _favorites.add(pokemon);
      notifyListeners();
      rethrow;
    }
  }

  
  Future<void> clearFavorites() async {
    _favorites.clear();
    notifyListeners();
  }

  List<Pokemon> searchFavorites(String query) {
    if (query.isEmpty) return favorites;

    final lowerQuery = query.toLowerCase();
    return _favorites.where((pokemon) {
      final name = pokemon.name.toLowerCase();
      final id = pokemon.id;
      return name.contains(lowerQuery) || id.contains(lowerQuery);
    }).toList();
  }
}
