# Localization & RTL Strategy 🌍

OpenTrail uses Flutter's official localization framework (`flutter_localizations` + `intl`) driven by `.arb` translation resource files located in `lib/l10n/`.

---

## 1. Supported Locales

- **English (`en`)**: Primary default language (`app_en.arb`).
- **Urdu (`ur`)**: Regional language support (`app_ur.arb`).
- **Arabic (`ar`)**: Native Right-To-Left (RTL) layout support (`app_ar.arb`).
- **Japanese (`ja`)**: Asian typography and character support (`app_ja.arb`).

---

## 2. ARB Translation Workflow

1. Base strings are defined in `lib/l10n/app_en.arb`:
   ```json
   {
     "appTitle": "OpenTrail",
     "exploreTitle": "Explore Destinations",
     "weatherTitle": "Weather Forecast",
     "myTripsTitle": "My Trips",
     "favoritesTitle": "Favorites",
     "settingsTitle": "Settings"
   }
   ```
2. Flutter's build tool generates type-safe localization classes in `AppLocalizations`.
3. UI widgets access localized strings via `AppLocalizations.of(context)!.exploreTitle` or context extension helpers (`context.l10n.exploreTitle`).
4. **Zero Hardcoded Strings Rule**: User-facing text string literals inside Flutter widgets are strictly prohibited.
