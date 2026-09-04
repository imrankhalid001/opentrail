# Architectural Layers & Responsibilities 🧅

## 1. Presentation Layer (View & ViewModel)
- **View (Flutter Widgets)**: Purely presentation-focused. Renders UI based on immutable state emitted by the ViewModel. Contains zero business logic or REST/DB calls.
- **ViewModel (Riverpod Notifier / AsyncNotifier)**: Holds presentation state, converts domain data into UI-ready models, handles user interactions, and invokes Repository methods.

## 2. Domain / Business Layer (Optional Use-Cases)
- Simple CRUD operations flow directly from ViewModel to Repository.
- Domain Use-Cases (`use_cases/`) are introduced **only** when complex multi-repository orchestration or heavy domain validation is required (e.g., calculating trip cost budgets against multi-currency weather forecasts).

## 3. Data Layer (Repository, Service, Local DB)
- **Repository**: Manages data fetching strategies (e.g., Cache-First, Network-First), synchronizes local SQLite storage with REST responses, and returns `Result<T, Exception>`.
- **Remote Service**: Handles HTTP REST requests using Dio, converts JSON maps to DTO models, and throws typed `NetworkException` instances.
- **Local Database**: Handles SQLite operations via Drift or key-value settings via Shared Preferences.
