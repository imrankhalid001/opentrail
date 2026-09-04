import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_projects/core/errors/app_exception.dart';
import 'package:flutter_projects/core/result/result.dart';
import 'package:flutter_projects/features/explore/data/models/destination.dart';
import 'package:flutter_projects/features/explore/data/repositories/explore_repository.dart';
import 'package:flutter_projects/features/explore/presentation/view_models/explore_view_model.dart';

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
    var list = mockDestinations;
    if (region.toLowerCase() != 'all' && region.isNotEmpty) {
      list = list
          .where((d) => d.region.toLowerCase() == region.toLowerCase())
          .toList();
    }
    if (query.isNotEmpty) {
      list = list
          .where((d) => d.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    return Success(list);
  }

  @override
  Future<Result<Destination, AppException>> getDestinationDetail(
    String id,
  ) async {
    final found = mockDestinations.firstWhere((d) => d.id == id);
    return Success(found);
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

  test('ExploreViewModel builds and loads destinations', () async {
    final container = ProviderContainer(
      overrides: [
        exploreRepositoryProvider.overrideWithValue(
          MockExploreRepository([sampleDest]),
        ),
      ],
    );

    addTearDown(container.dispose);

    final state = await container.read(exploreViewModelProvider.future);
    expect(state.length, 1);
    expect(state.first.name, 'Japan');
  });

  test('ExploreViewModel toggleFavorite updates favorite status', () async {
    final container = ProviderContainer(
      overrides: [
        exploreRepositoryProvider.overrideWithValue(
          MockExploreRepository([sampleDest]),
        ),
      ],
    );

    addTearDown(container.dispose);

    await container.read(exploreViewModelProvider.future);
    await container
        .read(exploreViewModelProvider.notifier)
        .toggleFavorite('jp');

    final updatedState = container.read(exploreViewModelProvider).value;
    expect(updatedState?.first.isFavorite, true);
  });
}
