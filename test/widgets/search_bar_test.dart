import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/presentation/widgets/search_bar.dart';

void main() {
  group('PokemonSearchBar Widget Tests', () {
    late TextEditingController controller;
    late List<String> searchedValues;

    setUp(() {
      controller = TextEditingController();
      searchedValues = [];
    });

    tearDown(() {
      controller.dispose();
    });

    Widget createWidgetUnderTest({String hintText = 'Search Pokemon'}) {
      return MaterialApp(
        home: Scaffold(
          body: PokemonSearchBar(
            controller: controller,
            hintText: hintText,
            onSearch: (value) {
              searchedValues.add(value);
            },
          ),
        ),
      );
    }

    testWidgets('should display hint text', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(hintText: 'Search Pokemon'));

      expect(find.text('Search Pokemon'), findsOneWidget);
    });

    testWidgets('should display search icon', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should call onSearch when text changes',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextField), 'pikachu');
      await tester.pump();

      expect(searchedValues, contains('pikachu'));
    });

    testWidgets('should check clear button visibility logic',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byIcon(Icons.clear), findsNothing);
      expect(controller.text.isEmpty, true);
    });

    testWidgets('should have rounded border', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration as InputDecoration;
      final border = decoration.border as OutlineInputBorder;

      expect(border.borderRadius, BorderRadius.circular(12));
      expect(border.borderSide, BorderSide.none);
    });

    testWidgets('should have correct padding', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration as InputDecoration;

      expect(
        decoration.contentPadding,
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );
    });

    testWidgets('should be filled with color', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final textField = tester.widget<TextField>(find.byType(TextField));
      final decoration = textField.decoration as InputDecoration;

      expect(decoration.filled, true);
      expect(decoration.fillColor, isNotNull);
    });

    testWidgets('should update when text is entered',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextField), 'charizard');
      await tester.pumpAndSettle();

      expect(find.text('charizard'), findsOneWidget);
      expect(controller.text, 'charizard');
    });

    testWidgets('should handle multiple text changes',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(find.byType(TextField), 'p');
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'pi');
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'pik');
      await tester.pump();

      expect(searchedValues, ['p', 'pi', 'pik']);
    });
  });
}
