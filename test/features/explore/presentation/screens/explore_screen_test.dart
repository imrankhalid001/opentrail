import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_projects/core/errors/app_exception.dart';
import 'package:flutter_projects/core/result/result.dart';
import 'package:flutter_projects/features/explore/data/models/destination.dart';
import 'package:flutter_projects/features/explore/data/repositories/explore_repository.dart';
import 'package:flutter_projects/features/explore/presentation/screens/explore_screen.dart';

class MockExploreRepository implements ExploreRepository {
  final List<Destination> mockDestinations;
  final Set<String> _favs = {};

  MockExploreRepository(this.mockDestinations);

  @override
  bool isFavorite(String id) => _favs.contains(id.toLowerCase());

  @override
  Future<void> toggleFavorite(String id) async {
    final key = id.toLowerCase();
    if (_favs.contains(key)) {
      _favs.remove(key);
    } else {
      _favs.add(key);
    }
  }

  @override
  Future<Result<List<Destination>, AppException>> getDestinations({
    String region = 'All',
    String query = '',
  }) async {
    return Success(mockDestinations);
  }

  @override
  Future<Result<Destination, AppException>> getDestinationDetail(
    String id,
  ) async {
    return Success(mockDestinations.first);
  }
}

void main() {
  const sampleDest = Destination(
    id: 'jp',
    name: 'Japan',
    country: 'Japan',
    countryCode: 'JP',
    flagEmoji: '🇯🇵',
    capital: 'Tokyo',
    region: 'Asia',
    subregion: 'Eastern Asia',
    population: 125800000,
    latitude: 36.2048,
    longitude: 138.2529,
    languages: ['Japanese'],
    currencies: ['Yen'],
    summary: 'Japan summary.',
  );

  testWidgets('ExploreScreen renders destination cards and region chips', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          exploreRepositoryProvider.overrideWithValue(
            MockExploreRepository([sampleDest]),
          ),
        ],
        child: const MaterialApp(home: ExploreScreen()),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Explore Destinations'), findsOneWidget);
    expect(find.text('Japan'), findsOneWidget);
    expect(find.text('Tokyo'), findsOneWidget);
  });
}
