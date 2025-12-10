import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/core/theme/app_theme.dart';
import 'package:pokedex_app/presentation/viewmodels/theme_viewmodel.dart';

void main() {
  late ThemeViewModel viewModel;

  setUp(() {
    viewModel = ThemeViewModel();
  });

  group('ThemeViewModel Tests', () {
    test('should initialize with light theme', () {
      expect(viewModel.currentTheme, AppTheme.light);
      expect(viewModel.isDarkMode, false);
    });

    test('should toggle theme from light to dark', () {
      expect(viewModel.currentTheme, AppTheme.light);

      viewModel.toggleTheme();

      expect(viewModel.currentTheme, AppTheme.dark);
      expect(viewModel.isDarkMode, true);
    });

    test('should toggle theme from dark to light', () {
      viewModel.setDarkTheme();
      expect(viewModel.currentTheme, AppTheme.dark);

      viewModel.toggleTheme();

      expect(viewModel.currentTheme, AppTheme.light);
      expect(viewModel.isDarkMode, false);
    });

    test('should set theme to light', () {
      viewModel.setDarkTheme();

      viewModel.setLightTheme();

      expect(viewModel.currentTheme, AppTheme.light);
      expect(viewModel.isDarkMode, false);
    });

    test('should set theme to dark', () {
      viewModel.setDarkTheme();

      expect(viewModel.currentTheme, AppTheme.dark);
      expect(viewModel.isDarkMode, true);
    });

    test('should set theme directly', () {
      viewModel.setTheme(AppTheme.dark);
      expect(viewModel.currentTheme, AppTheme.dark);

      viewModel.setTheme(AppTheme.light);
      expect(viewModel.currentTheme, AppTheme.light);
    });

    test('should not notify listeners if theme is already set', () {
      int listenerCallCount = 0;
      viewModel.addListener(() {
        listenerCallCount++;
      });

      viewModel.setTheme(AppTheme.light);
      expect(listenerCallCount, 0);

      viewModel.setTheme(AppTheme.dark);
      expect(listenerCallCount, 1);

      viewModel.setTheme(AppTheme.dark);
      expect(listenerCallCount, 1);
    });

    test('should notify listeners on theme change', () {
      bool listenerCalled = false;
      viewModel.addListener(() {
        listenerCalled = true;
      });

      viewModel.toggleTheme();

      expect(listenerCalled, true);
    });

    test('should notify listeners when setting theme to different value', () {
      int listenerCallCount = 0;
      viewModel.addListener(() {
        listenerCallCount++;
      });

      viewModel.setLightTheme();
      expect(listenerCallCount, 0);

      viewModel.setDarkTheme();
      expect(listenerCallCount, 1);

      viewModel.setLightTheme();
      expect(listenerCallCount, 2);
    });
  });
}
