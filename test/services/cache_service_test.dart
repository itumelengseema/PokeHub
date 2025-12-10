import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/data/models/pokemon_detail_model.dart';
import 'package:pokedex_app/data/services/local/cache_service.dart';

void main() {
  late CacheService cacheService;

  setUp(() {
    cacheService = CacheService();
  });

  group('CacheService Pokemon Detail Cache Tests', () {
    test('should return null when cache is empty', () {
      final result = cacheService.getDetailFromCache('test_url');
      expect(result, null);
    });

    test('should cache and retrieve Pokemon detail', () {
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

      cacheService.cacheDetail('test_url', detail);
      final cached = cacheService.getDetailFromCache('test_url');

      expect(cached, detail);
      expect(cached?.id, 25);
      expect(cached?.name, 'pikachu');
    });

    test('should check if detail exists in cache', () {
      final detail = PokemonDetail(
        id: 25,
        name: 'pikachu',
        height: 4,
        weight: 60,
        types: [],
        abilities: [],
        stats: [],
        imageUrl: 'test',
      );

      expect(cacheService.hasDetailInCache('test_url'), false);

      cacheService.cacheDetail('test_url', detail);

      expect(cacheService.hasDetailInCache('test_url'), true);
    });

    test('should clear detail cache', () {
      final detail = PokemonDetail(
        id: 25,
        name: 'pikachu',
        height: 4,
        weight: 60,
        types: [],
        abilities: [],
        stats: [],
        imageUrl: 'test',
      );

      cacheService.cacheDetail('test_url', detail);
      expect(cacheService.hasDetailInCache('test_url'), true);

      cacheService.clearDetailCache();
      expect(cacheService.hasDetailInCache('test_url'), false);
      expect(cacheService.getDetailFromCache('test_url'), null);
    });

    test('should handle multiple cached details', () {
      final detail1 = PokemonDetail(
        id: 25,
        name: 'pikachu',
        height: 4,
        weight: 60,
        types: [],
        abilities: [],
        stats: [],
        imageUrl: 'test',
      );

      final detail2 = PokemonDetail(
        id: 6,
        name: 'charizard',
        height: 17,
        weight: 905,
        types: [],
        abilities: [],
        stats: [],
        imageUrl: 'test',
      );

      cacheService.cacheDetail('url1', detail1);
      cacheService.cacheDetail('url2', detail2);

      expect(cacheService.getDetailFromCache('url1')?.name, 'pikachu');
      expect(cacheService.getDetailFromCache('url2')?.name, 'charizard');
    });
  });

  group('CacheService Evolution Cache Tests', () {
    test('should return null when evolution cache is empty', () {
      final result = cacheService.getEvolutionFromCache('test_url');
      expect(result, null);
    });

    test('should cache and retrieve evolution chain', () {
      final chain = EvolutionChain(evolutions: [
        Evolution(name: 'pichu', id: 172, imageUrl: 'url1'),
        Evolution(name: 'pikachu', id: 25, imageUrl: 'url2'),
        Evolution(name: 'raichu', id: 26, imageUrl: 'url3'),
      ]);

      cacheService.cacheEvolution('test_url', chain);
      final cached = cacheService.getEvolutionFromCache('test_url');

      expect(cached, chain);
      expect(cached?.evolutions.length, 3);
      expect(cached?.evolutions[1].name, 'pikachu');
    });

    test('should check if evolution exists in cache', () {
      final chain = EvolutionChain(evolutions: [
        Evolution(name: 'pikachu', id: 25, imageUrl: 'url'),
      ]);

      expect(cacheService.hasEvolutionInCache('test_url'), false);

      cacheService.cacheEvolution('test_url', chain);

      expect(cacheService.hasEvolutionInCache('test_url'), true);
    });

    test('should clear evolution cache', () {
      final chain = EvolutionChain(evolutions: [
        Evolution(name: 'pikachu', id: 25, imageUrl: 'url'),
      ]);

      cacheService.cacheEvolution('test_url', chain);
      expect(cacheService.hasEvolutionInCache('test_url'), true);

      cacheService.clearEvolutionCache();
      expect(cacheService.hasEvolutionInCache('test_url'), false);
      expect(cacheService.getEvolutionFromCache('test_url'), null);
    });
  });

  group('CacheService Clear All Tests', () {
    test('should clear both detail and evolution cache', () {
      final detail = PokemonDetail(
        id: 25,
        name: 'pikachu',
        height: 4,
        weight: 60,
        types: [],
        abilities: [],
        stats: [],
        imageUrl: 'test',
      );

      final chain = EvolutionChain(evolutions: [
        Evolution(name: 'pikachu', id: 25, imageUrl: 'url'),
      ]);

      cacheService.cacheDetail('detail_url', detail);
      cacheService.cacheEvolution('evolution_url', chain);

      expect(cacheService.hasDetailInCache('detail_url'), true);
      expect(cacheService.hasEvolutionInCache('evolution_url'), true);

      cacheService.clearCache();

      expect(cacheService.hasDetailInCache('detail_url'), false);
      expect(cacheService.hasEvolutionInCache('evolution_url'), false);
    });
  });
}
