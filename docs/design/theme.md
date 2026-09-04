# Theme Configuration System 🌗

Centralized theme management in OpenTrail is handled by `AppTheme` located in `lib/app/theme/app_theme.dart`.

```dart
class AppTheme {
  static ThemeData get lightTheme { ... }
  static ThemeData get darkTheme { ... }
}
```

The theme configuration injects:
- `ColorScheme` generated from seed colors.
- `TextTheme` configured with M3 typography tokens.
- `CardThemeData`, `AppBarTheme`, `InputDecorationTheme`, `ChipThemeData`, and `ButtonThemeData` overrides.
