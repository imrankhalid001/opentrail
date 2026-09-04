# Local Database Architecture (Drift SQLite) 🗄️

OpenTrail uses **Drift (v2.x)** (a type-safe, reactive SQLite persistence engine for Flutter) for 100% on-device offline storage.

---

## 1. Solution Selection & Evaluation

### Why Drift?
- **Type-Safe Compile-Time SQL Queries**: Query errors and type mismatches are caught during code compilation rather than at runtime.
- **Relational Integrity**: Supports foreign keys, unique constraints, indices, and cascade deletions (essential for trip itineraries and packing lists).
- **Reactive Stream Support**: Queries expose `Stream<List<T>>` or `Stream<T>`, allowing UI screens to automatically rebuild whenever SQLite tables are updated.
- **Auto-Migrations**: Built-in migration framework for database schema versioning.

### Storage Alternatives Evaluated

| Option | Type | Relational Support | Reactive Streams | Decision |
| :--- | :--- | :---: | :---: | :---: |
| **Drift (SQLite)** | Relational SQLite | ✅ Yes (Foreign Keys) | ✅ Yes | **Selected** |
| **Hive** | Key-Value NoSQL | ❌ No | ⚠️ Partial | Rejected |
| **Isar** | Document NoSQL | ⚠️ Limited | ✅ Yes | Rejected |
| **sqflite** | Raw SQLite Strings | ✅ Yes | ❌ No | Rejected |

---

## 2. Relational Schema Table Definitions

Drift manages 9 primary SQLite relational schema tables in OpenTrail:

```dart
// 1. Destinations Table
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

// 2. Places / Attractions Table
class Places extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  TextColumn get destinationId => text().references(Destinations, #id)();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get summary => text()();
  RealColumn get rating => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 3. Favorites Table
class Favorites extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()(); // 'destination', 'place', 'weather'
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 4. Trips Table
class Trips extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get destinationId => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  RealColumn get budget => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 5. Itinerary Items Table
class ItineraryItems extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text().references(Trips, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  IntColumn get dayNumber => integer()();
  IntColumn get sortOrder => integer()();
  TextColumn get locationName => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 6. Packing Items Table
class PackingItems extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text().references(Trips, #id, onDelete: KeyAction.cascade)();
  TextColumn get itemName => text()();
  TextColumn get category => text()();
  BoolColumn get isPacked => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// 7. Cached API Responses Table
class CachedApiResponses extends Table {
  TextColumn get endpointKey => text()();
  TextColumn get jsonPayload => text()();
  DateTimeColumn get timestamp => dateTime()();

  @override
  Set<Column> get primaryKey => {endpointKey};
}

// 8. User Preferences Table
class UserPreferences extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

// 9. Achievements & Statistics Table
class AchievementsStatistics extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get category => text()();
  BoolColumn get isUnlocked => boolean().withDefault(const Constant(false))();
  IntColumn get progressValue => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
```
