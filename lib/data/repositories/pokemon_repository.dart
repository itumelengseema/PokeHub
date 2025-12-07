import 'package:pokedex_app/data/models/pokemon_model.dart';
import 'package:pokedex_app/data/models/pokemon_detail_model.dart';
import 'package:pokedex_app/data/services/api/pokemon_api_service.dart';
import 'package:pokedex_app/data/services/local/cache_service.dart';

class PokemonRepository {
  final PokemonApiService _apiService;
  final CacheService _cacheService;

  PokemonRepository({
    PokemonApiService? apiService,
    CacheService? cacheService,
  })  : _apiService = apiService ?? PokemonApiService(),
        _cacheService = cacheService ?? CacheService();

  Future<List<Pokemon>> fetchPokemonList(int offset, int limit) async {
    try {
      return await _apiService.fetchPokemonList(offset, limit);
    } catch (e) {
      throw Exception('Failed to fetch Pokemon list: $e');
    }
  }

  Future<PokemonDetail> fetchPokemonDetail(String url) async {
    try {
      // Check cache first
      final cached = _cacheService.getDetailFromCache(url);
      if (cached != null) {
        return cached;
      }

      // Fetch from API
      final detail = await _apiService.fetchPokemonDetail(url);

      // Cache the result
      _cacheService.cacheDetail(url, detail);

      return detail;
    } catch (e) {
      throw Exception('Failed to fetch Pokemon detail: $e');
    }
  }

  Future<void> prefetchPokemonDetails(List<Pokemon> pokemonList) async {
    final futures = pokemonList.map((pokemon) async {
      if (!_cacheService.hasDetailInCache(pokemon.url)) {
        try {
          await fetchPokemonDetail(pokemon.url);
        } catch (e) {
          // Silently fail for prefetch
        }
      }
    }).toList();

    await Future.wait(futures);
  }

  Future<EvolutionChain> fetchEvolutionChain(String speciesUrl) async {
    try {
      // Check cache first
      final cached = _cacheService.getEvolutionFromCache(speciesUrl);
      if (cached != null) {
        return cached;
      }

      // Fetch from API
      final chain = await _apiService.fetchEvolutionChain(speciesUrl);

      // Cache the result
      _cacheService.cacheEvolution(speciesUrl, chain);

      return chain;
    } catch (e) {
      throw Exception('Failed to fetch evolution chain: $e');
    }
  }

  void clearCache() {
    _cacheService.clearCache();
  }
}
