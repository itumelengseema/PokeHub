import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';
import 'package:pokedex_app/data/models/pokemon_detail_model.dart';
import 'package:pokedex_app/data/repositories/pokemon_repository.dart';

import '../mocks/generate_mocks.mocks.dart';

void main() {
  late PokemonRepository repository;
  late MockPokemonApiService mockApiService;
  late MockCacheService mockCacheService;

  setUp(() {
    mockApiService = MockPokemonApiService();
    mockCacheService = MockCacheService();
    repository = PokemonRepository(
      apiService: mockApiService,
      cacheService: mockCacheService,
    );
  });

  group('PokemonRepository fetchPokemonList Tests', () {
    test('should fetch Pokemon list from API service', () async {
      final pokemonList = [
        Pokemon(name: 'pikachu', url: 'url1'),
        Pokemon(name: 'charizard', url: 'url2'),
      ];

      when(mockApiService.fetchPokemonList(0, 20))
          .thenAnswer((_) async => pokemonList);

      final result = await repository.fetchPokemonList(0, 20);

      expect(result, pokemonList);
      expect(result.length, 2);
      verify(mockApiService.fetchPokemonList(0, 20)).called(1);
    });

    test('should throw exception when API service fails', () async {
      when(mockApiService.fetchPokemonList(0, 20))
          .thenThrow(Exception('API Error'));

      expect(
        () => repository.fetchPokemonList(0, 20),
        throwsException,
      );

      verify(mockApiService.fetchPokemonList(0, 20)).called(1);
    });
  });

  group('PokemonRepository fetchPokemonDetail Tests', () {
    test('should return cached detail if available', () async {
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

      when(mockCacheService.getDetailFromCache('test_url'))
          .thenReturn(detail);

      final result = await repository.fetchPokemonDetail('test_url');

      expect(result, detail);
      verify(mockCacheService.getDetailFromCache('test_url')).called(1);
      verifyNever(mockApiService.fetchPokemonDetail(any));
    });

    test('should fetch from API and cache if not in cache', () async {
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

      when(mockCacheService.getDetailFromCache('test_url')).thenReturn(null);
      when(mockApiService.fetchPokemonDetail('test_url'))
          .thenAnswer((_) async => detail);
      when(mockCacheService.cacheDetail('test_url', detail))
          .thenReturn(null);

      final result = await repository.fetchPokemonDetail('test_url');

      expect(result, detail);
      verify(mockCacheService.getDetailFromCache('test_url')).called(1);
      verify(mockApiService.fetchPokemonDetail('test_url')).called(1);
      verify(mockCacheService.cacheDetail('test_url', detail)).called(1);
    });

    test('should throw exception when API fails', () async {
      when(mockCacheService.getDetailFromCache('test_url')).thenReturn(null);
      when(mockApiService.fetchPokemonDetail('test_url'))
          .thenThrow(Exception('API Error'));

      expect(
        () => repository.fetchPokemonDetail('test_url'),
        throwsException,
      );
    });
  });

  group('PokemonRepository fetchEvolutionChain Tests', () {
    test('should return cached evolution chain if available', () async {
      final chain = EvolutionChain(evolutions: [
        Evolution(name: 'pikachu', id: 25, imageUrl: 'url'),
      ]);

      when(mockCacheService.getEvolutionFromCache('species_url'))
          .thenReturn(chain);

      final result = await repository.fetchEvolutionChain('species_url');

      expect(result, chain);
      verify(mockCacheService.getEvolutionFromCache('species_url')).called(1);
      verifyNever(mockApiService.fetchEvolutionChain(any));
    });

    test('should fetch from API and cache if not in cache', () async {
      final chain = EvolutionChain(evolutions: [
        Evolution(name: 'pikachu', id: 25, imageUrl: 'url'),
      ]);

      when(mockCacheService.getEvolutionFromCache('species_url'))
          .thenReturn(null);
      when(mockApiService.fetchEvolutionChain('species_url'))
          .thenAnswer((_) async => chain);
      when(mockCacheService.cacheEvolution('species_url', chain))
          .thenReturn(null);

      final result = await repository.fetchEvolutionChain('species_url');

      expect(result, chain);
      verify(mockCacheService.getEvolutionFromCache('species_url')).called(1);
      verify(mockApiService.fetchEvolutionChain('species_url')).called(1);
      verify(mockCacheService.cacheEvolution('species_url', chain)).called(1);
    });

    test('should throw exception when API fails', () async {
      when(mockCacheService.getEvolutionFromCache('species_url'))
          .thenReturn(null);
      when(mockApiService.fetchEvolutionChain('species_url'))
          .thenThrow(Exception('API Error'));

      expect(
        () => repository.fetchEvolutionChain('species_url'),
        throwsException,
      );
    });
  });

  group('PokemonRepository searchPokemon Tests', () {
    test('should search Pokemon from API service', () async {
      final pokemonList = [
        Pokemon(name: 'pikachu', url: 'url1'),
      ];

      when(mockApiService.searchPokemon('pikachu', limit: 20))
          .thenAnswer((_) async => pokemonList);

      final result = await repository.searchPokemon('pikachu', limit: 20);

      expect(result, pokemonList);
      expect(result.length, 1);
      verify(mockApiService.searchPokemon('pikachu', limit: 20)).called(1);
    });

    test('should throw exception when search fails', () async {
      when(mockApiService.searchPokemon('pikachu', limit: 20))
          .thenThrow(Exception('API Error'));

      expect(
        () => repository.searchPokemon('pikachu', limit: 20),
        throwsException,
      );
    });
  });

  group('PokemonRepository clearCache Tests', () {
    test('should clear cache service', () {
      when(mockCacheService.clearCache()).thenReturn(null);

      repository.clearCache();

      verify(mockCacheService.clearCache()).called(1);
    });
  });

  group('PokemonRepository prefetchPokemonDetails Tests', () {
    test('should prefetch details for uncached Pokemon', () async {
      final pokemonList = [
        Pokemon(name: 'pikachu', url: 'url1'),
        Pokemon(name: 'charizard', url: 'url2'),
      ];

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

      when(mockCacheService.hasDetailInCache('url1')).thenReturn(false);
      when(mockCacheService.hasDetailInCache('url2')).thenReturn(true);
      when(mockCacheService.getDetailFromCache('url1')).thenReturn(null);
      when(mockApiService.fetchPokemonDetail('url1'))
          .thenAnswer((_) async => detail);
      when(mockCacheService.cacheDetail('url1', detail)).thenReturn(null);

      await repository.prefetchPokemonDetails(pokemonList);

      verify(mockCacheService.hasDetailInCache('url1')).called(1);
      verify(mockCacheService.hasDetailInCache('url2')).called(1);
      verify(mockApiService.fetchPokemonDetail('url1')).called(1);
      verifyNever(mockApiService.fetchPokemonDetail('url2'));
    });

    test('should handle prefetch errors silently', () async {
      final pokemonList = [
        Pokemon(name: 'pikachu', url: 'url1'),
      ];

      when(mockCacheService.hasDetailInCache('url1')).thenReturn(false);
      when(mockCacheService.getDetailFromCache('url1')).thenReturn(null);
      when(mockApiService.fetchPokemonDetail('url1'))
          .thenThrow(Exception('API Error'));

      await repository.prefetchPokemonDetails(pokemonList);

      verify(mockApiService.fetchPokemonDetail('url1')).called(1);
    });
  });
}
