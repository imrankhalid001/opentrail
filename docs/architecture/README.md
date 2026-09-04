# OpenTrail System Architecture 🏗️

Welcome to the **Architecture Documentation** for OpenTrail. This directory provides detailed specifications for our feature-first MVVM architecture, state management, networking stack, local database design, offline synchronization, and security model.

---

## 📄 Architecture Documentation Index

1. [High-Level Architecture](architecture.md) — System overview and core patterns.
2. [Architectural Layers](layers.md) — Responsibilities of View, ViewModel, Repository, Service, Database layers.
3. [Unidirectional Data Flow](data-flow.md) — State transitions and data event flows.
4. [Dependency Injection](dependency-injection.md) — Riverpod provider dependency graph.
5. [State Management](state-management.md) — `AsyncValue`, `Notifier`, and presentation state rules.
6. [Navigation & Routing](navigation.md) — GoRouter configuration, deep links, modal stack.
7. [Error Handling Strategy](error-handling.md) — `Result<T, Exception>` monad and typed `AppException`.
8. [Offline-First Engine](offline-first.md) — Remote -> Local Cache -> UI sync strategy.
9. [Caching & Invalidations](caching.md) — Time-to-live (TTL) and stale-while-revalidate rules.
10. [Networking Stack](networking.md) — Dio REST HTTP client, interceptors, rate limiting.
11. [Local Database](database.md) — Drift SQLite schema, migrations, indexing.
12. [Data Models](models.md) — Immutability, Freezed generation, JSON serialization.
13. [Testing Strategy](testing.md) — Unit, Widget, Integration test requirements.
14. [Performance Optimization](performance.md) — Rendering budgets, memory management, image caching.
15. [Security & Encryption](security.md) — Local key storage, SSL pinning, privacy rules.
16. [Folder Structure Guide](folder-structure.md) — Feature-first directory guidelines.
