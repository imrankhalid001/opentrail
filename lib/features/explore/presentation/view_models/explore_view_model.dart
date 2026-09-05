import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/destination.dart';
import '../../data/repositories/explore_repository.dart';

final selectedRegionProvider = StateProvider<String>((ref) => 'All');
final searchQueryProvider = StateProvider<String>((ref) => '');

final exploreViewModelProvider =
    AsyncNotifierProvider<ExploreViewModel, List<Destination>>(() {
      return ExploreViewModel();
    });

class ExploreViewModel extends AsyncNotifier<List<Destination>> {
  @override
  Future<List<Destination>> build() async {
    final region = ref.watch(selectedRegionProvider);
    final query = ref.watch(searchQueryProvider);
    return _fetchDestinations(region: region, query: query);
  }

  Future<List<Destination>> _fetchDestinations({
    required String region,
    required String query,
  }) async {
    final repository = ref.read(exploreRepositoryProvider);
    final result = await repository.getDestinations(
      region: region,
      query: query,
    );

    return result.fold(
      onSuccess: (destinations) => destinations,
      onFailure: (exception) => throw exception,
    );
  }

  void setRegion(String region) {
    ref.read(selectedRegionProvider.notifier).state = region;
  }

  void setSearchQuery(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
  }

  Future<void> toggleFavorite(String destinationId) async {
    final repository = ref.read(exploreRepositoryProvider);
    await repository.toggleFavorite(destinationId);

    final currentList = state.value;
    if (currentList == null) return;

    final isFav = await repository.isFavorite(destinationId);
    final updatedList = currentList.map((dest) {
      if (dest.id.toLowerCase() == destinationId.toLowerCase()) {
        return dest.copyWith(isFavorite: isFav);
      }
      return dest;
    }).toList();

    state = AsyncValue.data(updatedList);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _fetchDestinations(
        region: ref.read(selectedRegionProvider),
        query: ref.read(searchQueryProvider),
      ),
    );
  }
}
