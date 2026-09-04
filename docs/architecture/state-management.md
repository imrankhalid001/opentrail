# State Management & Dependency Injection Strategy 📊

OpenTrail uses **Riverpod (`flutter_riverpod: ^2.6.1`)** as its unified State Management and Dependency Injection framework.

---

## 1. Solution Selection & Ecosystem Evaluation

### Why Riverpod?
- **Compile-Time Safety**: Dependencies and state providers are declared as top-level final variables, eliminating runtime `ProviderNotFoundException` or unregistered locator crashes.
- **Context-Independent**: Providers can be read, watched, and listened to safely outside the Flutter `BuildContext` widget tree.
- **Native Async State Monad (`AsyncValue<T>`)**: Encapsulates `data`, `loading`, and `error` states naturally without requiring custom UI wrapper boilerplate.
- **Testability**: Simplifies unit and widget testing via `ProviderContainer(overrides: [...])` without needing mock `BuildContext` instances.

### Alternatives Evaluated

| Option | Pros | Cons | Decision |
| :--- | :--- | :--- | :---: |
| **Riverpod (v2.x)** | Compile-time safe, `AsyncValue`, testable, zero context dependency | Mild learning curve | **Selected** |
| **Provider** | Standard Flutter package | No compile-time safety; prone to runtime tree lookup errors | Rejected |
| **BLoC / Cubit** | Predictable event streams | High boilerplate requirements for simple state updates | Rejected |
| **GetX** | Minimal syntax | Bypasses standard Flutter mechanics; relies on implicit mutable global singletons | Rejected |

---

## 2. Dependency Injection Strategy

Riverpod manages application dependencies as a compile-time safe dependency graph:

```dart
// 1. Service Provider (REST HTTP Client)
final dioProvider = Provider<Dio>((ref) => createDioClient());

final weatherServiceProvider = Provider<WeatherService>((ref) {
  final dio = ref.watch(dioProvider);
  return WeatherServiceImpl(dio: dio);
});

// 2. Repository Provider (Single Source of Truth)
final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  final service = ref.watch(weatherServiceProvider);
  final database = ref.watch(databaseProvider);
  return WeatherRepositoryImpl(service: service, database: database);
});

// 3. ViewModel Provider (Notifier)
final weatherViewModelProvider =
    AsyncNotifierProvider<WeatherViewModel, WeatherData>(() {
  return WeatherViewModel();
});
```

---

## 3. ViewModel Architecture & Rules

1. **Notifier Inheritance**: ViewModels extend `Notifier<T>` (for synchronous state) or `AsyncNotifier<T>` (for asynchronous state).
2. **Zero `BuildContext` References**: ViewModels must **never** accept or hold `BuildContext` references.
3. **Immutable State**: ViewModels expose immutable state data models created via `@freezed`.
4. **Side-Effects Handling**: One-off events (snackbars, dialogs) are handled using `ref.listen()` in the View layer or single-shot event streams.

---

## 4. UI Presentation State Strategy

ViewModels expose state using `AsyncValue<T>`, covering all 4 presentation states:

```dart
class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherViewModelProvider);

    return weatherState.when(
      // 1. Data State
      data: (weather) {
        if (weather.forecasts.isEmpty) {
          // 2. Empty State
          return const AppEmptyState(
            title: 'No Weather Data Available',
            subtitle: 'Try searching for another destination.',
          );
        }
        return WeatherContentView(weather: weather);
      },
      // 3. Loading State
      loading: () => const AppSkeleton(height: 200),
      // 4. Error State
      error: (error, stack) => AppErrorState(
        message: error.toString(),
        onRetry: () => ref.read(weatherViewModelProvider.notifier).refresh(),
      ),
    );
  }
}
```

---

## 5. State Refresh & Invalidation Strategy

- **Manual Refresh**: Views trigger refresh by calling `ref.read(provider.notifier).refresh()` or invalidating the provider via `ref.invalidate(weatherViewModelProvider)`.
- **Pull-To-Refresh**: Wrapped inside `RefreshIndicator(onRefresh: () async => ref.invalidate(provider))`.
- **Stale-While-Revalidate**: Repositories immediately return local SQLite cached data while background-refreshing stale network REST endpoints.
