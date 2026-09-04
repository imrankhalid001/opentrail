# OpenTrail 🗺️✨

[![Flutter Version](https://img.shields.io/badge/Flutter-3.47.2-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.13.2-0175C2?logo=dart)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

OpenTrail is an **open-source, feature-rich, UI/UX-first travel intelligence application** built with Flutter and Dart. Designed to showcase modern mobile engineering practices, offline-first data architecture, and elegant user experiences, OpenTrail provides seamless destination discovery, offline maps, weather insights, itinerary planning, packing assistance, and travel analytics.

---

## 🌟 Highlights & Features

- 🌍 **Destination Discovery**: Rich intelligence on countries, cities, landmarks, and local culture powered by open data.
- 🗺️ **Interactive & Offline Maps**: Vector map tile rendering, POI exploration, and offline map region downloads.
- 🌤️ **Live Weather & Climate Insights**: Hourly forecasts, historical climate patterns, and packing recommendations via Open-Meteo.
- 📝 **Drag-and-Drop Itinerary Planner**: Interactive day-by-day trip planning with offline synchronization.
- 🧳 **Smart Packing Lists**: Category-driven packing checklists tailored to destination weather and activities.
- 🏆 **Travel Statistics & Achievements**: Personal travel milestones, country scratch-off counters, and privacy-first local analytics.
- ⚡ **Offline-First Data Engine**: Local SQLite caching with Drift ensuring 100% functionality without network connectivity.
- 🎨 **Material 3 Design System**: Dark/Light mode support, fluid micro-interactions, responsive cross-device layout, and accessibility (WCAG AA).
- 🌐 **Localization Ready**: Native multi-language foundation supporting English, Urdu, Arabic (RTL), and Japanese.

---

## 🏗️ Architecture Overview

OpenTrail uses a **Feature-First Architecture** combined with **MVVM (Model-View-ViewModel)** and the **Repository Pattern**.

```
┌─────────────────────────────────────────────────────────────┐
│                       Presentation                          │
│               Widgets & Views  <───>  ViewModels            │
└──────────────────────────────┬──────────────────────────────┘
                               │ Reads / Emits State
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                        Repositories                         │
│     (Single Source of Truth & Offline Sync Strategy)         │
└──────────────────────────────┬──────────────────────────────┘
                               │
            ┌──────────────────┴──────────────────┐
            ▼                                     ▼
┌───────────────────────────────┐   ┌──────────────────────────┐
│        Remote Services        │   │      Local Database      │
│ (Dio REST APIs: Open-Meteo,   │   │  (Drift SQL, SharedPrefs │
│  Wikimedia, OpenStreetMap)    │   │      Key-Value Cache)    │
└───────────────────────────────┘   └──────────────────────────┘
```

### Key Architectural Tenets
1. **Repositories as Truth**: Presentation components interact strictly with Repositories.
2. **Feature Isolation**: Code is organized into standalone features (`explore`, `weather`, `map`, `trips`, etc.).
3. **Unidirectional Data Flow**: UI reacts to immutable state streams exposed by Riverpod ViewModels.
4. **Strong Typing & Result Types**: Operations return sealed `Result<T, Exception>` types to guarantee explicit error handling.

---

## 🧰 Technology Stack

| Domain | Technology / Library | Reason |
| :--- | :--- | :--- |
| **Framework** | [Flutter 3.47.2](https://flutter.dev) | Cross-platform UI engine |
| **Language** | [Dart 3.13.2](https://dart.dev) | Sound null-safety, pattern matching |
| **State Management** | [Riverpod 2.x](https://riverpod.dev) | Compile-safe, declarative state management |
| **Routing** | [GoRouter](https://pub.dev/packages/go_router) | Declarative routing & deep linking |
| **Networking** | [Dio](https://pub.dev/packages/dio) | Interceptors, retries, and cancellation tokens |
| **Local Database** | [Drift](https://drift.simonbinder.eu) | Type-safe reactive SQLite persistence |
| **Models & Codegen** | [Freezed](https://pub.dev/packages/freezed) | Immutable data classes & pattern matching |
| **Localization** | `flutter_localizations` & ARB | Official Flutter i18n support |

---

## 🌐 Open API & Data Attribution

OpenTrail is built strictly using free, open, and community-driven data sources:

- **Weather Data**: [Open-Meteo](https://open-meteo.com) (*Non-commercial / Commercial Open License*)
- **Geographic & POI Data**: [OpenStreetMap](https://www.openstreetmap.org/) & [Nominatim](https://nominatim.org) (*ODbL*)
- **Landmarks & Cultural Intelligence**: [Wikipedia API](https://www.mediawiki.org/wiki/API:Main_page) & [Wikimedia Commons](https://commons.wikimedia.org) (*CC-BY-SA 3.0*)
- **Country Metadata**: [REST Countries](https://restcountries.com) (*MPL 2.0*)

---

## 📁 Directory Structure

```
lib/
├── app/                  # Application Shell, Router, Theme, & DI
│   ├── app.dart
│   ├── router/
│   └── theme/
├── core/                 # Shared Utilities, Design System, & Core Logic
│   ├── errors/           # Typed Exception Hierarchy
│   ├── logging/          # Unified App Logger
│   ├── result/           # Result<T, Exception> Monad
│   └── widgets/          # Reusable Design System Component Library
├── features/             # Feature Modules (Feature-First)
│   ├── explore/
│   ├── weather/
│   ├── map/
│   ├── trips/
│   ├── favorites/
│   └── packing/
└── l10n/                 # Localization Catalogs (.arb files)
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`3.47.2` or compatible 3.x release)
- [Dart SDK](https://dart.dev/get-dart) (`3.13.2` or higher)

### Installation & Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/opentrail/opentrail.git
   cd opentrail
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Copy environment template**:
   ```bash
   cp .env.example .env
   ```

4. **Verify static analysis & run tests**:
   ```bash
   flutter analyze
   flutter test
   ```

5. **Run the application**:
   ```bash
   flutter run
   ```

---

## 🗺️ Product Roadmap

- [x] **Phase 0 — Project Foundation & Engineering Architecture**: Design system, docs, folder structure, CI validation, and state management rules.
- [ ] **Milestone 1 — Destination Intelligence & Explore**: Discovery feeds, country details, and Wikipedia integration.
- [ ] **Milestone 2 — Live Weather Engine**: Open-Meteo multi-city forecasting and climate charts.
- [ ] **Milestone 3 — Interactive Map & Places**: OpenStreetMap tile viewer, POI search, and geocoding.
- [ ] **Milestone 4 — Trip Planning & Offline Sync**: Itinerary creation, drag-and-drop builder, and Drift local storage.
- [ ] **Milestone 5 — Packing, Achievements & Localization**: Smart checklists, travel counters, RTL support (Urdu/Arabic), and Japanese translation.

---

## 🤝 Contributing

We welcome contributions from the open-source community! Please review our [Contribution Guidelines](CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md) before submitting pull requests.

For AI Coding Agents operating on this project, please strictly follow the guidelines detailed in [GEMINI.md](GEMINI.md).

---

## 📄 License

OpenTrail is released under the [MIT License](LICENSE).
