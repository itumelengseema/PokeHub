import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';
import 'package:pokedex_app/presentation/viewmodels/home_viewmodel.dart';

import '../mocks/generate_mocks.mocks.dart';

void main() {
  late HomeViewModel viewModel;
  late MockPokemonRepository mockRepository;

  setUp(() {
    mockRepository = MockPokemonRepository();
    viewModel = HomeViewModel(pokemonRepository: mockRepository);
  });

  group('HomeViewModel loadPokemon Tests', () {
    test('should load Pokemon successfully', () async {
      final pokemonList = [
        Pokemon(name: 'pikachu', url: 'url1'),
        Pokemon(name: 'charizard', url: 'url2'),
      ];

      when(mockRepository.fetchPokemonList(0, 50))
          .thenAnswer((_) async => pokemonList);
      when(mockRepository.prefetchPokemonDetails(any))
          .thenAnswer((_) async {});

      expect(viewModel.state, HomeViewState.initial);

      await viewModel.loadPokemon();

      expect(viewModel.state, HomeViewState.loaded);
      expect(viewModel.pokemon.length, 2);
      expect(viewModel.pokemon[0].name, 'pikachu');
      expect(viewModel.errorMessage, null);
      verify(mockRepository.fetchPokemonList(0, 50)).called(1);
    });

    test('should handle error when loading Pokemon fails', () async {
      when(mockRepository.fetchPokemonList(0, 50))
          .thenThrow(Exception('Failed to load Pokemon: Network error'));

      await viewModel.loadPokemon();

      expect(viewModel.state, HomeViewState.error);
      expect(viewModel.errorMessage, contains('Exception'));
      expect(viewModel.pokemon.isEmpty, true);
    });

    test('should not load if already loading', () async {
      when(mockRepository.fetchPokemonList(0, 50))
          .thenAnswer((_) async => Future.delayed(
                Duration(milliseconds: 100),
                () => [Pokemon(name: 'pikachu', url: 'url1')],
              ));
      when(mockRepository.prefetchPokemonDetails(any))
          .thenAnswer((_) async {});

      final future1 = viewModel.loadPokemon();
      final future2 = viewModel.loadPokemon();

      await future1;
      await future2;

      verify(mockRepository.fetchPokemonList(0, 50)).called(1);
    });

    test('should set hasMoreData to false when no more Pokemon', () async {
      when(mockRepository.fetchPokemonList(0, 50))
          .thenAnswer((_) async => []);

      await viewModel.loadPokemon();

      expect(viewModel.hasMoreData, false);
    });
  });

  group('HomeViewModel loadMorePokemon Tests', () {
    test('should load more Pokemon successfully', () async {
      final firstBatch = [
        Pokemon(name: 'pikachu', url: 'url1'),
      ];
      final secondBatch = [
        Pokemon(name: 'charizard', url: 'url2'),
      ];

      when(mockRepository.fetchPokemonList(0, 50))
          .thenAnswer((_) async => firstBatch);
      when(mockRepository.fetchPokemonList(1, 50))
          .thenAnswer((_) async => secondBatch);
      when(mockRepository.prefetchPokemonDetails(any))
          .thenAnswer((_) async {});

      await viewModel.loadPokemon();
      expect(viewModel.pokemon.length, 1);

      await viewModel.loadMorePokemon();

      expect(viewModel.state, HomeViewState.loaded);
      expect(viewModel.pokemon.length, 2);
    });

    test('should not load more if already loading more', () async {
      final pokemonList = [Pokemon(name: 'pikachu', url: 'url1')];

      when(mockRepository.fetchPokemonList(any, any))
          .thenAnswer((_) async => pokemonList);
      when(mockRepository.prefetchPokemonDetails(any))
          .thenAnswer((_) async {});

      await viewModel.loadPokemon();

      when(mockRepository.fetchPokemonList(1, 50)).thenAnswer(
        (_) async => Future.delayed(
          Duration(milliseconds: 100),
          () => [Pokemon(name: 'charizard', url: 'url2')],
        ),
      );

      final future1 = viewModel.loadMorePokemon();
      final future2 = viewModel.loadMorePokemon();

      await future1;
      await future2;

      verify(mockRepository.fetchPokemonList(1, 50)).called(1);
    });

    test('should not load more if no more data available', () async {
      when(mockRepository.fetchPokemonList(0, 50))
          .thenAnswer((_) async => []);

      await viewModel.loadPokemon();
      expect(viewModel.hasMoreData, false);

      await viewModel.loadMorePokemon();

      verify(mockRepository.fetchPokemonList(0, 50)).called(1);
      verifyNever(mockRepository.fetchPokemonList(0, 50));
    });
  });

  group('HomeViewModel searchPokemon Tests', () {
    test('should search Pokemon successfully', () async {
      final allPokemon = [
        Pokemon(name: 'pikachu', url: 'url1'),
        Pokemon(name: 'charizard', url: 'url2'),
      ];

      final searchResults = [
        Pokemon(name: 'pikachu', url: 'url1'),
      ];

      when(mockRepository.fetchPokemonList(0, 50))
          .thenAnswer((_) async => allPokemon);
      when(mockRepository.prefetchPokemonDetails(any))
          .thenAnswer((_) async {});
      when(mockRepository.searchPokemon('pika'))
          .thenAnswer((_) async => searchResults);

      await viewModel.loadPokemon();
      await viewModel.searchPokemon('pika');

      expect(viewModel.searchQuery, 'pika');
      expect(viewModel.pokemon.length, 1);
      expect(viewModel.pokemon[0].name, 'pikachu');
    });

    test('should reset to all Pokemon when search query is empty', () async {
      final pokemonList = [
        Pokemon(name: 'pikachu', url: 'url1'),
        Pokemon(name: 'charizard', url: 'url2'),
      ];

      when(mockRepository.fetchPokemonList(0, 50))
          .thenAnswer((_) async => pokemonList);
      when(mockRepository.prefetchPokemonDetails(any))
          .thenAnswer((_) async {});

      await viewModel.loadPokemon();
      expect(viewModel.pokemon.length, 2);

      await viewModel.searchPokemon('');

      expect(viewModel.searchQuery, '');
      expect(viewModel.pokemon.length, 2);
      verifyNever(mockRepository.searchPokemon(any));
    });

    test('should handle search errors gracefully', () async {
      final pokemonList = [
        Pokemon(name: 'pikachu', url: 'url1'),
      ];

      when(mockRepository.fetchPokemonList(0, 50))
          .thenAnswer((_) async => pokemonList);
      when(mockRepository.prefetchPokemonDetails(any))
          .thenAnswer((_) async {});
      when(mockRepository.searchPokemon('test'))
          .thenThrow(Exception('Search error'));

      await viewModel.loadPokemon();
      await viewModel.searchPokemon('test');

      expect(viewModel.pokemon.length, 0);
    });
  });

  group('HomeViewModel refresh Tests', () {
    test('should refresh Pokemon list', () async {
      final firstLoad = [Pokemon(name: 'pikachu', url: 'url1')];
      final secondLoad = [Pokemon(name: 'charizard', url: 'url2')];

      when(mockRepository.fetchPokemonList(0, 50))
          .thenAnswer((_) async => firstLoad);
      when(mockRepository.prefetchPokemonDetails(any))
          .thenAnswer((_) async {});
      when(mockRepository.clearCache()).thenReturn(null);

      await viewModel.loadPokemon();
      expect(viewModel.pokemon.length, 1);
      expect(viewModel.pokemon[0].name, 'pikachu');

      when(mockRepository.fetchPokemonList(0, 50))
          .thenAnswer((_) async => secondLoad);

      await viewModel.refresh();

      expect(viewModel.pokemon.length, 1);
      expect(viewModel.pokemon[0].name, 'charizard');
      expect(viewModel.searchQuery, '');
      expect(viewModel.selectedType, null);
      verify(mockRepository.clearCache()).called(1);
    });
  });

  group('HomeViewModel filterByType Tests', () {
    test('should filter Pokemon by type', () async {
      final pokemonList = [
        Pokemon(name: 'pikachu', url: 'url1', types: ['electric']),
        Pokemon(name: 'charizard', url: 'url2', types: ['fire', 'flying']),
      ];

      when(mockRepository.fetchPokemonList(0, 50))
          .thenAnswer((_) async => pokemonList);
      when(mockRepository.prefetchPokemonDetails(any))
          .thenAnswer((_) async {});

      await viewModel.loadPokemon();

      viewModel.filterByType('electric');

      expect(viewModel.selectedType, 'electric');
    });

    test('should reset filter when type is null', () {
      viewModel.filterByType(null);

      expect(viewModel.selectedType, null);
    });
  });

  group('HomeViewModel resetFilters Tests', () {
    test('should reset all filters', () async {
      final pokemonList = [
        Pokemon(name: 'pikachu', url: 'url1'),
      ];

      when(mockRepository.fetchPokemonList(0, 50))
          .thenAnswer((_) async => pokemonList);
      when(mockRepository.prefetchPokemonDetails(any))
          .thenAnswer((_) async {});
      when(mockRepository.searchPokemon('test'))
          .thenAnswer((_) async => pokemonList);

      await viewModel.loadPokemon();
      await viewModel.searchPokemon('test');
      viewModel.filterByType('electric');

      expect(viewModel.searchQuery, 'test');
      expect(viewModel.selectedType, 'electric');

      viewModel.resetFilters();

      expect(viewModel.searchQuery, '');
      expect(viewModel.selectedType, null);
    });
  });
}
