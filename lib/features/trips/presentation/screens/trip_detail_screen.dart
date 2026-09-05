import 'package:cached_network_image/cached_network_image.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../view_models/trips_view_model.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import '../widgets/qr_share_dialog.dart';

final tripItineraryProvider =
    StreamProvider.family<List<ItineraryItem>, String>((ref, tripId) {
      final db = ref.watch(appDatabaseProvider);
      return (db.select(db.itineraryItems)
            ..where((t) => t.tripId.equals(tripId))
            ..orderBy([(t) => drift.OrderingTerm.asc(t.sortOrder)]))
          .watch();
    });

class TripDetailScreen extends ConsumerWidget {
  final String tripId;

  const TripDetailScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsState = ref.watch(tripsViewModelProvider);
    final itineraryState = ref.watch(tripItineraryProvider(tripId));
    final theme = Theme.of(context);

    return tripsState.when(
      data: (trips) {
        final trip = trips.firstWhere((t) => t.id == tripId);
        final dateFormat = DateFormat('MMM d, yyyy');

        return Scaffold(
          appBar: AppBar(
            title: Text(trip.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_rounded),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  if (itineraryState.hasValue) {
                    showDialog<void>(
                      context: context,
                      builder: (context) => QrShareDialog(
                        trip: trip,
                        items: itineraryState.value!,
                      ),
                    );
                  }
                },
                tooltip: 'Share Trip',
              ),
              IconButton(
                icon: const Icon(Icons.inventory_2_outlined),
                onPressed: () => context.push('/trips/$tripId/packing'),
                tooltip: 'Packing List',
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'trip_banner_$tripId',
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primaryContainer,
                        theme.colorScheme.tertiaryContainer,
                      ],
                    ),
                  ),
                  child: trip.coverImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: trip.coverImageUrl!,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${dateFormat.format(trip.startDate)} - ${dateFormat.format(trip.endDate)}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Itinerary',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              _buildElevationChart(theme),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: itineraryState.when(
                  data: (items) {
                    if (items.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('No plans yet.'),
                            const SizedBox(height: AppSpacing.md),
                            AppButton(
                              label: 'Add Activity',
                              onPressed: () =>
                                  _addActivity(context, ref, items.length),
                            ),
                          ],
                        ),
                      );
                    }

                    return ReorderableListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                      ),
                      itemCount: items.length,
                      onReorderItem: (oldIndex, newIndex) {
                        _reorderItems(ref, items, oldIndex, newIndex);
                      },
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          key: ValueKey(item.id),
                          leading: CircleAvatar(
                            child: Text((index + 1).toString()),
                          ),
                          title: Text(item.title),
                          subtitle: Text(item.locationName ?? 'No location'),
                          trailing: const Icon(Icons.drag_handle),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text('Error: $err')),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () =>
                _addActivity(context, ref, itineraryState.value?.length ?? 0),
            child: const Icon(Icons.add_location_alt_outlined),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: AppSkeleton(height: 200))),
      error: (err, _) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }

  Widget _buildElevationChart(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'Adventure Elevation (m)',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 80,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    const FlSpot(0, 500),
                    const FlSpot(1, 800),
                    const FlSpot(2, 600),
                    const FlSpot(3, 1200),
                    const FlSpot(4, 900),
                    const FlSpot(5, 1500),
                  ],
                  isCurved: true,
                  color: theme.colorScheme.primary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _reorderItems(
    WidgetRef ref,
    List<ItineraryItem> items,
    int oldIndex,
    int newIndex,
  ) async {
    if (newIndex > oldIndex) newIndex -= 1;

    final db = ref.read(appDatabaseProvider);
    final list = List<ItineraryItem>.from(items);
    final moved = list.removeAt(oldIndex);
    list.insert(newIndex, moved);

    await db.transaction(() async {
      for (int i = 0; i < list.length; i++) {
        await (db.update(db.itineraryItems)
              ..where((t) => t.id.equals(list[i].id)))
            .write(ItineraryItemsCompanion(sortOrder: drift.Value(i)));
      }
    });
  }

  void _addActivity(BuildContext context, WidgetRef ref, int currentCount) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Activity'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'What are you planning?'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final db = ref.read(appDatabaseProvider);
                await db
                    .into(db.itineraryItems)
                    .insert(
                      ItineraryItemsCompanion.insert(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        tripId: tripId,
                        title: controller.text,
                        dayNumber: 1,
                        sortOrder: currentCount,
                      ),
                    );
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
