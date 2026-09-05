import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';

final journeyRepositoryProvider = Provider<JourneyRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return JourneyRepositoryImpl(db: db);
});

abstract class JourneyRepository {
  Stream<List<Trip>> watchAllTrips();
  Stream<List<Favorite>> watchAllFavorites();
  Stream<List<AchievementsStatistic>> watchAchievements();
  Future<void> checkAchievements();
}

class JourneyRepositoryImpl implements JourneyRepository {
  final AppDatabase db;

  JourneyRepositoryImpl({required this.db});

  @override
  Stream<List<Trip>> watchAllTrips() {
    return db.select(db.trips).watch();
  }

  @override
  Stream<List<Favorite>> watchAllFavorites() {
    return db.select(db.favorites).watch();
  }

  @override
  Stream<List<AchievementsStatistic>> watchAchievements() {
    return db.select(db.achievementsStatistics).watch();
  }

  @override
  Future<void> checkAchievements() async {
    final trips = await db.select(db.trips).get();
    final favorites = await db.select(db.favorites).get();

    final achievements = <AchievementsStatisticsCompanion>[];

    // First Trip
    if (trips.isNotEmpty) {
      achievements.add(
        AchievementsStatisticsCompanion.insert(
          id: 'first_trip',
          title: 'Adventure Awaits',
          category: 'Travel',
          isUnlocked: const Value(true),
          progressValue: const Value(1),
        ),
      );
    }

    // Global Explorer (5+ countries)
    final uniqueCountries = trips.map((t) => t.destinationId).toSet().length;
    achievements.add(
      AchievementsStatisticsCompanion.insert(
        id: 'global_explorer',
        title: 'Global Explorer',
        category: 'Travel',
        isUnlocked: Value(uniqueCountries >= 5),
        progressValue: Value(uniqueCountries),
      ),
    );

    // Stargazer (10+ favorites)
    achievements.add(
      AchievementsStatisticsCompanion.insert(
        id: 'stargazer',
        title: 'Stargazer',
        category: 'Planning',
        isUnlocked: Value(favorites.length >= 10),
        progressValue: Value(favorites.length),
      ),
    );

    await db.batch((batch) {
      for (final ach in achievements) {
        batch.insert(
          db.achievementsStatistics,
          ach,
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }
}
