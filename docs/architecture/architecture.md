# High-Level System Architecture 🏛️

OpenTrail strictly enforces a **Feature-First MVVM Architecture** combined with the **Repository Pattern** and **Unidirectional Data Flow**.

```
┌────────────────────────────────────────────────────────────────────────┐
│                          PRESENTATION LAYER                            │
│                                                                        │
│   ┌───────────────────────────┐         ┌──────────────────────────┐   │
│   │       Flutter View        │ ──────> │        ViewModel         │   │
│   │ (Declarative UI Widgets)  │ <────── │  (Riverpod Notifier)     │   │
│   └───────────────────────────┘  State  └────────────┬─────────────┘   │
└──────────────────────────────────────────────────────┼─────────────────┘
                                                       │ Invokes Repository
                                                       ▼
┌────────────────────────────────────────────────────────────────────────┐
│                             DATA LAYER                                 │
│                                                                        │
│                       ┌─────────────────────────┐                      │
│                       │       Repository        │                      │
│                       │ (Single Source of Truth)│                      │
│                       └────────────┬────────────┘                      │
│                                    │                                   │
│                 ┌──────────────────┴──────────────────┐                │
│                 ▼                                     ▼                │
│     ┌───────────────────────┐             ┌──────────────────────┐     │
│     │    Remote Service     │             │    Local Database    │     │
│     │ (Dio REST API Engine) │             │ (Drift SQLite / SP)  │     │
│     └───────────────────────┘             └──────────────────────┘     │
└────────────────────────────────────────────────────────────────────────┘
```

## Core Architectural Principles

### 1. Feature-First Isolation
Each application feature (`explore`, `weather`, `map`, `trips`, `favorites`, `packing`) is a self-contained module located under `lib/features/<feature_name>/`. Features manage their own presentation (screens, widgets, ViewModels), repository implementations, and remote services.

### 2. Repositories as the Single Source of Truth
UI widgets and ViewModels **never** query REST APIs or SQLite databases directly. Repositories abstract all external data sources, manage Stale-While-Revalidate caching rules, synchronize remote data with local storage, and return `Result<T, Exception>`.

### 3. Unidirectional Data Flow
State flows downward from ViewModels to Views via Riverpod's `ref.watch()`. User interactions (button taps, text inputs) trigger method calls upward from Views to ViewModels.

### 4. Explicit Result Monad
All asynchronous repository operations return `Result<S, E extends Exception>` (`Success` or `Failure`). This guarantees compile-time exhaustive handling of success and failure branches, preventing raw unhandled exceptions in the presentation layer.

### 5. Pragmatic Domain Layer
By default, ViewModels communicate directly with Repositories. Domain use-cases (`use_cases/`) are introduced **only** when complex multi-repository orchestration or heavy domain validation is genuinely required.
