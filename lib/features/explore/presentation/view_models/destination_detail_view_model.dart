import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/destination.dart';
import '../../data/repositories/explore_repository.dart';
import 'explore_view_model.dart';

final destinationDetailViewModelProvider =
    AsyncNotifierProviderFamily<
      DestinationDetailViewModel,
      Destination,
      String
    >(() {
      return DestinationDetailViewModel();
    });

class DestinationDetailViewModel
    extends FamilyAsyncNotifier<Destination, String> {
  @override
  Future<Destination> build(String arg) async {
    return _fetchDetail(arg);
  }

  Future<Destination> _fetchDetail(String id) async {
    final repository = ref.read(exploreRepositoryProvider);
    final result = await repository.getDestinationDetail(id);

    return result.fold(
      onSuccess: (destination) => destination,
      onFailure: (exception) => throw exception,
    );
  }

  Future<void> toggleFavorite() async {
    final current = state.value;
    if (current == null) return;

    final repository = ref.read(exploreRepositoryProvider);
    await repository.toggleFavorite(current.id);

    final isFav = await repository.isFavorite(current.id);
    final updated = current.copyWith(isFavorite: isFav);
    state = AsyncValue.data(updated);

    // Synchronize explore list view model
    ref.read(exploreViewModelProvider.notifier).toggleFavorite(current.id);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchDetail(arg));
  }
}
