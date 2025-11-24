import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokedex_app/models/pokemon.dart';

class ApiServices {
  static const String baseUrl = 'https://pokeapi.co/api/v2/pokemon/';

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
}
