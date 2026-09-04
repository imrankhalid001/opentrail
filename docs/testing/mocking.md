# Mocking & Overrides Strategy 🎭

OpenTrail uses Riverpod's native provider overrides for mocking dependencies during testing.

```dart
final container = ProviderContainer(
  overrides: [
    weatherRepositoryProvider.overrideWithValue(MockWeatherRepository()),
  ],
);
```
