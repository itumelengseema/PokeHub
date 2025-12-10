import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';

void main() {
  group('Pokemon Model Tests', () {
    test('Pokemon should be created with required fields', () {
      final pokemon = Pokemon(
        name: 'pikachu',
        url: 'https://pokeapi.co/api/v2/pokemon/25/',
      );

      expect(pokemon.name, 'pikachu');
      expect(pokemon.url, 'https://pokeapi.co/api/v2/pokemon/25/');
      expect(pokemon.imageUrl, null);
      expect(pokemon.types, null);
    });

    test('Pokemon should be created with optional fields', () {
      final pokemon = Pokemon(
        name: 'pikachu',
        url: 'https://pokeapi.co/api/v2/pokemon/25/',
        imageUrl: 'https://example.com/pikachu.png',
        types: ['electric'],
      );

      expect(pokemon.name, 'pikachu');
      expect(pokemon.url, 'https://pokeapi.co/api/v2/pokemon/25/');
      expect(pokemon.imageUrl, 'https://example.com/pikachu.png');
      expect(pokemon.types, ['electric']);
    });

    test('Pokemon id getter should extract ID from URL correctly', () {
      final pokemon = Pokemon(
        name: 'pikachu',
        url: 'https://pokeapi.co/api/v2/pokemon/25/',
      );

      expect(pokemon.id, '25');
    });

    test('Pokemon id getter should handle URL without trailing slash', () {
      final pokemon = Pokemon(
        name: 'pikachu',
        url: 'https://pokeapi.co/api/v2/pokemon/25',
      );

      expect(pokemon.id, '25');
    });

    test('Pokemon fromJson should parse JSON correctly', () {
      final json = {
        'name': 'pikachu',
        'url': 'https://pokeapi.co/api/v2/pokemon/25/',
        'imageUrl': 'https://example.com/pikachu.png',
        'types': ['electric'],
      };

      final pokemon = Pokemon.fromJson(json);

      expect(pokemon.name, 'pikachu');
      expect(pokemon.url, 'https://pokeapi.co/api/v2/pokemon/25/');
      expect(pokemon.imageUrl, 'https://example.com/pikachu.png');
      expect(pokemon.types, ['electric']);
    });

    test('Pokemon fromJson should handle missing optional fields', () {
      final json = {
        'name': 'pikachu',
        'url': 'https://pokeapi.co/api/v2/pokemon/25/',
      };

      final pokemon = Pokemon.fromJson(json);

      expect(pokemon.name, 'pikachu');
      expect(pokemon.url, 'https://pokeapi.co/api/v2/pokemon/25/');
      expect(pokemon.imageUrl, null);
      expect(pokemon.types, null);
    });

    test('Pokemon toJson should serialize correctly', () {
      final pokemon = Pokemon(
        name: 'pikachu',
        url: 'https://pokeapi.co/api/v2/pokemon/25/',
        imageUrl: 'https://example.com/pikachu.png',
        types: ['electric'],
      );

      final json = pokemon.toJson();

      expect(json['name'], 'pikachu');
      expect(json['url'], 'https://pokeapi.co/api/v2/pokemon/25/');
      expect(json['imageUrl'], 'https://example.com/pikachu.png');
      expect(json['types'], ['electric']);
    });

    test('Pokemon equality should be based on URL', () {
      final pokemon1 = Pokemon(
        name: 'pikachu',
        url: 'https://pokeapi.co/api/v2/pokemon/25/',
      );

      final pokemon2 = Pokemon(
        name: 'pikachu',
        url: 'https://pokeapi.co/api/v2/pokemon/25/',
      );

      final pokemon3 = Pokemon(
        name: 'charizard',
        url: 'https://pokeapi.co/api/v2/pokemon/6/',
      );

      expect(pokemon1 == pokemon2, true);
      expect(pokemon1 == pokemon3, false);
      expect(pokemon1.hashCode == pokemon2.hashCode, true);
      expect(pokemon1.hashCode == pokemon3.hashCode, false);
    });

    test('Pokemon should handle multiple types', () {
      final pokemon = Pokemon(
        name: 'charizard',
        url: 'https://pokeapi.co/api/v2/pokemon/6/',
        types: ['fire', 'flying'],
      );

      expect(pokemon.types?.length, 2);
      expect(pokemon.types?[0], 'fire');
      expect(pokemon.types?[1], 'flying');
    });
  });
}
