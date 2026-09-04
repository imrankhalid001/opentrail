# Dependency Injection Strategy 💉

OpenTrail uses **Riverpod** as both its State Management and Dependency Injection framework.

## Why Riverpod over ServiceLocator / GetIt?
1. **Compile-Time Safety**: Dependencies are declared as top-level `Provider`s, preventing runtime `ProviderNotFoundException` or unregistered locator crashes.
2. **Scoping & Mocking**: Riverpod allows seamless provider overrides in widget and unit tests using `ProviderContainer(overrides: [...])`.
3. **No Context Dependency**: Providers can be read and listened to outside the BuildContext widget tree safely.

---

## Provider Hierarchy Example

```dart
// 1. Service Provider
final weatherServiceProvider = Provider<WeatherService>((ref) {
  final dio = ref.watch(dioProvider);
  return WeatherServiceImpl(dio: dio);
});

// 2. Repository Provider
final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final service = ref.watch(weatherServiceProvider);
  final db = ref.watch(databaseProvider);
  return WeatherRepositoryImpl(service: service, database: db);
});

// 3. ViewModel Notifier Provider
final weatherViewModelProvider = NotifierProvider<WeatherViewModel, AsyncValue<WeatherData>>(() {
  return WeatherViewModel();
});
```
