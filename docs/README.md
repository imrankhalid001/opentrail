# OpenTrail Engineering Documentation Portal 📚

Welcome to the central documentation index for **OpenTrail**.

---

## 📂 Documentation Taxonomy

### 🎯 1. Product & Domain Strategy (`docs/product/`)
- [Product Requirements Document (PRD)](product/PRD.md) — Comprehensive product specifications across 18 core pillars.
- [Product Vision](product/vision.md) — Core principles, privacy mission, and open data commitment.
- [Problem Statement](product/problem-statement.md) — Industry pain points vs the OpenTrail solution.
- [User Personas](product/personas.md) — Target user archetypes (Backpacker, Family Planner, Nomad).
- [User Journeys](product/user-journeys.md) — End-to-end user interaction task flows.
- [Feature Map](product/feature-map.md) — Domain taxonomy & data provider mapping.
- [MVP Definition](product/mvp.md) — Strict MVP vs Post-MVP scope boundaries.
- [Roadmap](product/roadmap.md) — Release phases and milestone timelines.

### 🎨 2. Design System & UI/UX Strategy (`docs/design/`)
- [Design System Specification](design/design-system.md) — Token governance & Material 3 foundation.
- [Color System](design/color-system.md) — Light/Dark palettes and WCAG AA contrast rules.
- [Typography Scale](design/typography.md) — M3 type scale and responsive text behavior.
- [Spacing & Grid](design/spacing.md) — 8pt grid metrics and touch target boundaries.
- [Component Catalog](design/components.md) — 30+ reusable core UI controls in `lib/core/widgets/`.
- [Animations & Motion](design/animations.md) — Timing standards and reduced-motion settings.
- [Accessibility (a11y)](design/accessibility.md) — Semantics, dynamic scaling, and RTL support.
- [Responsive Design](design/responsive-design.md) — Compact, Medium, and Expanded breakpoints.
- [Theme System](design/theme.md) — Centralized `AppTheme` configuration.

### 🏗️ 3. Architecture & Data Flow (`docs/architecture/`)
- [High-Level Architecture](architecture/architecture.md) — Feature-First MVVM + Repository pattern.
- [Architectural Layers](architecture/layers.md) — Responsibilities of View, ViewModel, Repository, Service, Database.
- [Unidirectional Data Flow](architecture/data-flow.md) — State transitions and event flows.
- [Dependency Injection](architecture/dependency-injection.md) — Riverpod provider dependency graph.
- [State Management](architecture/state-management.md) — `AsyncValue<T>` state monad & ViewModel rules.
- [Navigation & Routing](architecture/navigation.md) — GoRouter configuration & deep links.
- [Error Handling](architecture/error-handling.md) — `Result<S, E>` monad and `AppException` hierarchy.
- [Offline-First Engine](architecture/offline-first.md) — Stale-while-revalidate data pipeline.
- [Caching Policy](architecture/caching.md) — Multi-tier TTL cache invalidation matrix.
- [Networking Stack](architecture/networking.md) — Dio HTTP REST client, interceptors, and retries.
- [Local Database](architecture/database.md) — Drift SQLite schema table definitions.
- [Data Models](architecture/models.md) — Freezed immutability & serialization.
- [Folder Structure Guide](architecture/folder-structure.md) — Feature-first directory guidelines.

### 🌐 4. Open API & Data Strategy (`docs/api/`)
- [Data Providers](api/providers.md) — Open-Meteo, OpenStreetMap, Wikipedia, RestCountries.
- [Weather API](api/weather.md) — Open-Meteo parameters & rate limits.
- [Maps & Geocoding](api/maps.md) — OpenStreetMap tiles & Nominatim.
- [Landmarks & Culture](api/places.md) — Wikipedia & Wikidata APIs.
- [Country Intelligence](api/destinations.md) — RestCountries API.
- [Open Data Licensing](api/licensing.md) — ODbL, CC-BY-SA, and attribution compliance.

### 🛠️ 5. Engineering Standards (`docs/engineering/`)
- [Component Reusability](engineering/reusability.md) — 11 reusability rules & naming matrix.
- [Third-Party Dependencies](engineering/dependencies.md) — Dependency evaluation table.
- [Localization Strategy](engineering/localization.md) — ARB translation workflow & RTL support.
- [Code Quality](engineering/code-quality.md) — Static analysis & lint rules.
- [Environment Configuration](engineering/environment.md) — Zero secrets & `--dart-define` parameters.
- [Git Workflow](engineering/git-workflow.md) — Conventional commits & branch model.
- [Development Commands](engineering/development-commands.md) — Essential CLI command cheat sheet.

### 🧪 6. Testing Strategy (`docs/testing/`)
- [Unit Testing](testing/unit-testing.md) — Testing ViewModels, Repositories, and Result monads.
- [Widget Testing](testing/widget-testing.md) — Testing core design system components.
- [Integration Testing](testing/integration-testing.md) — End-to-end trip planning and offline sync.
- [Mocking Strategy](testing/mocking.md) — Provider overrides and service mocks.
- [Test Coverage Policy](testing/test-coverage.md) — Meaningful coverage guidelines.

### 📑 7. Architecture Decision Records (`docs/decisions/`)
- [ADR-0001: Feature-First MVVM Architecture](decisions/ADR-0001-flutter-architecture.md)
- [ADR-0002: Riverpod State Management & DI](decisions/ADR-0002-state-management.md)
- [ADR-0003: GoRouter Declarative Navigation](decisions/ADR-0003-navigation.md)
- [ADR-0004: Dio REST Networking Engine](decisions/ADR-0004-networking.md)
- [ADR-0005: Drift SQLite Local Database](decisions/ADR-0005-local-database.md)
- [ADR-0006: Open Data API Strategy](decisions/ADR-0006-api-strategy.md)
- [ADR-0007: Official Flutter Localization (ARB)](decisions/ADR-0007-localization.md)
- [ADR-0008: Dependency Governance Strategy](decisions/ADR-0008-dependency-strategy.md)
