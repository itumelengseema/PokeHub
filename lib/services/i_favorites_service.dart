import 'package:pokedex_app/models/pokemon.dart';


abstract class IFavoritesService {
  Future<void> addFavorite(Pokemon pokemon);
  Future<void> removeFavorite(String pokemonId);
  Future<List<Pokemon>> getFavorites();
  Stream<List<Pokemon>> favoritesStream();
  Future<bool> isFavorite(String pokemonId);
  Future<void> clearAllFavorites();
}
