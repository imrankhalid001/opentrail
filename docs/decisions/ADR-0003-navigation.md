# ADR-0003: GoRouter for Declarative Navigation & Deep Linking

## Context
OpenTrail requires declarative navigation, deep linking support (for sharing destination links), and shell routing (for persistent bottom navigation bars).

## Decision
Use **GoRouter** as the official declarative routing engine.

## Alternatives Considered
1. *Imperative Navigator 1.0*: Difficult to handle deep links and web URLs cleanly.
2. *AutoRoute*: Requires heavy code generation for every route.

## Consequences
- Declarative route definitions integrated directly with Riverpod (`appRouterProvider`).
- Clean URL/path parameter handling for destinations (`/destination/:id`).
