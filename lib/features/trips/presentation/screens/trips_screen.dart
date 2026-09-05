import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../view_models/trips_view_model.dart';
import '../widgets/qr_scanner_view.dart';
import '../widgets/trip_card.dart';

class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsState = ref.watch(tripsViewModelProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tripsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => QrScannerView(
                    onTripDecrypted: (data) => _importTrip(ref, data),
                  ),
                ),
              );
            },
            tooltip: 'Import Trip via QR',
          ),
        ],
      ),
      body: tripsState.when(
        data: (trips) {
          if (trips.isEmpty) {
            return AppEmptyState(
              title: l10n.tripsNoTrips,
              subtitle: l10n.tripsNoTripsSubtitle,
              actionLabel: 'Plan a Trip',
              onAction: () => context.push('/trips/create'),
            );
          }

          final now = DateTime.now();
          final upcomingTrips =
              trips.where((t) => t.startDate.isAfter(now)).toList()
                ..sort((a, b) => a.startDate.compareTo(b.startDate));

          final pastTrips =
              trips.where((t) => t.startDate.isBefore(now)).toList()
                ..sort((a, b) => b.startDate.compareTo(a.startDate));

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              if (upcomingTrips.isNotEmpty) ...[
                Text(
                  l10n.tripsUpcoming,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...upcomingTrips.asMap().entries.map(
                  (entry) {
                    final index = entry.key;
                    final trip = entry.value;
                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 400 + (index * 100)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(30 * (1 - value), 0),
                            child: child,
                          ),
                        );
                      },
                      child: TripCard(
                        trip: trip,
                        onTap: () => context.push('/trips/${trip.id}'),
                        onDelete: () => ref
                            .read(tripsViewModelProvider.notifier)
                            .deleteTrip(trip.id),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              if (pastTrips.isNotEmpty) ...[
                Text(
                  l10n.tripsPast,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...pastTrips.asMap().entries.map(
                  (entry) {
                    final index = entry.key;
                    final trip = entry.value;
                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 400 + (index * 100)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(30 * (1 - value), 0),
                            child: child,
                          ),
                        );
                      },
                      child: TripCard(
                        trip: trip,
                        onTap: () => context.push('/trips/${trip.id}'),
                        onDelete: () => ref
                            .read(tripsViewModelProvider.notifier)
                            .deleteTrip(trip.id),
                      ),
                    );
                  },
                ),
              ],
            ],
          );
        },
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: 3,
          itemBuilder: (ctx, idx) => const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.md),
            child: AppSkeleton(height: 180),
          ),
        ),
        error: (err, _) => AppErrorState(message: err.toString()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/trips/create'),
        label: Text(l10n.tripsPlanNew),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _importTrip(WidgetRef ref, Map<String, dynamic> data) async {
    final db = ref.read(appDatabaseProvider);
    final tripData = data['trip'] as Map<String, dynamic>;
    final itemsData = data['items'] as List<dynamic>;

    final newTripId =
        'imported_${DateTime.now().millisecondsSinceEpoch}';

    await db.transaction(() async {
      await db.into(db.trips).insert(
        TripsCompanion.insert(
          id: newTripId,
          title: '${tripData['title'] as String} (Imported)',
          destinationId: tripData['destinationId'] as String,
          startDate: DateTime.parse(tripData['startDate'] as String),
          endDate: DateTime.parse(tripData['endDate'] as String),
          coverImageUrl: Value(tripData['coverImageUrl'] as String?),
        ),
      );

      for (final item in itemsData) {
        final i = item as Map<String, dynamic>;
        await db.into(db.itineraryItems).insert(
          ItineraryItemsCompanion.insert(
            id: 'imported_${i['id'] as String}_${DateTime.now().microsecondsSinceEpoch}',
            tripId: newTripId,
            title: i['title'] as String,
            dayNumber: i['dayNumber'] as int,
            sortOrder: i['sortOrder'] as int,
            locationName: Value(i['locationName'] as String?),
            latitude: Value(i['latitude'] as double?),
            longitude: Value(i['longitude'] as double?),
          ),
        );
      }
    });
  }
}
