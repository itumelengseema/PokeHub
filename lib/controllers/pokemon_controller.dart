import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/services/api_services.dart';

class PokemonController {
  final ApiServices _apiService;

  PokemonController({ApiServices? apiService})
    : _apiService = apiService ?? ApiServices();

  Future<List<Pokemon>> fetchPokemon(int offset, int limit) async {
    return _apiService.fetchPokemon(offset, limit);
  }
}
