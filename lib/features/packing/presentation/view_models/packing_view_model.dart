import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../data/repositories/packing_repository.dart';

final packingItemsProvider = StreamProvider.family<List<PackingItem>, String>((
  ref,
  tripId,
) {
  return ref.watch(packingRepositoryProvider).watchPackingItems(tripId);
});

class PackingViewModel
    extends FamilyNotifier<AsyncValue<List<PackingItem>>, String> {
  @override
  AsyncValue<List<PackingItem>> build(String arg) {
    return ref.watch(packingItemsProvider(arg));
  }

  Future<void> togglePacked(String id, bool isPacked) async {
    await ref.read(packingRepositoryProvider).togglePacked(id, isPacked);
  }

  Future<void> deleteItem(String id) async {
    await ref.read(packingRepositoryProvider).deleteItem(id);
  }

  Future<void> generateSmartList(double temp, bool isRainy) async {
    await ref
        .read(packingRepositoryProvider)
        .generateSmartList(arg, temp, isRainy);
  }

  Future<void> addItem(String name, String category) async {
    await ref
        .read(packingRepositoryProvider)
        .addItem(
          PackingItemsCompanion.insert(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            tripId: arg,
            itemName: name,
            category: category,
          ),
        );
  }
}

final packingViewModelProvider =
    NotifierProviderFamily<
      PackingViewModel,
      AsyncValue<List<PackingItem>>,
      String
    >(PackingViewModel.new);
