import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';
import 'package:pokedex_app/presentation/viewmodels/favorites_viewmodel.dart';
import 'package:pokedex_app/presentation/viewmodels/home_viewmodel.dart';
import 'package:pokedex_app/presentation/widgets/pokemon_card.dart';
import 'package:provider/provider.dart';

import '../mocks/generate_mocks.mocks.dart';

void main() {
  late MockPokemonRepository mockRepository;
  late MockFavoritesRepository mockFavoritesRepository;

  setUp(() {
    mockRepository = MockPokemonRepository();
    mockFavoritesRepository = MockFavoritesRepository();
    when(mockFavoritesRepository.favoritesStream())
        .thenAnswer((_) => Stream.value([]));
  });

  Widget createHomeScreenWidget(HomeViewModel homeViewModel) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<HomeViewModel>.value(value: homeViewModel),
          ChangeNotifierProvider<FavoritesViewModel>(
            create: (_) => FavoritesViewModel(
              favoritesRepository: mockFavoritesRepository,
            ),
          ),
        ],
        child: Scaffold(
          body: Consumer<HomeViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.state == HomeViewState.loading &&
                  viewModel.pokemon.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.state == HomeViewState.error &&
                  viewModel.pokemon.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${viewModel.errorMessage}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => viewModel.refresh(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: viewModel.pokemon.length,
                itemBuilder: (context, index) {
                  return PokemonCard(pokemon: viewModel.pokemon[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  group('HomeScreen Widget Tests', () {
    testWidgets('should show loading indicator initially',
        (WidgetTester tester) async {
      final viewModel = HomeViewModel(pokemonRepository: mockRepository);

      await tester.pumpWidget(createHomeScreenWidget(viewModel));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display Pokemon cards when loaded',
        (WidgetTester tester) async {
      final pokemonList = [
        Pokemon(name: 'pikachu', url: 'url1', imageUrl: 'img1'),
        Pokemon(name: 'charizard', url: 'url2', imageUrl: 'img2'),
      ];

      when(mockRepository.fetchPokemonList(0, 50))
          .thenAnswer((_) async => pokemonList);
      when(mockRepository.prefetchPokemonDetails(any))
          .thenAnswer((_) async {});
      when(mockFavoritesRepository.isFavorite(any))
          .thenAnswer((_) async => false);

      final viewModel = HomeViewModel(pokemonRepository: mockRepository);

      await tester.pumpWidget(createHomeScreenWidget(viewModel));

      await viewModel.loadPokemon();
      await tester.pumpAndSettle();

      expect(find.byType(PokemonCard), findsNWidgets(2));
    });

    testWidgets('should show error message when loading fails',
        (WidgetTester tester) async {
      when(mockRepository.fetchPokemonList(0, 50))
          .thenThrow(Exception('Network error'));

      final viewModel = HomeViewModel(pokemonRepository: mockRepository);

      await tester.pumpWidget(createHomeScreenWidget(viewModel));

      await viewModel.loadPokemon();
      await tester.pumpAndSettle();

      expect(find.text('Error: Exception: Failed to load Pokemon list: Exception: Network error'),
          findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('should retry loading when retry button is tapped',
        (WidgetTester tester) async {
      final pokemonList = [
        Pokemon(name: 'pikachu', url: 'url1', imageUrl: 'img1'),
      ];

      when(mockRepository.fetchPokemonList(0, 50))
          .thenThrow(Exception('Network error'));

      final viewModel = HomeViewModel(pokemonRepository: mockRepository);

      await tester.pumpWidget(createHomeScreenWidget(viewModel));

      await viewModel.loadPokemon();
      await tester.pumpAndSettle();

      expect(find.text('Retry'), findsOneWidget);

      when(mockRepository.fetchPokemonList(0, 50))
          .thenAnswer((_) async => pokemonList);
      when(mockRepository.prefetchPokemonDetails(any))
          .thenAnswer((_) async {});
      when(mockRepository.clearCache()).thenReturn(null);
      when(mockFavoritesRepository.isFavorite(any))
          .thenAnswer((_) async => false);

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.byType(PokemonCard), findsOneWidget);
    });

    testWidgets('should display empty state when no Pokemon',
        (WidgetTester tester) async {
      when(mockRepository.fetchPokemonList(0, 50))
          .thenAnswer((_) async => []);

      final viewModel = HomeViewModel(pokemonRepository: mockRepository);

      await tester.pumpWidget(createHomeScreenWidget(viewModel));

      await viewModel.loadPokemon();
      await tester.pumpAndSettle();

      expect(find.byType(PokemonCard), findsNothing);
    });
  });
}
