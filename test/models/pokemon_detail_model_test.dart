import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/data/models/pokemon_detail_model.dart';

void main() {
  group('PokemonDetail Model Tests', () {
    test('PokemonDetail should be created correctly', () {
      final detail = PokemonDetail(
        id: 25,
        name: 'pikachu',
        height: 4,
        weight: 60,
        types: [PokemonType(name: 'electric')],
        abilities: [PokemonAbility(name: 'static')],
        stats: [PokemonStat(name: 'hp', baseStat: 35)],
        imageUrl: 'https://example.com/pikachu.png',
      );

      expect(detail.id, 25);
      expect(detail.name, 'pikachu');
      expect(detail.height, 4);
      expect(detail.weight, 60);
      expect(detail.types.length, 1);
      expect(detail.abilities.length, 1);
      expect(detail.stats.length, 1);
      expect(detail.imageUrl, 'https://example.com/pikachu.png');
      expect(detail.speciesUrl, null);
    });

    test('PokemonDetail fromJson should parse correctly', () {
      final json = {
        'id': 25,
        'name': 'pikachu',
        'height': 4,
        'weight': 60,
        'types': [
          {
            'type': {'name': 'electric'}
          }
        ],
        'abilities': [
          {
            'ability': {'name': 'static'}
          }
        ],
        'stats': [
          {
            'stat': {'name': 'hp'},
            'base_stat': 35
          }
        ],
        'sprites': {
          'other': {
            'official-artwork': {'front_default': 'https://example.com/pikachu.png'}
          }
        },
        'species': {'url': 'https://pokeapi.co/api/v2/pokemon-species/25/'}
      };

      final detail = PokemonDetail.fromJson(json);

      expect(detail.id, 25);
      expect(detail.name, 'pikachu');
      expect(detail.height, 4);
      expect(detail.weight, 60);
      expect(detail.types.length, 1);
      expect(detail.types[0].name, 'electric');
      expect(detail.abilities.length, 1);
      expect(detail.abilities[0].name, 'static');
      expect(detail.stats.length, 1);
      expect(detail.stats[0].name, 'hp');
      expect(detail.stats[0].baseStat, 35);
      expect(detail.imageUrl, 'https://example.com/pikachu.png');
      expect(detail.speciesUrl, 'https://pokeapi.co/api/v2/pokemon-species/25/');
    });

    test('PokemonDetail toJson should serialize correctly', () {
      final detail = PokemonDetail(
        id: 25,
        name: 'pikachu',
        height: 4,
        weight: 60,
        types: [PokemonType(name: 'electric')],
        abilities: [PokemonAbility(name: 'static')],
        stats: [PokemonStat(name: 'hp', baseStat: 35)],
        imageUrl: 'https://example.com/pikachu.png',
        speciesUrl: 'https://pokeapi.co/api/v2/pokemon-species/25/',
      );

      final json = detail.toJson();

      expect(json['id'], 25);
      expect(json['name'], 'pikachu');
      expect(json['height'], 4);
      expect(json['weight'], 60);
      expect(json['imageUrl'], 'https://example.com/pikachu.png');
      expect(json['speciesUrl'], 'https://pokeapi.co/api/v2/pokemon-species/25/');
    });
  });

  group('PokemonType Model Tests', () {
    test('PokemonType should be created correctly', () {
      final type = PokemonType(name: 'electric');
      expect(type.name, 'electric');
    });

    test('PokemonType fromJson should parse correctly', () {
      final json = {
        'type': {'name': 'electric'}
      };

      final type = PokemonType.fromJson(json);
      expect(type.name, 'electric');
    });

    test('PokemonType toJson should serialize correctly', () {
      final type = PokemonType(name: 'electric');
      final json = type.toJson();

      expect(json['type']['name'], 'electric');
    });
  });

  group('PokemonAbility Model Tests', () {
    test('PokemonAbility should be created correctly', () {
      final ability = PokemonAbility(name: 'static');
      expect(ability.name, 'static');
    });

    test('PokemonAbility fromJson should parse correctly', () {
      final json = {
        'ability': {'name': 'static'}
      };

      final ability = PokemonAbility.fromJson(json);
      expect(ability.name, 'static');
    });

    test('PokemonAbility toJson should serialize correctly', () {
      final ability = PokemonAbility(name: 'static');
      final json = ability.toJson();

      expect(json['ability']['name'], 'static');
    });
  });

  group('PokemonStat Model Tests', () {
    test('PokemonStat should be created correctly', () {
      final stat = PokemonStat(name: 'hp', baseStat: 35);
      expect(stat.name, 'hp');
      expect(stat.baseStat, 35);
    });

    test('PokemonStat fromJson should parse correctly', () {
      final json = {
        'stat': {'name': 'hp'},
        'base_stat': 35
      };

      final stat = PokemonStat.fromJson(json);
      expect(stat.name, 'hp');
      expect(stat.baseStat, 35);
    });

    test('PokemonStat toJson should serialize correctly', () {
      final stat = PokemonStat(name: 'hp', baseStat: 35);
      final json = stat.toJson();

      expect(json['stat']['name'], 'hp');
      expect(json['base_stat'], 35);
    });
  });

  group('Evolution Model Tests', () {
    test('Evolution should be created correctly', () {
      final evolution = Evolution(
        name: 'pikachu',
        id: 25,
        imageUrl: 'https://example.com/pikachu.png',
      );

      expect(evolution.name, 'pikachu');
      expect(evolution.id, 25);
      expect(evolution.imageUrl, 'https://example.com/pikachu.png');
    });

    test('Evolution fromJson should parse correctly', () {
      final json = {
        'name': 'pikachu',
        'id': 25,
        'imageUrl': 'https://example.com/pikachu.png',
      };

      final evolution = Evolution.fromJson(json);
      expect(evolution.name, 'pikachu');
      expect(evolution.id, 25);
      expect(evolution.imageUrl, 'https://example.com/pikachu.png');
    });

    test('Evolution toJson should serialize correctly', () {
      final evolution = Evolution(
        name: 'pikachu',
        id: 25,
        imageUrl: 'https://example.com/pikachu.png',
      );

      final json = evolution.toJson();
      expect(json['name'], 'pikachu');
      expect(json['id'], 25);
      expect(json['imageUrl'], 'https://example.com/pikachu.png');
    });
  });

  group('EvolutionChain Model Tests', () {
    test('EvolutionChain should be created correctly', () {
      final chain = EvolutionChain(evolutions: [
        Evolution(name: 'pichu', id: 172, imageUrl: 'url1'),
        Evolution(name: 'pikachu', id: 25, imageUrl: 'url2'),
        Evolution(name: 'raichu', id: 26, imageUrl: 'url3'),
      ]);

      expect(chain.evolutions.length, 3);
      expect(chain.evolutions[0].name, 'pichu');
      expect(chain.evolutions[1].name, 'pikachu');
      expect(chain.evolutions[2].name, 'raichu');
    });

    test('EvolutionChain fromJson should parse correctly', () {
      final json = {
        'evolutions': [
          {'name': 'pichu', 'id': 172, 'imageUrl': 'url1'},
          {'name': 'pikachu', 'id': 25, 'imageUrl': 'url2'},
        ]
      };

      final chain = EvolutionChain.fromJson(json);
      expect(chain.evolutions.length, 2);
      expect(chain.evolutions[0].name, 'pichu');
      expect(chain.evolutions[1].name, 'pikachu');
    });

    test('EvolutionChain toJson should serialize correctly', () {
      final chain = EvolutionChain(evolutions: [
        Evolution(name: 'pichu', id: 172, imageUrl: 'url1'),
        Evolution(name: 'pikachu', id: 25, imageUrl: 'url2'),
      ]);

      final json = chain.toJson();
      expect(json['evolutions'].length, 2);
      expect(json['evolutions'][0]['name'], 'pichu');
      expect(json['evolutions'][1]['name'], 'pikachu');
    });
  });
}
