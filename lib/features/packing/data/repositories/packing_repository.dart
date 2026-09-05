import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';

final packingRepositoryProvider = Provider<PackingRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return PackingRepositoryImpl(db: db);
});

abstract class PackingRepository {
  Stream<List<PackingItem>> watchPackingItems(String tripId);
  Future<void> addItem(PackingItemsCompanion item);
  Future<void> togglePacked(String id, bool isPacked);
  Future<void> deleteItem(String id);
  Future<void> generateSmartList(
    String tripId,
    double temperature,
    bool isRainy,
  );
}

class PackingRepositoryImpl implements PackingRepository {
  final AppDatabase db;

  PackingRepositoryImpl({required this.db});

  @override
  Stream<List<PackingItem>> watchPackingItems(String tripId) {
    return (db.select(
      db.packingItems,
    )..where((t) => t.tripId.equals(tripId))).watch();
  }

  @override
  Future<void> addItem(PackingItemsCompanion item) {
    return db.into(db.packingItems).insert(item);
  }

  @override
  Future<void> togglePacked(String id, bool isPacked) {
    return (db.update(db.packingItems)..where((t) => t.id.equals(id))).write(
      PackingItemsCompanion(isPacked: Value(isPacked)),
    );
  }

  @override
  Future<void> deleteItem(String id) {
    return (db.delete(db.packingItems)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> generateSmartList(
    String tripId,
    double temperature,
    bool isRainy,
  ) async {
    final items = <PackingItemsCompanion>[];

    // Basic essentials
    _add(items, tripId, 'Passport & ID', 'Documents');
    _add(items, tripId, 'Travel Insurance', 'Documents');
    _add(items, tripId, 'Phone Charger', 'Electronics');
    _add(items, tripId, 'Toothbrush & Paste', 'Toiletries');

    // Weather-based
    if (isRainy) {
      _add(items, tripId, 'Umbrella', 'Clothing');
      _add(items, tripId, 'Rain Jacket', 'Clothing');
    }

    if (temperature > 25) {
      _add(items, tripId, 'Sunscreen', 'Toiletries');
      _add(items, tripId, 'Sunglasses', 'Accessories');
      _add(items, tripId, 'Shorts & T-shirts', 'Clothing');
    } else if (temperature < 15) {
      _add(items, tripId, 'Warm Jacket', 'Clothing');
      _add(items, tripId, 'Gloves & Scarf', 'Clothing');
    }

    await db.batch((batch) {
      for (final item in items) {
        batch.insert(db.packingItems, item, mode: InsertMode.insertOrIgnore);
      }
    });
  }

  void _add(
    List<PackingItemsCompanion> list,
    String tripId,
    String name,
    String category,
  ) {
    list.add(
      PackingItemsCompanion.insert(
        id: '${tripId}_${name.replaceAll(' ', '_').toLowerCase()}',
        tripId: tripId,
        itemName: name,
        category: category,
      ),
    );
  }
}
