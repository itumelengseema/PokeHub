import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';
import 'package:pokedex_app/data/models/pokemon_detail_model.dart';
import 'package:pokedex_app/presentation/viewmodels/details_viewmodel.dart';

import '../mocks/generate_mocks.mocks.dart';

void main() {
  late DetailsViewModel viewModel;
  late MockPokemonRepository mockRepository;
  late Pokemon testPokemon;

  setUp(() {
    mockRepository = MockPokemonRepository();
    testPokemon = Pokemon(
      name: 'pikachu',
      url: 'https://pokeapi.co/api/v2/pokemon/25/',
    );
    viewModel = DetailsViewModel(
      pokemon: testPokemon,
      pokemonRepository: mockRepository,
    );
  });

  group('DetailsViewModel loadPokemonDetail Tests', () {
    test('should load Pokemon detail successfully', () async {
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

      when(mockRepository.fetchPokemonDetail(testPokemon.url))
          .thenAnswer((_) async => detail);

      expect(viewModel.state, DetailsViewState.initial);

      await viewModel.loadPokemonDetail();

      expect(viewModel.state, DetailsViewState.loaded);
      expect(viewModel.pokemonDetail, detail);
      expect(viewModel.errorMessage, null);
      verify(mockRepository.fetchPokemonDetail(testPokemon.url)).called(1);
    });

    test('should load evolution chain after loading detail', () async {
      final detail = PokemonDetail(
        id: 25,
        name: 'pikachu',
        height: 4,
        weight: 60,
        types: [],
        abilities: [],
        stats: [],
        imageUrl: 'test',
        speciesUrl: 'https://pokeapi.co/api/v2/pokemon-species/25/',
      );

      final evolutionChain = EvolutionChain(evolutions: [
        Evolution(name: 'pichu', id: 172, imageUrl: 'url1'),
        Evolution(name: 'pikachu', id: 25, imageUrl: 'url2'),
        Evolution(name: 'raichu', id: 26, imageUrl: 'url3'),
      ]);

      when(mockRepository.fetchPokemonDetail(testPokemon.url))
          .thenAnswer((_) async => detail);
      when(mockRepository.fetchEvolutionChain(detail.speciesUrl!))
          .thenAnswer((_) async => evolutionChain);

      await viewModel.loadPokemonDetail();

      expect(viewModel.pokemonDetail, detail);
      expect(viewModel.evolutionChain, evolutionChain);
      verify(mockRepository.fetchEvolutionChain(detail.speciesUrl!)).called(1);
    });

    test('should not load evolution chain if speciesUrl is null', () async {
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

      when(mockRepository.fetchPokemonDetail(testPokemon.url))
          .thenAnswer((_) async => detail);

      await viewModel.loadPokemonDetail();

      expect(viewModel.pokemonDetail, detail);
      expect(viewModel.evolutionChain, null);
      verifyNever(mockRepository.fetchEvolutionChain(any));
    });

    test('should handle error when loading detail fails', () async {
      when(mockRepository.fetchPokemonDetail(testPokemon.url))
          .thenThrow(Exception('Failed to load details'));

      await viewModel.loadPokemonDetail();

      expect(viewModel.state, DetailsViewState.error);
      expect(viewModel.errorMessage, contains('Exception'));
      expect(viewModel.pokemonDetail, null);
    });

    test('should not load if already loading', () async {
      when(mockRepository.fetchPokemonDetail(testPokemon.url)).thenAnswer(
        (_) async => Future.delayed(
          Duration(milliseconds: 100),
          () => PokemonDetail(
            id: 25,
            name: 'pikachu',
            height: 4,
            weight: 60,
            types: [],
            abilities: [],
            stats: [],
            imageUrl: 'test',
          ),
        ),
      );

      final future1 = viewModel.loadPokemonDetail();
      final future2 = viewModel.loadPokemonDetail();

      await future1;
      await future2;

      verify(mockRepository.fetchPokemonDetail(testPokemon.url)).called(1);
    });
  });

  group('DetailsViewModel loadEvolutionChain Tests', () {
    test('should load evolution chain successfully', () async {
      final detail = PokemonDetail(
        id: 25,
        name: 'pikachu',
        height: 4,
        weight: 60,
        types: [],
        abilities: [],
        stats: [],
        imageUrl: 'test',
        speciesUrl: 'https://pokeapi.co/api/v2/pokemon-species/25/',
      );

      final evolutionChain = EvolutionChain(evolutions: [
        Evolution(name: 'pikachu', id: 25, imageUrl: 'url'),
      ]);

      when(mockRepository.fetchPokemonDetail(testPokemon.url))
          .thenAnswer((_) async => detail);
      when(mockRepository.fetchEvolutionChain(detail.speciesUrl!))
          .thenAnswer((_) async => evolutionChain);

      await viewModel.loadPokemonDetail();

      expect(viewModel.isLoadingEvolution, false);
      expect(viewModel.evolutionChain, evolutionChain);
      expect(viewModel.evolutionErrorMessage, null);
    });

    test('should handle evolution chain error gracefully', () async {
      final detail = PokemonDetail(
        id: 25,
        name: 'pikachu',
        height: 4,
        weight: 60,
        types: [],
        abilities: [],
        stats: [],
        imageUrl: 'test',
        speciesUrl: 'https://pokeapi.co/api/v2/pokemon-species/25/',
      );

      when(mockRepository.fetchPokemonDetail(testPokemon.url))
          .thenAnswer((_) async => detail);
      when(mockRepository.fetchEvolutionChain(detail.speciesUrl!))
          .thenThrow(Exception('Evolution error'));

      await viewModel.loadPokemonDetail();

      expect(viewModel.state, DetailsViewState.loaded);
      expect(viewModel.evolutionChain, null);
      expect(viewModel.evolutionErrorMessage, contains('Exception'));
      expect(viewModel.isLoadingEvolution, false);
    });

    test('should not load evolution if speciesUrl is null', () async {
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

      when(mockRepository.fetchPokemonDetail(testPokemon.url))
          .thenAnswer((_) async => detail);

      await viewModel.loadPokemonDetail();
      await viewModel.loadEvolutionChain();

      expect(viewModel.evolutionChain, null);
      verifyNever(mockRepository.fetchEvolutionChain(any));
    });
  });

  group('DetailsViewModel retry Tests', () {
    test('should retry loading Pokemon detail', () async {
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

      when(mockRepository.fetchPokemonDetail(testPokemon.url))
          .thenThrow(Exception('Error'));

      await viewModel.loadPokemonDetail();
      expect(viewModel.state, DetailsViewState.error);

      when(mockRepository.fetchPokemonDetail(testPokemon.url))
          .thenAnswer((_) async => detail);

      await viewModel.retry();

      expect(viewModel.state, DetailsViewState.loaded);
      expect(viewModel.pokemonDetail, detail);
      verify(mockRepository.fetchPokemonDetail(testPokemon.url)).called(2);
    });
  });

  group('DetailsViewModel UI Helper Tests', () {
    test('getTypeColor should return correct color for known types', () {
      expect(viewModel.getTypeColor('fire'), '#F08030');
      expect(viewModel.getTypeColor('water'), '#6890F0');
      expect(viewModel.getTypeColor('electric'), '#F8D030');
      expect(viewModel.getTypeColor('grass'), '#78C850');
      expect(viewModel.getTypeColor('psychic'), '#F85888');
    });

    test('getTypeColor should return default color for unknown type', () {
      expect(viewModel.getTypeColor('unknown'), '#777777');
      expect(viewModel.getTypeColor('invalid'), '#777777');
    });

    test('getTypeColor should be case insensitive', () {
      expect(viewModel.getTypeColor('FIRE'), '#F08030');
      expect(viewModel.getTypeColor('Water'), '#6890F0');
      expect(viewModel.getTypeColor('ElEcTrIc'), '#F8D030');
    });

    test('getStatPercentage should calculate percentage correctly', () {
      expect(viewModel.getStatPercentage(0), 0.0);
      expect(viewModel.getStatPercentage(127), closeTo(0.498, 0.001));
      expect(viewModel.getStatPercentage(255), 1.0);
    });

    test('getStatPercentage should clamp values between 0 and 1', () {
      expect(viewModel.getStatPercentage(-10), 0.0);
      expect(viewModel.getStatPercentage(300), 1.0);
    });
  });
}
