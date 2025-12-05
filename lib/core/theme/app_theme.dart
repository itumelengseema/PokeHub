import 'package:flutter/material.dart';

enum AppTheme {
  light,
  dark,
  system;

  
  ThemeMode get themeMode {
    switch (this) {
      case AppTheme.light:
        return ThemeMode.light;
      case AppTheme.dark:
        return ThemeMode.dark;
      case AppTheme.system:
        return ThemeMode.system;
    }
  }

  String get displayName {
    switch (this) {
      case AppTheme.light:
        return 'Light';
      case AppTheme.dark:
        return 'Dark';
      case AppTheme.system:
        return 'System';
    }
  }

  String get iconName {
    switch (this) {
      case AppTheme.light:
        return 'light_mode';
      case AppTheme.dark:
        return 'dark_mode';
      case AppTheme.system:
        return 'brightness_auto';
    }
  }


  bool get isDarkMode => this == AppTheme.dark;


  bool get isLightMode => this == AppTheme.light;


  bool get isSystemMode => this == AppTheme.system;
}
