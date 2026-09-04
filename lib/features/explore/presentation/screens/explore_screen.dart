import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../view_models/explore_view_model.dart';
import '../widgets/destination_card.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  static const List<String> regions = [
    'All',
    'Africa',
    'Americas',
    'Asia',
    'Europe',
    'Oceania',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exploreState = ref.watch(exploreViewModelProvider);
    final selectedRegion = ref.watch(selectedRegionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Explore Destinations'), elevation: 0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: AppSearchBar(
              hint: 'Search destinations, countries, capitals...',
              onChanged: (query) {
                ref
                    .read(exploreViewModelProvider.notifier)
                    .setSearchQuery(query);
              },
              onClear: () {
                ref.read(exploreViewModelProvider.notifier).setSearchQuery('');
              },
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: regions.length,
              separatorBuilder: (ctx, idx) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final region = regions[index];
                return AppChip(
                  label: region,
                  isSelected:
                      selectedRegion.toLowerCase() == region.toLowerCase(),
                  onSelected: (_) {
                    ref
                        .read(exploreViewModelProvider.notifier)
                        .setRegion(region);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: exploreState.when(
              data: (destinations) {
                if (destinations.isEmpty) {
                  return const AppEmptyState(
                    title: 'No Destinations Found',
                    subtitle: 'Try searching for another country or changing the region filter.',
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(exploreViewModelProvider.notifier).refresh();
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.70,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: destinations.length,
                    itemBuilder: (context, index) {
                      final dest = destinations[index];
                      return DestinationCard(
                        destination: dest,
                        onTap: () {
                          context.push('/destination/${dest.id}');
                        },
                        onFavoriteToggle: (_) {
                          ref
                              .read(exploreViewModelProvider.notifier)
                              .toggleFavorite(dest.id);
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.70,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 6,
                itemBuilder: (ctx, idx) => const AppSkeleton(height: 220),
              ),
              error: (error, _) => Center(
                child: AppErrorState(
                  message: error.toString(),
                  onRetry: () {
                    ref.read(exploreViewModelProvider.notifier).refresh();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
