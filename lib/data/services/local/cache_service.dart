import 'package:pokedex_app/data/models/pokemon_detail_model.dart';

class CacheService {
  final Map<String, PokemonDetail> _detailCache = {};
  final Map<String, EvolutionChain> _evolutionCache = {};

  // Pokemon Detail Cache
  PokemonDetail? getDetailFromCache(String url) {
    return _detailCache[url];
  }

  void cacheDetail(String url, PokemonDetail detail) {
    _detailCache[url] = detail;
  }

  bool hasDetailInCache(String url) {
    return _detailCache.containsKey(url);
  }

  // Evolution Chain Cache
  EvolutionChain? getEvolutionFromCache(String speciesUrl) {
    return _evolutionCache[speciesUrl];
  }

  void cacheEvolution(String speciesUrl, EvolutionChain chain) {
    _evolutionCache[speciesUrl] = chain;
  }

  bool hasEvolutionInCache(String speciesUrl) {
    return _evolutionCache.containsKey(speciesUrl);
  }

  // Clear Cache
  void clearCache() {
    _detailCache.clear();
    _evolutionCache.clear();
  }

  void clearDetailCache() {
    _detailCache.clear();
  }

  void clearEvolutionCache() {
    _evolutionCache.clear();
  }
}
