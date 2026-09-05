import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return TripRepositoryImpl(db: db);
});

abstract class TripRepository {
  Stream<List<Trip>> watchAllTrips();
  Future<List<Trip>> getAllTrips();
  Future<void> createTrip(TripsCompanion trip);
  Future<void> deleteTrip(String id);

  // Favorites methods
  Future<void> toggleFavorite(String id, String type);
  Stream<bool> watchIsFavorite(String id, String type);
  Stream<List<Favorite>> watchAllFavorites();
}

class TripRepositoryImpl implements TripRepository {
  final AppDatabase db;

  TripRepositoryImpl({required this.db});

  @override
  Stream<List<Trip>> watchAllTrips() {
    return db.select(db.trips).watch();
  }

  @override
  Future<List<Trip>> getAllTrips() {
    return db.select(db.trips).get();
  }

  @override
  Future<void> createTrip(TripsCompanion trip) {
    return db.into(db.trips).insert(trip);
  }

  @override
  Future<void> deleteTrip(String id) {
    return (db.delete(db.trips)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> toggleFavorite(String id, String type) async {
    final query = db.select(db.favorites)
      ..where((f) => f.id.equals(id) & f.entityType.equals(type));
    final existing = await query.getSingleOrNull();

    if (existing != null) {
      await (db.delete(
        db.favorites,
      )..where((f) => f.id.equals(id) & f.entityType.equals(type))).go();
    } else {
      await db
          .into(db.favorites)
          .insert(FavoritesCompanion.insert(id: id, entityType: type));
    }
  }

  @override
  Stream<bool> watchIsFavorite(String id, String type) {
    return (db.select(db.favorites)
          ..where((f) => f.id.equals(id) & f.entityType.equals(type)))
        .watch()
        .map((list) => list.isNotEmpty);
  }

  @override
  Stream<List<Favorite>> watchAllFavorites() {
    return db.select(db.favorites).watch();
  }
}
