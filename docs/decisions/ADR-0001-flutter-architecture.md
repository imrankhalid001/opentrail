# ADR-0001: Feature-First MVVM + Repository Pattern

## Context
OpenTrail requires a scalable, maintainable application architecture that can accommodate multiple independent travel features (weather, maps, itinerary planning, destination intelligence) without creating tight coupling or bloated files.

## Decision
Adopt **Feature-First Architecture** paired with **MVVM (Model-View-ViewModel)** and the **Repository Pattern**.

## Alternatives Considered
1. *Layer-First Architecture*: Grouping files by layer (`lib/views/`, `lib/controllers/`, `lib/models/`). Rejected due to poor maintainability as the project grows.
2. *Clean Architecture with Use-Cases everywhere*: Rejected because mandatory Use-Case classes create excessive boilerplate for simple CRUD operations. Use-Cases will only be introduced for complex domain workflows.

## Consequences
- High feature isolation — features can be modified independently.
- Clean separation between UI (View) and business logic (ViewModel / Repository).
- Explicit data flow and testability.
