# Navigation & Routing Architecture 🚦

OpenTrail uses **GoRouter** for declarative type-safe navigation and deep linking support.

## Router Configuration (`lib/app/router/app_router.dart`)

```dart
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainShellScreen(),
      ),
      GoRoute(
        path: '/destination/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DestinationDetailScreen(destinationId: id);
        },
      ),
    ],
    errorBuilder: (context, state) => AppErrorState(
      message: 'Page not found: ${state.uri.path}',
    ),
  );
});
```

---

## Navigation Rules
1. Views trigger navigation using `context.go()` or `context.push()`.
2. Complex objects are passed using IDs via path/query parameters rather than passing large mutable state objects over route arguments.
