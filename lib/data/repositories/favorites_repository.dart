import 'package:pokedex_app/data/models/pokemon_model.dart';
import 'package:pokedex_app/data/services/firebase/favorites_service.dart';

class FavoritesRepository {
  final FavoritesService _favoritesService;

  FavoritesRepository({FavoritesService? favoritesService})
      : _favoritesService = favoritesService ?? FavoritesService();

  Future<void> addFavorite(Pokemon pokemon) async {
    try {
      await _favoritesService.addFavorite(pokemon);
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  Future<void> removeFavorite(String pokemonId) async {
    try {
      await _favoritesService.removeFavorite(pokemonId);
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }

  Future<List<Pokemon>> getFavorites() async {
    try {
      return await _favoritesService.getFavorites();
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }

  Stream<List<Pokemon>> favoritesStream() {
    return _favoritesService.favoritesStream();
  }

  Future<bool> isFavorite(String pokemonId) async {
    try {
      return await _favoritesService.isFavorite(pokemonId);
    } catch (e) {
      return false;
    }
  }

  Future<void> clearAllFavorites() async {
    try {
      await _favoritesService.clearAllFavorites();
    } catch (e) {
      throw Exception('Failed to clear favorites: $e');
    }
  }
}
