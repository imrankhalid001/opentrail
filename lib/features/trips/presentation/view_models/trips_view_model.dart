import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../data/repositories/trip_repository.dart';

final tripsStreamProvider = StreamProvider<List<Trip>>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.watchAllTrips();
});

class TripsViewModel extends Notifier<AsyncValue<List<Trip>>> {
  @override
  AsyncValue<List<Trip>> build() {
    final stream = ref.watch(tripsStreamProvider);
    return stream;
  }

  Future<void> createTrip({
    required String title,
    required String destinationId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final repository = ref.read(tripRepositoryProvider);
    await repository.createTrip(
      TripsCompanion.insert(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        destinationId: destinationId,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  Future<void> deleteTrip(String id) async {
    final repository = ref.read(tripRepositoryProvider);
    await repository.deleteTrip(id);
  }
}

final tripsViewModelProvider =
    NotifierProvider<TripsViewModel, AsyncValue<List<Trip>>>(
      TripsViewModel.new,
    );
