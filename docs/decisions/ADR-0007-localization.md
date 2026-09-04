# ADR-0007: Official Flutter Localization (ARB) for Multi-Language Support

## Context
OpenTrail requires multi-language support (English, Urdu, Arabic RTL, Japanese) from day one.

## Decision
Use Flutter's official `flutter_localizations` package and Application Resource Bundle (`.arb`) files.

## Alternatives Considered
1. *easy_localization*: Custom third-party JSON loader adding runtime reflection overhead.

## Consequences
- Native integration with Flutter tooling.
- Compile-time generated `AppLocalizations` class.
