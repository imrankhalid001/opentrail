import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_projects/core/database/app_database.dart';
import 'package:flutter_projects/features/trips/data/repositories/trip_repository.dart';

void main() {
  late AppDatabase db;
  late TripRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = TripRepositoryImpl(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  test('createTrip adds a trip to the database', () async {
    final trip = TripsCompanion.insert(
      id: '1',
      title: 'Japan Trip',
      destinationId: 'jp',
      startDate: DateTime(2024, 10, 1),
      endDate: DateTime(2024, 10, 10),
    );

    await repository.createTrip(trip);
    final trips = await repository.getAllTrips();

    expect(trips.length, 1);
    expect(trips.first.title, 'Japan Trip');
  });

  test('toggleFavorite adds and removes a favorite', () async {
    await repository.toggleFavorite('jp', 'destination');
    var isFav = await repository.watchIsFavorite('jp', 'destination').first;
    expect(isFav, true);

    await repository.toggleFavorite('jp', 'destination');
    isFav = await repository.watchIsFavorite('jp', 'destination').first;
    expect(isFav, false);
  });
}
