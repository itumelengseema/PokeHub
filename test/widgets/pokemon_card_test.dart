import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';
import 'package:pokedex_app/presentation/viewmodels/favorites_viewmodel.dart';
import 'package:pokedex_app/presentation/widgets/pokemon_card.dart';
import 'package:provider/provider.dart';

import '../mocks/generate_mocks.mocks.dart';

void main() {
  late MockFavoritesRepository mockFavoritesRepository;

  setUp(() {
    mockFavoritesRepository = MockFavoritesRepository();
  });

  Widget createWidgetUnderTest(Pokemon pokemon) {
    when(mockFavoritesRepository.favoritesStream())
        .thenAnswer((_) => Stream.value([]));

    return MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider<FavoritesViewModel>(
          create: (_) => FavoritesViewModel(
            favoritesRepository: mockFavoritesRepository,
          ),
          child: PokemonCard(pokemon: pokemon),
        ),
      ),
    );
  }

  group('PokemonCard Widget Tests', () {
    testWidgets('should display Pokemon name and ID',
        (WidgetTester tester) async {
      final pokemon = Pokemon(
        name: 'pikachu',
        url: 'https://pokeapi.co/api/v2/pokemon/25/',
      );

      when(mockFavoritesRepository.isFavorite('25'))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(createWidgetUnderTest(pokemon));
      await tester.pumpAndSettle();

      expect(find.text('Pikachu'), findsOneWidget);
      expect(find.text('#025'), findsOneWidget);
    });

    testWidgets('should display Pokemon image when imageUrl is provided',
        (WidgetTester tester) async {
      final pokemon = Pokemon(
        name: 'pikachu',
        url: 'https://pokeapi.co/api/v2/pokemon/25/',
        imageUrl: 'https://example.com/pikachu.png',
      );

      when(mockFavoritesRepository.isFavorite('25'))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(createWidgetUnderTest(pokemon));
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should display placeholder icon when imageUrl is null',
        (WidgetTester tester) async {
      final pokemon = Pokemon(
        name: 'pikachu',
        url: 'https://pokeapi.co/api/v2/pokemon/25/',
      );

      when(mockFavoritesRepository.isFavorite('25'))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(createWidgetUnderTest(pokemon));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.catching_pokemon), findsOneWidget);
    });

    testWidgets('should display favorite button',
        (WidgetTester tester) async {
      final pokemon = Pokemon(
        name: 'pikachu',
        url: 'https://pokeapi.co/api/v2/pokemon/25/',
      );

      when(mockFavoritesRepository.isFavorite('25'))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(createWidgetUnderTest(pokemon));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('should show filled heart when Pokemon is favorite',
        (WidgetTester tester) async {
      final pokemon = Pokemon(
        name: 'pikachu',
        url: 'https://pokeapi.co/api/v2/pokemon/25/',
      );

      when(mockFavoritesRepository.isFavorite('25'))
          .thenAnswer((_) async => true);

      await tester.pumpWidget(createWidgetUnderTest(pokemon));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('should extract ID correctly with padding zeros',
        (WidgetTester tester) async {
      final pokemon1 = Pokemon(
        name: 'bulbasaur',
        url: 'https://pokeapi.co/api/v2/pokemon/1/',
      );

      when(mockFavoritesRepository.isFavorite('1'))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(createWidgetUnderTest(pokemon1));
      await tester.pumpAndSettle();

      expect(find.text('#001'), findsOneWidget);

      final pokemon150 = Pokemon(
        name: 'mewtwo',
        url: 'https://pokeapi.co/api/v2/pokemon/150/',
      );

      when(mockFavoritesRepository.isFavorite('150'))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(createWidgetUnderTest(pokemon150));
      await tester.pumpAndSettle();

      expect(find.text('#150'), findsOneWidget);
    });

    testWidgets('should capitalize first letter of Pokemon name',
        (WidgetTester tester) async {
      final pokemon = Pokemon(
        name: 'charizard',
        url: 'https://pokeapi.co/api/v2/pokemon/6/',
      );

      when(mockFavoritesRepository.isFavorite('6'))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(createWidgetUnderTest(pokemon));
      await tester.pumpAndSettle();

      expect(find.text('Charizard'), findsOneWidget);
      expect(find.text('charizard'), findsNothing);
    });

    testWidgets('should use Hero widget for image animation',
        (WidgetTester tester) async {
      final pokemon = Pokemon(
        name: 'pikachu',
        url: 'https://pokeapi.co/api/v2/pokemon/25/',
        imageUrl: 'https://example.com/pikachu.png',
      );

      when(mockFavoritesRepository.isFavorite('25'))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(createWidgetUnderTest(pokemon));
      await tester.pumpAndSettle();

      final heroFinder = find.byType(Hero);
      expect(heroFinder, findsOneWidget);

      final hero = tester.widget<Hero>(heroFinder);
      expect(hero.tag, 'pokemon_25');
    });

    testWidgets('should have rounded corners container',
        (WidgetTester tester) async {
      final pokemon = Pokemon(
        name: 'pikachu',
        url: 'https://pokeapi.co/api/v2/pokemon/25/',
      );

      when(mockFavoritesRepository.isFavorite('25'))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(createWidgetUnderTest(pokemon));
      await tester.pumpAndSettle();

      final containerFinder = find.descendant(
        of: find.byType(GestureDetector),
        matching: find.byType(Container),
      );

      expect(containerFinder, findsWidgets);

      final container = tester.widget<Container>(containerFinder.first);
      expect(container.decoration, isA<BoxDecoration>());

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, isNotNull);
    });
  });
}
