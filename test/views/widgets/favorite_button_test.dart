import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/views/widgets/favorite_button.dart';

void main() {
  testWidgets('FavoriteButton shows filled icon when favorited',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FavoriteButton.fast(
            isFavorite: true,
            onToggle: () async {},
          ),
        ),
      ),
    );

    
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsNothing);
  });

  testWidgets('FavoriteButton shows border icon when not favorited',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FavoriteButton.fast(
            isFavorite: false,
            onToggle: () async {},
          ),
        ),
      ),
    );

    
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsNothing);
  });

  testWidgets('FavoriteButton triggers callback when tapped',
      (WidgetTester tester) async {
    bool toggled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FavoriteButton.fast(
            isFavorite: false,
            onToggle: () async {
              toggled = true;
            },
          ),
        ),
      ),
    );

    
    await tester.tap(find.byType(FavoriteButton));
    await tester.pumpAndSettle();

    
    expect(toggled, true);
  });
}
