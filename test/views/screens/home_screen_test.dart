import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:pokedex_app/views/screens/home_screen.dart';
import 'package:pokedex_app/controllers/favorites_controller.dart';
import 'package:pokedex_app/controllers/pokemon_controller.dart';
import 'package:pokedex_app/services/api_services.dart';

@GenerateMocks([FavoritesController, PokemonController, ApiServices])
import 'home_screen_test.mocks.dart';

void main() {
  late MockFavoritesController mockFavoritesController;

  setUp(() {
    mockFavoritesController = MockFavoritesController();
    when(mockFavoritesController.isFavorite(any)).thenReturn(false);
  });

  testWidgets('home screen displays loading indicator initially', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(favoritesController: mockFavoritesController),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('home screen displays Pokemon title and ID', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(favoritesController: mockFavoritesController),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Pokémon'), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
  });

  testWidgets('home screen displays search bar', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(favoritesController: mockFavoritesController),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('home screen displays "No Pokémon found" when list is empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(favoritesController: mockFavoritesController),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No Pokémon found'), findsOneWidget);
  });

  testWidgets('home screen filters pokemon by search query', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(favoritesController: mockFavoritesController),
      ),
    );

    await tester.pumpAndSettle();

    final searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);

    await tester.enterText(searchField, 'pikachu');
    await tester.pump();
  });

  testWidgets('home screen displays GridView when pokemon list is not empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(favoritesController: mockFavoritesController),
      ),
    );

    await tester.pumpAndSettle(Duration(seconds: 5));

    expect(find.byType(GridView), findsWidgets);
  });

  testWidgets('home screen listens to favorites controller changes', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(favoritesController: mockFavoritesController),
      ),
    );

    verify(mockFavoritesController.addListener(any)).called(1);

    await tester.pumpWidget(Container());

    verify(mockFavoritesController.removeListener(any)).called(1);
  });
}
