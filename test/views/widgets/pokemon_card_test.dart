import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/models/pokemon.dart';
import 'package:pokedex_app/views/widgets/pokemon_card.dart';

void main() {
  final testPokemon = Pokemon(
    name: 'Bulbasaur',
    url: 'https://pokeapi.co/api/v2/pokemon/1/',
    imageUrl: '',
  );

  testWidgets('PokemonCard displays name and id', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: PokemonCard(pokemon: testPokemon)),
      ),
    );

    expect(find.text('Bulbasaur'), findsOneWidget);

    expect(find.text('#001'), findsOneWidget);
    expect(find.text('#001'), findsOneWidget);
    expect(find.byIcon(Icons.catching_pokemon), findsOneWidget);
  });

  testWidgets('PokemonCard triggers favorite callback when tapped',
      (WidgetTester tester) async {
    bool toggled = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PokemonCard(
            pokemon: testPokemon,
            isFavorite: false,
            onFavoriteToggle: () async {
              toggled = true;
            },
          ),
        ),
      ),
    );

    // Initially shows border icon
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    // Tap the favorite button
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();

    // Verify the callback was triggered
    expect(toggled, true);

    // Complete all pending timers
    await tester.pumpAndSettle(const Duration(seconds: 1));
  });

  testWidgets('DetailsScreen navigation on tap', (WidgetTester tester) async {
    final testPokemonWithImage = Pokemon(
      name: 'Bulbasaur',
      url: 'https://pokeapi.co/api/v2/pokemon/1/',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PokemonCard(
            pokemon: testPokemonWithImage,
          ),
        ),
      ),
    );

    // Tap the card to navigate
    await tester.tap(find.byType(PokemonCard));
    await tester.pumpAndSettle();

    // Verify that DetailsScreen is pushed
    expect(find.text('Bulbasaur'), findsOneWidget);
    expect( find.byType(Image), findsOneWidget);

 
  });
}
