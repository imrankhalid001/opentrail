import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../data/repositories/journey_repository.dart';

@immutable
class JourneyState {
  final List<Trip> trips;
  final List<Favorite> favorites;
  final List<AchievementsStatistic> achievements;

  const JourneyState({
    this.trips = const [],
    this.favorites = const [],
    this.achievements = const [],
  });

  int get visitedCountriesCount =>
      trips.map((t) => t.destinationId).toSet().length;
}

class JourneyViewModel extends Notifier<AsyncValue<JourneyState>> {
  @override
  AsyncValue<JourneyState> build() {
    final tripsAsync = ref.watch(journeyTripsStreamProvider);
    final favsAsync = ref.watch(journeyFavsStreamProvider);
    final achsAsync = ref.watch(journeyAchsStreamProvider);

    // Break the loop: We only call checkAchievements when trips or favorites change,
    // and we do it in a way that doesn't block the current build.
    ref.listen(journeyTripsStreamProvider, (prev, next) {
      ref.read(journeyRepositoryProvider).checkAchievements();
    });
    ref.listen(journeyFavsStreamProvider, (prev, next) {
      ref.read(journeyRepositoryProvider).checkAchievements();
    });

    // Provide default empty state while waiting for initial data
    return AsyncValue.data(
      JourneyState(
        trips: tripsAsync.value ?? [],
        favorites: favsAsync.value ?? [],
        achievements: achsAsync.value ?? [],
      ),
    );
  }
}

final journeyTripsStreamProvider = StreamProvider(
  (ref) => ref.watch(journeyRepositoryProvider).watchAllTrips(),
);
final journeyFavsStreamProvider = StreamProvider(
  (ref) => ref.watch(journeyRepositoryProvider).watchAllFavorites(),
);
final journeyAchsStreamProvider = StreamProvider(
  (ref) => ref.watch(journeyRepositoryProvider).watchAchievements(),
);

final journeyViewModelProvider =
    NotifierProvider<JourneyViewModel, AsyncValue<JourneyState>>(
      JourneyViewModel.new,
    );
