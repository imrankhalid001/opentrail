# ADR-0004: Dio HTTP Client Stack for Open REST APIs

## Context
OpenTrail communicates with multiple external open REST APIs (Open-Meteo, Wikipedia, RestCountries, Nominatim). The networking layer needs robust interceptors, timeout handling, exponential retry logic, and request cancellation support.

## Decision
Adopt **Dio** as the primary HTTP networking engine.

## Alternatives Considered
1. *http package*: Lacks built-in interceptors and native request cancellation tokens.

## Consequences
- Centralized interceptors for logging, error conversion, and caching headers.
- Strongly typed exception mapping via `NetworkException`.
