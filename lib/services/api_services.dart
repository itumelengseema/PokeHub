import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokedex_app/models/pokemon.dart';

class ApiServices {
  static const String baseUrl = 'https://pokeapi.co/api/v2/pokemon/';

  Future<List<Pokemon>> fetchPokemon(int offset, int limit) async {
    final response = await http.get(
      Uri.parse('$baseUrl?offset=$offset&limit=$limit'),
    );

    if (response.statusCode != 200) throw Exception('Failed to load Pokemon');

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;
    List<Pokemon> pokemonList = [];

    for (var item in results) {
      final url = item['url'] as String;
      final pokemonResponse = await http.get(Uri.parse(url));
      if (pokemonResponse.statusCode == 200) {
        final detailData =
            jsonDecode(pokemonResponse.body) as Map<String, dynamic>;
        final name = detailData['name'] as String;
        final imageUrl = detailData['sprites']?['front_default'] as String?;
        pokemonList.add(Pokemon(name: name, url: url, imageUrl: imageUrl));
      }
    }
    return pokemonList;
  }
}
