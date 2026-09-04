# Scalable Feature-First Folder Structure 📁

OpenTrail organizes code using a **Scalable Feature-First Architecture** combined with MVVM. Code is organized primarily by business feature domain rather than layer type.

---

## 1. High-Level Project Directory Layout

```
lib/
├── app/                        # Application Shell & Core Configuration
│   ├── app.dart                # Root MaterialApp.router widget
│   ├── config/                 # Environment variables & runtime configurations
│   ├── di/                     # Global Riverpod provider declarations
│   ├── router/                 # GoRouter route declarations & navigation shell
│   └── theme/                  # Material 3 Design Tokens (Colors, Typography, Spacing, Theme)
│
├── core/                       # Shared Framework Infrastructure & UI Components
│   ├── constants/              # System-wide app constants & storage keys
│   ├── database/               # Drift SQLite database schema & migrations
│   ├── errors/                 # Strongly typed AppException hierarchy
│   ├── extensions/             # Dart & BuildContext utility extensions
│   ├── localization/           # Locale resolution & translation helpers
│   ├── logging/                # AppLogger formatting wrapper
│   ├── networking/             # Dio HTTP REST client, interceptors, & cache
│   ├── result/                 # Result<S, E extends Exception> Monad
│   ├── utils/                  # Single-purpose formatters (e.g., date_formatter.dart)
│   └── widgets/                # Reusable Design System Component Library
│
├── features/                   # Modular Feature Domains
│   ├── explore/                # Destination discovery feed & trending spots
│   ├── destinations/           # Country details, culture, currency, emergency info
│   ├── places/                 # POI search & category filtering (culture, food, nature)
│   ├── search/                 # Unified global search across destinations & POIs
│   ├── weather/                # Live forecasts, hourly curves, monthly climate
│   ├── map/                    # Vector map tile viewer, gestures, location pin
│   ├── trips/                  # Trip builder, dashboard, itinerary timeline
│   ├── favorites/              # Saved bookmarks & quick offline access tab
│   ├── packing/                # Smart packing checklists & custom items
│   ├── journey/                # Travel stats, visited countries, achievement badges
│   └── settings/               # App theme toggle, unit system, language picker
│
├── l10n/                       # Localization Translation Sources (.arb)
│   ├── app_en.arb
│   ├── app_ur.arb
│   ├── app_ar.arb
│   └── app_ja.arb
│
└── main.dart                   # Application Entry Point
```

---

## 2. Internal Feature Directory Structure

Each feature module under `lib/features/<feature_name>/` is internally organized by architectural layer responsibility:

```
features/<feature_name>/
├── data/
│   ├── models/                 # Freezed data models & DTO JSON converters
│   ├── repositories/           # Repository interface implementation & caching logic
│   └── services/               # Dio REST API service client calls
└── presentation/
    ├── screens/                # Main Flutter screen widgets
    ├── view_models/            # Riverpod Notifier / AsyncNotifier ViewModels
    └── widgets/                # Feature-scoped UI widgets
```

### Domain Layer (Optional)
If a feature requires complex multi-repository orchestration or heavy business validation, an optional `domain/` folder may be introduced:

```
features/<feature_name>/
└── domain/
    ├── entities/               # Pure business entities
    ├── repositories/           # Repository interfaces
    └── use_cases/              # Complex domain logic use-cases
```

> [!IMPORTANT]
> **No Empty Folders Policy**: Directories are created only when source code files actually exist within them. Do not create empty placeholder folders.

---

## 3. Component & Utility Placement Rules

1. **Truly Shared UI Controls**: Widgets used across 2 or more features belong inside `lib/core/widgets/` (e.g., `AppButton`, `AppCard`, `AppSearchBar`).
2. **Feature-Scoped UI Controls**: Widgets specific to a single feature remain inside `lib/features/<feature_name>/presentation/widgets/`.
3. **Single-Purpose Utilities**: Place utility functions in small, dedicated files inside `lib/core/utils/` (e.g., `date_formatter.dart`, `currency_formatter.dart`). Do not create a generic `utils.dart` dumping ground.
4. **File Naming Conventions**: All files use `snake_case` (e.g., `destination_detail_screen.dart`, `weather_repository.dart`). Class names use `PascalCase` (e.g., `DestinationDetailScreen`, `WeatherRepository`).
