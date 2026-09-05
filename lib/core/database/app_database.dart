import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// 1. Destinations Table
@DataClassName('DestinationEnt')
class Destinations extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get country => text()();
  TextColumn get countryCode => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get summary => text()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// 2. Favorites Table
class Favorites extends Table {
  TextColumn get id => text()(); // Entity ID (country code, etc)
  TextColumn get entityType => text()(); // 'destination', 'place', 'weather'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id, entityType};
}

// 3. Trips Table
class Trips extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get destinationId => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  RealColumn get budget => real().nullable()();
  TextColumn get coverImageUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 4. Itinerary Items Table
class ItineraryItems extends Table {
  TextColumn get id => text()();
  TextColumn get tripId =>
      text().references(Trips, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  IntColumn get dayNumber => integer()();
  IntColumn get sortOrder => integer()();
  TextColumn get locationName => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 5. Cached API Responses Table
class CachedApiResponses extends Table {
  TextColumn get endpointKey => text()();
  TextColumn get jsonPayload => text()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {endpointKey};
}

// 6. Packing Items Table
class PackingItems extends Table {
  TextColumn get id => text()();
  TextColumn get tripId =>
      text().references(Trips, #id, onDelete: KeyAction.cascade)();
  TextColumn get itemName => text()();
  TextColumn get category => text()();
  BoolColumn get isPacked => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// 7. Achievements & Statistics Table
class AchievementsStatistics extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get category => text()();
  BoolColumn get isUnlocked => boolean().withDefault(const Constant(false))();
  IntColumn get progressValue => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Destinations,
    Favorites,
    Trips,
    ItineraryItems,
    CachedApiResponses,
    PackingItems,
    AchievementsStatistics,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          // Add the missing tables from Milestone 4 expansion
          await m.createTable(packingItems);
          await m.createTable(achievementsStatistics);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'opentrail.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
