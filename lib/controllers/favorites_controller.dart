import 'package:flutter/material.dart';
import 'package:pokedex_app/models/pokemon.dart';

class FavoritesController extends ChangeNotifier {
  final List<Pokemon> _favorites = [];

  List<Pokemon> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(Pokemon pokemon) {
    return _favorites.contains(pokemon);
  }

  void toggleFavorite(Pokemon pokemon) {
    if (isFavorite(pokemon)) {
      _favorites.remove(pokemon);
    } else {
      _favorites.add(pokemon);
    }
    notifyListeners();
  }

  void addFavorite(Pokemon pokemon) {
    if (!isFavorite(pokemon)) {
      _favorites.add(pokemon);
      notifyListeners();
    }
  }

  void removeFavorite(Pokemon pokemon) {
    _favorites.remove(pokemon);
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
