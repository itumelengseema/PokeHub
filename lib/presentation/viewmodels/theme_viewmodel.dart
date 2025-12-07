import 'package:flutter/foundation.dart';
import 'package:pokedex_app/core/theme/app_theme.dart';

class ThemeViewModel extends ChangeNotifier {
  AppTheme _currentTheme = AppTheme.light;

  AppTheme get currentTheme => _currentTheme;

  bool get isDarkMode => _currentTheme == AppTheme.dark;

  void toggleTheme() {
    _currentTheme = _currentTheme == AppTheme.light ? AppTheme.dark : AppTheme.light;
    notifyListeners();
  }

  void setTheme(AppTheme theme) {
    if (_currentTheme != theme) {
      _currentTheme = theme;
      notifyListeners();
    }
  }

  void setLightTheme() {
    setTheme(AppTheme.light);
  }

  void setDarkTheme() {
    setTheme(AppTheme.dark);
  }
}
