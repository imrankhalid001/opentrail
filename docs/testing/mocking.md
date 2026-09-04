# Mocking Strategy 🎭

OpenTrail uses **Riverpod Provider Overrides** and explicit fake/mock service implementations for fast, deterministic unit and widget testing.

## Riverpod Override Example in Widget Tests

```dart
final container = ProviderContainer(
  overrides: [
    weatherRepositoryProvider.overrideWithValue(MockWeatherRepository()),
  ],
);
```
