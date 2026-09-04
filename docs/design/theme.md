# Theme Configuration System 🌗

Centralized theme management in OpenTrail is handled by `AppTheme` located in `lib/app/theme/app_theme.dart`.

---

## 1. Supported Theme Modes

- **Light Mode**: Bright nature-inspired Material 3 surfaces for outdoor readability.
- **Dark Mode**: Low-power OLED dark surfaces (`#101413`) for night travel and reduced battery consumption.
- **System Theme**: Automatically tracks host OS theme preferences.

---

## 2. Token Injection & Customizations

```dart
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColors.lightColorScheme,
      textTheme: AppTypography.textTheme,
      cardTheme: const CardThemeData(elevation: 1, margin: EdgeInsets.all(8)),
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: AppColors.darkColorScheme,
      textTheme: AppTypography.textTheme,
      cardTheme: const CardThemeData(elevation: 1, margin: EdgeInsets.all(8)),
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
    );
  }
}
```
