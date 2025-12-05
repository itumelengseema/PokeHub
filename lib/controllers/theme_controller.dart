import 'package:flutter/foundation.dart';
import 'package:pokedex_app/core/theme/app_theme.dart';

/// ThemeController manages the app's theme state.
/// Uses ValueNotifier for efficient rebuilds - only widgets listening to this
/// notifier will rebuild, not the entire app.
///
/// Follows Single Responsibility Principle - only manages theme state.
/// Follows Dependency Inversion Principle - depends on AppTheme abstraction.
class ThemeController {
  // Using ValueNotifier instead of ChangeNotifier for more granular control
  final ValueNotifier<AppTheme> _themeNotifier = ValueNotifier(AppTheme.light);

  /// Public getter for theme value notifier
  /// Widgets can listen to this without rebuilding parent widgets
  ValueListenable<AppTheme> get themeNotifier => _themeNotifier;

  /// Current theme value
  AppTheme get currentTheme => _themeNotifier.value;

  /// Check if current theme is dark mode
  bool get isDarkMode => _themeNotifier.value.isDarkMode;

  /// Check if current theme is light mode
  bool get isLightMode => _themeNotifier.value.isLightMode;

  /// Check if current theme is system mode
  bool get isSystemMode => _themeNotifier.value.isSystemMode;

  /// Toggle between light and dark themes
  void toggleTheme() {
    _themeNotifier.value = _themeNotifier.value == AppTheme.light
        ? AppTheme.dark
        : AppTheme.light;
  }

  /// Set a specific theme
  void setTheme(AppTheme theme) {
    if (_themeNotifier.value != theme) {
      _themeNotifier.value = theme;
    }
  }

  /// Dispose the notifier when controller is no longer needed
  void dispose() {
    _themeNotifier.dispose();
  }
}
