import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/app_empty_state.dart';
import '../../core/widgets/app_error_state.dart';
import '../../features/explore/presentation/screens/destination_detail_screen.dart';
import '../../features/explore/presentation/screens/explore_screen.dart';
import '../../features/map/presentation/screens/map_screen.dart';
import '../../features/weather/presentation/screens/weather_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/explore',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainShellScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/explore',
            builder: (context, state) => const ExploreScreen(),
          ),
          GoRoute(
            path: '/weather',
            builder: (context, state) => const WeatherScreen(),
          ),
          GoRoute(path: '/map', builder: (context, state) => const MapScreen()),
          GoRoute(
            path: '/trips',
            builder: (context, state) => const Scaffold(
              body: SafeArea(
                child: AppEmptyState(
                  title: 'My Trips',
                  subtitle:
                      'Trip planning & offline itinerary builder (Milestone 4)',
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => Scaffold(
              appBar: AppBar(title: const Text('Settings')),
              body: const SafeArea(
                child: AppEmptyState(
                  title: 'Application Settings',
                  subtitle: 'Theme customization, localization, & units',
                ),
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/destination/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return DestinationDetailScreen(destinationId: id);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: SafeArea(
        child: AppErrorState(message: 'Page not found: ${state.uri.path}'),
      ),
    ),
  );
});

class MainShellScreen extends StatelessWidget {
  final Widget child;

  const MainShellScreen({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/weather')) return 1;
    if (location.startsWith('/map')) return 2;
    if (location.startsWith('/trips')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/explore');
        break;
      case 1:
        context.go('/weather');
        break;
      case 2:
        context.go('/map');
        break;
      case 3:
        context.go('/trips');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.wb_sunny_outlined),
            selectedIcon: Icon(Icons.wb_sunny),
            label: 'Weather',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.card_travel_outlined),
            selectedIcon: Icon(Icons.card_travel),
            label: 'Trips',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
