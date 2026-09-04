# ADR-0002: Riverpod for State Management & Dependency Injection

## Context
OpenTrail needs a compile-time safe, declarative state management and dependency injection solution that integrates seamlessly with Flutter widgets and supports effortless mocking during unit/widget testing.

## Decision
Select **Riverpod (v2.x)** as the application's unified State Management and Dependency Injection framework.

## Alternatives Considered
1. *Provider*: Lacks compile-time safety; prone to `ProviderNotFoundException` during runtime route changes.
2. *Bloc / Cubit*: High boilerplate requirements for simple state updates.
3. *GetX*: Bypasses standard Flutter framework mechanics and relies on implicit global singletons.

## Consequences
- Compile-time safety for all dependencies.
- Native `AsyncValue` support for UI loading, data, and error states.
- Easy testing via `ProviderContainer` overrides.
