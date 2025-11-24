import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/models/pokemon_detail.dart';

class ApiServices {
  static const String baseUrl = 'https://pokeapi.co/api/v2/pokemon/';

  // Cache for Pokemon details
  static final Map<String, PokemonDetail> _detailCache = {};
  static final Map<String, EvolutionChain> _evolutionCache = {};

  Future<List<Pokemon>> fetchPokemon(int offset, int limit) async {
    limit = 30;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?offset=$offset&limit=$limit'),
      );

      if (response.statusCode != 200) throw Exception('Failed to load Pokemon');

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;

      final futures = results.map((item) async {
        final url = item['url'] as String;
        try {
          final pokemonResponse = await http.get(Uri.parse(url));
          if (pokemonResponse.statusCode == 200) {
            final detailData =
                jsonDecode(pokemonResponse.body) as Map<String, dynamic>;
            final name = detailData['name'] as String;

            final imageUrl =
                detailData['sprites']?['other']?['official-artwork']?['front_default']
                    as String?;
            return Pokemon(name: name, url: url, imageUrl: imageUrl);
          }
        } catch (e) {
          // Return Pokemon without image if detail fetch fails
          return Pokemon(
            name: item['name'] as String,
            url: url,
            imageUrl: null,
          );
        }
        return null;
      }).toList();

      final pokemonList = (await Future.wait(
        futures,
      )).whereType<Pokemon>().toList();

      return pokemonList;
    } catch (e) {
      throw Exception('Failed to load Pokemon: $e');
    }
  }

  Future<PokemonDetail> fetchPokemonDetail(String url) async {
    // Check cache first
    if (_detailCache.containsKey(url)) {
      return _detailCache[url]!;
    }

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Failed to load Pokemon details');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final detail = PokemonDetail.fromJson(data);

      // Store in cache
      _detailCache[url] = detail;

      return detail;
    } catch (e) {
      throw Exception('Failed to load Pokemon details: $e');
    }
  }

  // Prefetch details for multiple Pokemon
  Future<void> prefetchPokemonDetails(List<Pokemon> pokemonList) async {
    final futures = pokemonList.map((pokemon) async {
      if (!_detailCache.containsKey(pokemon.url)) {
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
    // Check cache first
    if (_evolutionCache.containsKey(speciesUrl)) {
      return _evolutionCache[speciesUrl]!;
    }

    try {
      // Get species data
      final speciesResponse = await http.get(Uri.parse(speciesUrl));
      if (speciesResponse.statusCode != 200) {
        throw Exception('Failed to load species data');
      }

      final speciesData =
          jsonDecode(speciesResponse.body) as Map<String, dynamic>;
      final evolutionChainUrl = speciesData['evolution_chain']['url'] as String;

      // Get evolution chain
      final evolutionResponse = await http.get(Uri.parse(evolutionChainUrl));
      if (evolutionResponse.statusCode != 200) {
        throw Exception('Failed to load evolution chain');
      }

      final evolutionData =
          jsonDecode(evolutionResponse.body) as Map<String, dynamic>;
      final evolutions = _parseEvolutionChain(evolutionData['chain']);

      final chain = EvolutionChain(evolutions: evolutions);

      // Store in cache
      _evolutionCache[speciesUrl] = chain;

      return chain;
    } catch (e) {
      throw Exception('Failed to load evolution chain: $e');
    }
  }

  List<Evolution> _parseEvolutionChain(Map<String, dynamic> chain) {
    final evolutions = <Evolution>[];

    void parseChain(Map<String, dynamic> current) {
      final speciesData = current['species'] as Map<String, dynamic>;
      final name = speciesData['name'] as String;
      final url = speciesData['url'] as String;
      final id = int.parse(url.split('/').where((e) => e.isNotEmpty).last);
      final imageUrl =
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

      evolutions.add(Evolution(name: name, id: id, imageUrl: imageUrl));

      final evolvesTo = current['evolves_to'] as List<dynamic>;
      if (evolvesTo.isNotEmpty) {
        parseChain(evolvesTo.first as Map<String, dynamic>);
      }
    }

    parseChain(chain);
    return evolutions;
  }
}
